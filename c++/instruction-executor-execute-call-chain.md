# C++ 指令执行器 `execute()` 调用链解析

分析入口：`cpp/src/executor/ld/ld_executor.cpp:27`

分析基线：分支 `feature/python-multi-device-port-fabric`，commit `c921fe6bbf62`

## 1. 结论

`LDExecutor::execute()` 在生产运行路径中有两个直接调用点：

1. 正常 payload 物化路径：

```cpp
// cpp/src/runtime/memory_materializer.cpp:40
ld_exec_.execute(qi, state);
```

2. 不物化普通 payload 时，AR30 runtime-argument 控制加载的特例路径：

```cpp
// cpp/src/runtime/data_executor_pipeline.cpp:41
ld_executor->execute(qi, state);
```

正常 functional 路径的完整调用链是：

```text
SystemSimulator::run_launch()
  → CoreInstanceRuntime::step()
    → TickScheduler::step()
      → ExecutorUnit::tick()
        → execute_cb_(QueuedInstruction&, CoreState&)
          → complete_data_executor()
            → MemoryMaterializer::materialize(ExecutorType::LD, ...)
              → LDExecutor::execute()
                → LDExecutor::exec_ld_mov()
```

因此，具体 executor 的 `execute()` 通常不是在指令 dispatch 时调用，而是在对应 `ExecutorUnit` 完成时延倒计时并通过 commit gate 后调用。

CT 指令是例外。`CTExecutor::execute()` 由 CT dispatch callback 直接调用，不经过 `MemoryMaterializer`。

## 2. 需要区分的两层“executor”

代码中存在两个不同层次，容易因命名相似而混淆。

### 2.1 `ExecutorUnit`：时序与队列状态机

每个核的 `TickScheduler` 拥有八个 `ExecutorUnit`：

```text
LD, LW, ST, DT, VP, PE, SI, SO
```

`ExecutorUnit` 负责：

- 接收 dispatch 送来的 `QueuedInstruction`；
- FIFO 容量管理；
- 等待 recv-mail；
- 根据 `CostModel` 进行执行时延倒计时；
- 检查 effect-order 和 SI readiness；
- 在 commit 时调用 `execute_cb_`；
- 生成 trace end；
- 在数据副作用可见后发送 send-mail。

它不实现 LD_MOV 的 DDR→L2 数据搬运，也不实现 PE、VP 算法。

### 2.2 `LDExecutor` 等：指令 payload 语义实现

具体执行器包括：

- `CTExecutor`
- `LDExecutor`
- `LWExecutor`
- `DTExecutor`
- `PEExecutor`
- `VPExecutor`
- `STExecutor`
- `SOExecutor`
- `SIExecutor`

它们的 `execute()` 实现具体指令的数据或状态副作用。例如 `LDExecutor::execute()` 根据 mnemonic 分派到 `exec_ld_mov()`，完成 DDR/remote L2 到本地 L2 的 tile 搬运。

可以概括为：

```text
ExecutorUnit = 什么时候允许执行
具体 Executor = 执行什么副作用
```

## 3. 回调是在何处注册的

生产路径的关键不在 `LDExecutor::execute()` 本身，而在 `execute_cb_` 如何被绑定。

## 3.1 `CoreInstanceRuntime` 创建具体 executor

`CoreInstanceRuntime::Impl::wire_executors()` 创建本核所有具体执行器：

```cpp
ld_exec = std::make_unique<LDExecutor>(...);
lw_exec = std::make_unique<LWExecutor>(...);
pe_exec = std::make_unique<PEExecutor>(...);
...
```

随后 `wire_remote_contexts()` 为 LD/ST/LW/SI/SO 注入 `MemoryRouter`，`wire_siso_queues()` 为 SI/SO 注入跨核队列。

## 3.2 `initialize_scheduler()` 创建 `MemoryMaterializer`

代码位置：`cpp/src/runtime/core_instance.cpp:373-377`。

```cpp
if (ctx.materialize_memory) {
    memory_materializer = std::make_unique<MemoryMaterializer>(
        *ld_exec, *lw_exec, *dt_exec, *pe_exec, *vp_exec,
        *st_exec, *so_exec, *si_exec);
}
```

`MemoryMaterializer` 保存这八个具体 executor 的引用，是从统一 completion pipeline 分派到各具体 `execute()` 的适配层。

只有 `ctx.materialize_memory == true` 时才创建它。Functional 和 FullDebug 默认创建；TraceOnly 和 AnalysisOnly 默认不创建。

## 3.3 为八个 `ExecutorUnit` 注册 completion callback

代码位置：`cpp/src/runtime/core_instance.cpp:378-380` 和 `cpp/src/runtime/data_executor_pipeline.cpp:54-81`。

```cpp
register_data_executor_pipeline(
    scheduler,
    runtime_effect_log,
    memory_materializer.get(),
    ld_exec.get(), so_exec.get(), si_exec.get());
```

`register_data_executor_pipeline()` 对八种类型依次调用：

```cpp
scheduler.set_executor_callback(type, lambda);
```

注册的 lambda 最终调用：

```cpp
complete_data_executor(
    materializer, ld_executor, so_executor, si_executor,
    runtime_effect_log, type, qi, state);
```

注意：即使 `memory_materializer == nullptr`，八个 `ExecutorUnit` 的 completion callback 仍然会注册，因为 trace/analysis 模式仍需要生成 `DeferredMemoryOp`、记录 effect log，并维持部分控制与跨核 timing 语义。

## 3.4 callback 保存到哪个对象

`TickScheduler::set_executor_callback()` 根据 `ExecutorType` 找到自己的 executor slot：

```text
LD=0, LW=1, ST=2, DT=3, VP=4, PE=5, SI=6, SO=7
```

随后调用：

```cpp
executors_[idx].set_execute_callback(std::move(cb));
```

callback 最终保存在对应 `ExecutorUnit::execute_cb_` 成员中。

## 4. LD 指令何时进入 `ExecutorUnit`

`CTDispatchUnit::tick()` 读取 `program[state.PC]` 并识别 `inst.executor()`。

对 LD、LW、ST、DT、VP、PE、SI、SO 等非 CT 指令，不会立即调用具体 executor 的 `execute()`。dispatch 只做：

1. 检查对应 `ExecutorUnit` FIFO 是否已满；
2. snapshot 当前 BR、RR、AR、VP/PE 配置；
3. 构造 `QueuedInstruction`；
4. 分配 `semantic_seq`；
5. `executors[idx].enqueue(std::move(qi))`；
6. 将非 mail-only 指令登记为 pending effect；
7. `PC++`。

所以 LD 指令在 dispatch 时只是进入 LD `ExecutorUnit` 的 FIFO。

这样做的原因是：指令读取到的配置需要在 dispatch 时锁存，但数据副作用必须等成本模型定义的完成时间才能变得可见。

## 5. 谁推动 `ExecutorUnit`

系统级调用关系为：

```text
daemon run_device_launch() 或普通 case runner
        │
        ▼
SystemSimulator::run_launch()
        │
        ▼
对每个未完成的 CoreInstanceRuntime 调用 step()
        │
        ▼
CoreInstanceRuntime::Impl::step()
        │
        ▼
TickScheduler::step()
```

`TickScheduler::step()` 每个 tick 先推进全部八个 `ExecutorUnit`：

```cpp
for (auto& exec : executors_) {
    exec.tick(mailbox_, *cost_model_, tick_);
}
```

之后才尝试 dispatch 下一条 CT/数据指令。因此同一个 tick 内，先前指令的 executor commit 副作用对随后执行的 CT dispatch 可见。

## 6. 传统 executor 状态机如何触发 callback

非 calibrated pipeline 路径位于 `ExecutorUnit::tick()`，状态变化为：

```text
IDLE
  → 从 FIFO dequeue
WAIT_MAIL
  → recv-mail token 齐备
EXECUTING
  → CostModel 时延倒计时归零
COMMIT
  → effect-order gate 通过
  → SI readiness gate 通过
  → execute_cb_(qi, state)
  → retire pending effect
  → trace end
  → send-mail
  → IDLE
```

真正触发统一 completion callback 的代码位于：

```cpp
// cpp/src/dispatch/executor_unit.cpp:152-155
current_.completion_tick = current_tick;
if (execute_cb_ && core_state_) {
    execute_cb_(current_, *core_state_);
}
```

这里先设置 `completion_tick`，因此 `LDExecutor::execute()` 内的 `MemoryRouter` 访问可以把真实 commit tick 写入 effect/timing 信息。

callback 返回后才发送 instruction send-mail，确保消费者不会在 producer 数据副作用可见之前收到同步 token。

## 7. Calibrated trace-only pipeline 如何触发 callback

启用 calibrated pipeline 时，一个 `ExecutorUnit` 可以维护多个 inflight instruction。指令达到 `completion_tick` 且 commit/readiness gate 通过后，由：

```cpp
ExecutorUnit::retire_pipeline_instruction(...)
```

调用：

```cpp
active.qi.completion_tick = active.completion_tick;
if (execute_cb_ && core_state_) {
    execute_cb_(active.qi, *core_state_);
}
```

所以两种时序状态机的入口不同，但之后都进入同一个注册 callback，即 `complete_data_executor()`。

不过 calibrated pipeline 只在 `TraceOnly` 且 cost model 开启 pipeline 时使用；默认不物化普通 tensor payload，因此通常不会继续进入 `MemoryMaterializer::materialize()`，但 effect/timing callback 仍会执行。

## 8. `complete_data_executor()` 做什么

代码位置：`cpp/src/runtime/data_executor_pipeline.cpp:16-50`。

此函数是时序层和具体指令语义层之间的核心桥梁。

## 8.1 mail-only 指令

```cpp
if (qi.inst.is_mail_only()) {
    runtime_effect_log.record_mail_only(qi, executor_type);
    return;
}
```

LD_MAIL、LW_MAIL、SO_MAIL 等 mail-only 指令只记录 mail effect，不调用任何具体 executor 的 `execute()`。

mail token 的等待和发送由 `ExecutorUnit` 状态机处理。

## 8.2 先生成 deferred memory plan

对非 mail-only 指令，首先调用：

```cpp
DeferredMemoryOp plan = plan_deferred_memory_op(qi, executor_type);
```

该步骤生成统一的源/目标内存访问描述，使 functional、trace-only 和 analysis-only 路径使用一致的依赖分析元数据。

## 8.3 有 `MemoryMaterializer` 时

```cpp
if (materializer != nullptr) {
    materializer->materialize(executor_type, qi, state);
}
```

这是正常 Functional/FullDebug payload 路径。`MemoryMaterializer` 根据 `ExecutorType` 调用对应的具体 `execute()`。

## 8.4 无 `MemoryMaterializer` 时

TraceOnly/AnalysisOnly 默认不执行普通 tensor payload，但存在三个特例：

- LD 且 `BAS-ARa == 30`：直接调用 `LDExecutor::execute()`；
- SO：不调用 `SOExecutor::execute()`，改调 `publish_timing_token()`；
- SI：不调用 `SIExecutor::execute()`，改调 `consume_timing_token()`。

AR30 是 Zeus host ABI 的 runtime argument page。即使 trace-only 不搬运普通 tensor，也必须加载这页控制数据到 shadow L2，否则动态循环边界可能与 functional 运行不同。

SO/SI 的空 queue token 则保证不物化 payload 时仍保留 producer→consumer timing 顺序。

最后，所有非 mail-only 路径都会调用 `record_executor_op()` 记录 effect。

## 9. `MemoryMaterializer` 如何调用具体 `execute()`

代码位置：`cpp/src/runtime/memory_materializer.cpp:32-66`。

分派表如下：

| `ExecutorType` | 直接调用 |
|---|---|
| LD | `ld_exec_.execute(qi, state)` |
| LW | `lw_exec_.execute(qi, state)` |
| DT | `dt_exec_.execute(qi, state)` |
| PE | `pe_exec_.execute(qi, state)` |
| VP | `vp_exec_.execute(qi, state)` |
| ST | `st_exec_.execute(qi, state)` |
| SO | `so_exec_.execute(qi, state)` |
| SI | `si_exec_.execute(qi, state)` |

没有 CT 分支，因为 CT 不属于延迟 data completion pipeline。

## 10. `LDExecutor::execute()` 的两条生产调用路径

## 10.1 Functional/FullDebug 正常路径

```text
ExecutorUnit commit
  → complete_data_executor()
    → materializer != nullptr
      → MemoryMaterializer::materialize(LD)
        → ld_exec_.execute(qi, state)
```

满足条件：

- 指令类型为 LD；
- 不是 mail-only；
- `ctx.materialize_memory == true`；
- 已完成 cost countdown；
- effect commit gate 已通过。

## 10.2 TraceOnly/AnalysisOnly 的 AR30 特例

```text
ExecutorUnit commit
  → complete_data_executor()
    → materializer == nullptr
    → executor_type == LD
    → BAS-ARa == 30
      → ld_executor->execute(qi, state)
```

该路径绕过 `MemoryMaterializer`，但仍调用相同的 `LDExecutor::execute()` 实现。区别是初始化阶段的 LD executor 被接到 control shadow L2，以避免物化普通 tensor L2 payload。

## 11. `LDExecutor::execute()` 内部继续调用什么

入口代码：

```cpp
void LDExecutor::execute(QueuedInstruction& qi, CoreState&) {
    if (qi.inst.mnemonic.find("LD_MOV") != std::string::npos) {
        exec_ld_mov(qi.inst, qi);
    }
}
```

因此：

- `LD_MOV` 进入 `exec_ld_mov()`；
- `LD_MAIL/LW_MAIL` 不执行数据操作；实际上正常 pipeline 已在更上层对 mail-only 提前返回；
- 未识别为 `LD_MOV` 的 mnemonic 不产生 LD payload 副作用。

`exec_ld_mov()` 的主要工作是：

1. 取得 dispatch 时锁存的 source/destination BR、RR 和 AR offset；
2. 校验 LD/ST predecode contract；
3. 通过 `MemoryRouter` 判断本地/远端 GDG、LDG 或 remote L2；
4. 从源内存读取需要的 tile 范围；
5. 提取 tile payload；
6. 写入本地 L2；
7. 填写 `qi.src_range` 和 `qi.dst_range`，供 trace/effect log 使用。

## 12. CTExecutor 的调用路径不同

`CTExecutor::execute()` 的直接生产调用点位于：

```cpp
// cpp/src/runtime/core_instance.cpp:346
ct_exec->execute(inst, s);
```

完整路径是：

```text
TickScheduler::step()
  → CTDispatchUnit::tick()
    → ct_cb_(inst, state, semantic_seq)
      → CoreInstanceRuntime 注册的 lambda
        → CTExecutor::execute(inst, state)
```

CT 指令在 dispatch 时立即执行，不进入 `ExecutorUnit` FIFO，不等待 data executor 的 cost countdown。

但 CT 若访问 L2，会先经过 pending-effect barrier，防止越过更早尚未 commit 的 data memory effect。

## 13. inline VP/PE 配置也不调用普通 `execute()`

VP_SET*/PE_SETM 等 `is_inline_config()` 指令走 CT dispatch callback，但调用的是：

```cpp
handle_inline_config(inst, state, *vp_exec);
```

它们不会进入 VP/PE `ExecutorUnit`，也不会调用普通 `VPExecutor::execute()` 或 `PEExecutor::execute()`。这是因为配置寄存器写入在 dispatch 阶段立即生效。

## 14. 测试中的直接调用

除了生产运行路径，单元测试会绕过 scheduler，直接构造具体 executor 并调用 `execute()`，用于验证纯指令语义或异常条件。

与 LD 直接相关的例子是：

```text
cpp/tests/test_ld_st_predecode_contract.cpp:90
```

该测试直接调用 `ld.execute(ld_qi, state)`，验证非法 predecode 输入会抛异常。

其他测试也直接调用 CT、LW、PE、VP executor。这些不是实际 simulator launch 的调度路径，只是隔离测试入口。

## 15. 为什么在 commit 时才调用具体 `execute()`

把具体 payload 操作放在 commit，而不是 dispatch，解决了四个时序问题：

1. 成本模型：数据副作用应在指令完成时出现，而非刚入 FIFO 时出现；
2. mail 依赖：recv-mail 未就绪时不能提前执行；
3. 程序语义顺序：更早的 pending memory effect 未完成时，后续 effect 不能越过；
4. 跨核数据可见性：SI 必须等远端 SO 已将 payload/timing token 放入 queue。

commit 时先调用具体 `execute()`，再 retire effect、生成 trace end 和发送 mail，确保 trace 与消费者看到的数据可见点一致。

## 16. 一条 LD_MOV 的完整生产流程

```text
Decoder 已产生 Instruction(LD_MOV)
        │
        ▼
CTDispatchUnit::tick()
  ├─ snapshot BR/RR/AR
  ├─ 分配 semantic_seq
  └─ enqueue 到 LD ExecutorUnit FIFO
        │
        ▼
TickScheduler 后续 tick 推进 LD ExecutorUnit
  ├─ 等 recv-mail
  ├─ 按 CostModel 倒计时
  └─ 进入 COMMIT
        │
        ▼
通过 effect-order gate
设置 qi.completion_tick
        │
        ▼
execute_cb_(qi, state)
        │
        ▼
complete_data_executor()
  ├─ plan_deferred_memory_op()
  └─ MemoryMaterializer::materialize(LD)
        │
        ▼
LDExecutor::execute()
        │
        ▼
LDExecutor::exec_ld_mov()
  ├─ MemoryRouter resolve/read
  ├─ tile extraction
  ├─ local L2 write
  └─ 填写 src/dst trace range
        │
        ▼
record_executor_op()
retire pending effect
trace end
send-mail
```

## 17. 关键源码索引

- `cpp/src/executor/ld/ld_executor.cpp:27-32`：`LDExecutor::execute()`
- `cpp/src/executor/ld/ld_executor.cpp:34-242`：`exec_ld_mov()`
- `cpp/src/runtime/core_instance.cpp:257-279`：具体 executor 创建
- `cpp/src/runtime/core_instance.cpp:325-386`：scheduler callback wiring
- `cpp/src/runtime/data_executor_pipeline.cpp:16-50`：统一 completion pipeline 和 LD 特例
- `cpp/src/runtime/data_executor_pipeline.cpp:54-81`：八种 callback 注册
- `cpp/src/runtime/memory_materializer.cpp:32-66`：到具体 `execute()` 的分派
- `cpp/src/dispatch/executor_unit.cpp:96-176`：传统状态机的 callback 触发点
- `cpp/src/dispatch/executor_unit.cpp:196-215`：calibrated pipeline callback 触发点
- `cpp/src/dispatch/ct_dispatch.cpp:140-169`：数据指令 snapshot 和 enqueue
- `cpp/src/dispatch/ct_dispatch.cpp:61-138`：CT/inline-config dispatch 路径
- `cpp/src/dispatch/tick_scheduler.cpp:97-140`：每 tick 推进 executor 和 CT dispatch
- `cpp/src/runtime/system_simulator.cpp:329-355`：系统级循环调用各核 `step()`
- `cpp/src/runtime/core_instance.cpp:107-110`：核级 `step()` 调用 scheduler
- `cpp/src/runtime/core_instance.cpp:335-356`：`CTExecutor::execute()` 直接调用路径
- `cpp/tests/test_ld_st_predecode_contract.cpp:90`：LD executor 单元测试直接调用

