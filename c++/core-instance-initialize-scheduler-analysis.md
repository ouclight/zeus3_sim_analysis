# C++ `CoreInstanceRuntime::Impl::initialize_scheduler` 解析

分析对象：`cpp/src/runtime/core_instance.cpp:325`

分析基线：分支 `feature/python-multi-device-port-fabric`，commit `c921fe6bbf62`

## 1. 函数定位

```cpp
void initialize_scheduler() {
    ...
}
```

`initialize_scheduler()` 不是启动线程，也不直接运行仿真循环。它负责把已经创建好的核状态、程序、成本模型和各类 executor 装配到该核的 `TickScheduler` 中，并注册执行期间需要调用的回调。

函数返回后，该核才具备被 `CoreInstanceRuntime::step()` 逐 tick 推进的完整条件。

其总体作用可以概括为：

```text
CoreState + decoded program + CostModel
                    │
                    ▼
              TickScheduler
                    │
       ┌────────────┼──────────────┐
       ▼            ▼              ▼
 CT dispatch     data commit     SI readiness
 callback        callbacks       callback
       │            │              │
       ▼            ▼              ▼
 CTExecutor /    MemoryMaterializer  等待远端 SO
 inline config   + effect log        queue token/data
       │            │              │
       └────────────┴──────────────┘
                    │
                    ▼
         trace、mail、内存副作用与同步
```

## 2. 调用位置和前置条件

`initialize_scheduler()` 由 `CoreInstanceRuntime::Impl::initialize()` 调用，前置步骤依次是：

1. `prepare_weight_ddr()`：取得或创建本核 LDG/weight DDR；
2. `load_program()`：从本 die 的 GDG 读取并解码程序；
3. `initialize_core_state()`：初始化 DID、CID、PC、栈和舍入模式；
4. `wire_executors()`：创建 CT/LD/LW/PE/DT/VP/ST/SI/SO executor；
5. `wire_remote_contexts()`：把 LD/ST/LW/SI/SO 接到 `MemoryRouter`；
6. `wire_siso_queues()`：把 SI/SO 接到系统级 inter-core queue 矩阵；
7. `initialize_scheduler()`：完成调度器和回调 wiring。

因此该函数中的 lambda 可以安全使用 `state`、各 executor、router、queue 和 effect log。它们都由同一个 `CoreInstanceRuntime::Impl` 拥有或借用，并覆盖 scheduler 的执行生命周期。

## 3. 源码分段

函数可以分成六步：

```cpp
void initialize_scheduler() {
    // 1. 选择 trace detail
    scheduler.set_trace_detail(...);

    // 2. 初始化 TickScheduler
    scheduler.init(...);

    // 3. 注册 CT/inline-config 执行回调
    scheduler.set_ct_callback(...);

    // 4. 注册跨核 CT wait/send 回调
    scheduler.set_ct_sync_callbacks(...);

    // 5. 按执行模式创建 MemoryMaterializer，注册八类 data executor 回调
    register_data_executor_pipeline(...);

    // 6. 为 SI 注册额外的远端输入就绪门控
    scheduler.set_executor_ready_to_execute_callback(ExecutorType::SI, ...);
}
```

## 4. 第一步：选择 trace detail

代码位置：`core_instance.cpp:326-332`。

```cpp
scheduler.set_trace_detail(select_trace_detail(
    !ctx.trace_output.empty(),
    !ctx.trace_json.empty()));
```

选择规则是：

| 请求的输出 | `TraceDetail` | 行为 |
|---|---|---|
| JSON trace | `Full` | 保存标量字段以及 mnemonic、fields、timing features |
| 仅 binary trace | `Compact` | 保存 binary 所需标量，跳过重型字段复制 |
| 都未请求 | `None` | 不保留事件对象 |

JSON 优先于 binary；两者同时请求时仍选择 `Full`。

即使 detail 为 `None`，scheduler 仍会精确统计事件数量，并记录当前 step 是否产生事件。这是因为 global fast-forward 的安全判断依赖“当前 tick 是否有可观察事件”，不能因关闭 trace 输出而改变调度结果。

值得注意的是，这里的保留级别直接由 `trace_output` 和 `trace_json` 路径决定，而不是由 `pipeline.collect_trace` 直接决定。

## 5. 第二步：初始化 `TickScheduler`

代码位置：`core_instance.cpp:333`。

```cpp
scheduler.init(&state, &program, &ctx.cost_model, ctx.execution_mode);
```

传入的三个指针均不转移所有权：

- `state`：本核体系结构状态；
- `program`：本核已解码指令序列；
- `cost_model`：共享成本模型。

`TickScheduler::init()` 会完成以下工作：

### 5.1 重置本核调度状态

- `tick_ = 0`
- `done_ = false`
- `next_ct_dispatch_tick_ = 0`
- 清空本核 mailbox
- 清空 trace/event 计数
- 清空 `pending_effect_seqs_`

因此每个新建 `CoreInstanceRuntime` 都从独立的本核 tick 0、空本地 mailbox 和空 pending-effect 集合开始。

### 5.2 决定是否启用 calibrated pipeline

仅当以下条件同时成立时启用：

```text
execution_mode == TraceOnly
并且 cost_model != nullptr
并且 cost_model.pipeline_enabled()
```

启用后：

- CT dispatch gap 使用 `cost_model.ct_dispatch_gap_cycles()`；
- executor 可以维护多个 inflight instruction；
- 允许模型描述 issue gap、latency、retire order 和硬件 overlap；
- functional effect 顺序 barrier 被绕过，因为 trace-only 不产生普通 payload 副作用。

其他模式使用传统单 inflight executor 状态机，CT dispatch gap 固定为 1 tick。

这里容易混淆：`AnalysisOnly` 虽然也不物化 payload，但不会自动启用 calibrated multi-inflight path；当前条件明确只认 `TraceOnly`。

### 5.3 建立 semantic-effect 顺序屏障

CT dispatch 为成功接收的每条指令分配递增的 `semantic_seq`。对于非 mail-only 的数据指令，入 executor FIFO 后会把序号登记到 `pending_effect_seqs_`。

scheduler 内部设置两类 barrier：

1. CT 指令若访问 L2，必须等待所有更早的 data effect commit；
2. data executor commit 时，必须等待所有序号更小的 data effect commit。

传统 functional/analysis 路径的判定为：

```text
不存在 pending semantic_seq < 当前 semantic_seq
```

这保证 payload 内存副作用遵循程序语义顺序，同时 executor 的倒计时仍可并行推进。

mail-only 指令不登记为 pending effect，也绕过 data commit barrier。

calibrated trace-only 模式直接允许 barrier 通过，以免人为串行化不同 executor lane，破坏硬件 overlap 的 timing 校准。

## 6. 第三步：注册 CT 与 inline-config 回调

代码位置：`core_instance.cpp:335-356`。

```cpp
scheduler.set_ct_callback(
    [this](const Instruction& inst, CoreState& s,
           uint64_t semantic_seq) {
        ...
    });
```

该回调由 `CTDispatchUnit::tick()` 在指令成功通过所有 dispatch gate 后同步调用。这里的“成功通过”表示：

1. PC 有效且当前指令不是 `CT_ED`；
2. 若 CT 指令访问 L2，其 effect-order barrier 已通过；
3. 若为 `CT_WAIT`，跨核同步 token 已就绪并消费；
4. 指令要求的本地 recv-mail token 已就绪并消费；
5. 已分配新的 `semantic_seq`。

回调分两条路径。

### 6.1 inline-config 指令

```cpp
if (inst.is_inline_config()) {
    handle_inline_config(inst, s, *vp_exec);
    runtime_effect_log.record_inline_config(...);
    return;
}
```

VP_SET*/PE_SETM 等配置指令虽然 opcode 所属 executor 可能是 VP/PE，但硬件/Python 语义是在 dispatch thread 立即修改配置寄存器，不进入 VP/PE data FIFO。

因此它们：

- 在 CT dispatch 阶段立即执行；
- 通过 `handle_inline_config()` 修改状态或 VP 配置；
- 以 inline-config 类型写入 runtime effect log；
- 不再进入普通 `CTExecutor` 路径。

### 6.2 普通 CT 指令

```cpp
const uint16_t resolved_ct_ids = resolve_ct_ids(inst, s);
ct_exec->execute(inst, s);
```

`resolve_ct_ids()` 在 CT 执行前解析 CT_WAIT/CT_SEND 的目标 mask：

- `ID_IE != 0`：`IDs-Rx/Imme` 直接作为立即数 mask；
- `ID_IE == 0`：`IDs-Rx/Imme` 选择一个 live `Rx`，读取其值作为 mask；
- 最终只保留 `NUM_MAIL_SLOTS` 范围内的位。

之所以在执行前解析，是因为寄存器模式依赖 dispatch 时刻的 live `Rx`，effect log 必须记录实际使用的同步 ID，而不是只看静态指令字段。

随后：

- `CTExecutor::execute()` 执行寄存器、控制流或 CT L2 操作；
- mail-only CT 用 `record_mail_only()` 记录；
- 其他 CT 用 `record_ct_op()` 记录；
- 日志同时记录 `semantic_seq`、当前 scheduler tick 和解析后的 CT mask。

### 6.3 CT 回调在一个 tick 中的位置

`TickScheduler::step()` 的顺序是：

```text
1. 所有 data executor 先 tick/commit
2. CT dispatch 尝试处理一条指令
3. 收集 CT 和 executor trace events
4. 判断 CT_ED 且所有 executor idle
5. tick_++
```

所以某 tick 内先提交的数据副作用，可以被同 tick 后执行的 CT 指令观察到。CT callback 中读取的 `scheduler.current_tick()` 是递增前的当前 tick。

## 7. 第四步：注册跨核 CT 同步回调

代码位置：`core_instance.cpp:358-371`。

只有 `ctx.sync_context != nullptr` 时才注册。`CoreSyncContext` 提供：

```cpp
bool try_consume_ct_wait(CoreId waiter, uint16_t source_mask);
void send_ct_signal(CoreId sender, uint16_t target_mask);
```

### 7.1 CT_WAIT 回调

```cpp
const uint16_t mask = resolve_ct_ids(inst, s);
if (mask == 0) return true;
return ctx.sync_context->try_consume_ct_wait(
    CoreId{ctx.die, ctx.core}, mask);
```

语义为：

- mask 为 0 时无需等待；
- 否则尝试从系统级同步上下文消费指定 source cores 的 token；
- token 不齐时返回 false，CT dispatch 返回 `STALLED_SYNC`；
- PC 不前进、CT callback 不执行、trace 不产生。

该 gate 位于本地 recv-mail 消费之前，因此跨核同步未满足时不会提前丢失本核 mailbox token。

### 7.2 CT_SEND 回调

```cpp
const uint16_t mask = resolve_ct_ids(inst, s);
if (mask != 0) {
    ctx.sync_context->send_ct_signal(CoreId{ctx.die, ctx.core}, mask);
}
```

CT_SEND 的调用时序为：

```text
CT callback 执行
  → 构造 CT trace event
  → 向系统级目标 core 发布 CT signal
  → 发布本地 send-mail token
  → PC++
```

在普通 system launch 中，`sync_context` 通常是 launch-local token matrix；daemon resident 模式可以传入 session/fabric 级上下文，使不同 device worker 的独立 `run_launch` 互相唤醒。

若 `sync_context == nullptr`，CT_WAIT/CT_SEND 不具备系统级 token 行为；指令自身的 CT 执行和普通 local mail 逻辑仍照常运行。

## 8. 第五步：按模式建立 data executor completion pipeline

代码位置：`core_instance.cpp:373-380`。

### 8.1 `MemoryMaterializer` 的创建条件

```cpp
if (ctx.materialize_memory) {
    memory_materializer = std::make_unique<MemoryMaterializer>(...);
}
```

只有 pipeline 要求真实 payload 仿真时才创建。它聚合 LD、LW、DT、PE、VP、ST、SO、SI executor，负责在指令 commit 时执行真实的数据读取、计算、写入或传输。

典型关系为：

| ExecutionMode | `materialize_memory` | 普通 payload |
|---|---:|---|
| Functional | true | 执行 |
| FullDebug | true | 执行 |
| TraceOnly | false | 跳过 |
| AnalysisOnly | false | 跳过 |

实际值来自 `SimulationPipelineOptions`，调用者仍可构造自定义组合。

### 8.2 注册的 executor 类型

`register_data_executor_pipeline()` 为以下八类 executor 注册同一种 completion callback 框架：

```text
LD, LW, DT, PE, VP, ST, SO, SI
```

CT 不在这里，因为 CT 已由上一节的 dispatch callback 处理。

### 8.3 回调发生在 commit，而不是 enqueue/issue

非 CT 指令在 dispatch 时只完成：

- latch BR/RR/AR/VP/PE 配置快照；
- 分配 `semantic_seq`；
- 入对应 executor FIFO；
- 登记 pending effect。

真正的 data callback 要等 executor：

1. 从 FIFO 取出；
2. recv-mail 就绪；
3. 成本模型倒计时结束；
4. effect-order commit gate 通过；
5. 若是 SI，远端 queue readiness gate 通过。

之后才设置 `completion_tick` 并调用 `complete_data_executor()`。

### 8.4 completion callback 的执行顺序

`complete_data_executor()` 的顺序为：

```text
mail-only?
  ├─ 是：只 record_mail_only，结束
  └─ 否：
       1. plan_deferred_memory_op() 生成统一内存访问计划
       2. 可选地物化 payload 副作用
       3. record_executor_op() 记录 executor effect 和计划
```

执行计划总是先生成，因此 functional、trace-only 和 analysis-only 能共享一致的访问元数据。

### 8.5 不物化内存时的三个必要特例

`materializer == nullptr` 不等于完全不执行任何动作。为维持正确控制流和跨核调度，仍保留三个特例：

1. `LD` 且 `BAS-ARa == 30`：执行 runtime argument page 的小型控制加载，写入 shadow L2，使动态循环边界与 functional 模式一致；
2. `SO MOV`：向 outgoing inter-core queue 发布空 payload timing token；
3. `SI MOV`：消费对应 timing token。

这样 trace-only 不读取/写入 tensor payload，但仍保持 SO→SI 的 producer/consumer 时序。

### 8.6 commit 之后的动作

completion callback 成功返回后，`ExecutorUnit`：

- 调用 scheduler 内部 `did_commit`，从 pending effect 集合移除该 `semantic_seq`；
- 生成 trace end event；
- 最后发送该指令的 local send-mail token；
- 回到 IDLE 或从 inflight 集合退休。

send-mail 放在 payload effect 可见之后，避免消费者先看到同步 token、后看到数据。

## 9. 第六步：为 SI 增加 readiness gate

代码位置：`core_instance.cpp:381-385`。

```cpp
scheduler.set_executor_ready_to_execute_callback(
    ExecutorType::SI,
    [this](const QueuedInstruction& qi) {
        return si_exec->ready_to_execute(qi);
    });
```

此 gate 只注册到 SI executor，并在本地 cost countdown 已结束、准备 commit 时检查。

对非 SI MOV 指令，`ready_to_execute()` 直接返回 true。对 SIA_MOV/SIP_MOV：

1. 从指令的 DID/CID 计算 source core 的全局 peer slot；
2. 若没有配置 incoming queue，返回 true，保留兼容路径；
3. 若配置了 queue，则只有 queue 非空时才返回 true。

当 queue 为空时，SI 停留在 COMMIT/inflight-ready 状态：

- 不执行 payload callback；
- 不产生 trace end；
- 不发送 local mail；
- 后续 tick 继续检查。

这避免 SI 在远端 SO 尚未 commit 时读取陈旧 L2 数据或直接报错。

在 functional 模式，SO queue 元素携带真实 payload，SI commit 时 pop 并写本地 L2；在 trace-only 模式，元素为空，仅作为 timing token，SI 消费它但不写 tensor payload。

## 10. 单条数据指令的完整生命周期

```text
CTDispatchUnit 读取 program[PC]
        │
        ├─ executor FIFO 已满 → STALLED_QUEUE，PC 不变
        │
        ▼
latch 当前 BR/RR/AR/配置寄存器
分配 semantic_seq
enqueue 到 LD/LW/.../SI/SO FIFO
登记 pending effect（非 mail-only）
PC++
        │
        ▼
ExecutorUnit 等 recv-mail
        │
        ▼
按 CostModel 执行/倒计时
        │
        ▼
COMMIT gates
  ├─ 更早 effect 是否已提交？
  └─ SI source queue 是否就绪？
        │
        ▼
completion callback
  ├─ 生成 DeferredMemoryOp
  ├─ 可选物化 payload
  └─ 记录 RuntimeEffectLog
        │
        ▼
retire pending effect
生成 trace end
发送 local mail
```

## 11. 单条 CT 指令的完整生命周期

```text
CTDispatchUnit 读取 program[PC]
        │
        ├─ CT_ED → 标记 dispatch ended
        ├─ CT L2 被旧 effect 阻塞 → STALLED_EFFECT
        ├─ CT_WAIT token 不齐 → STALLED_SYNC
        └─ local recv-mail 不齐 → STALLED_MAIL
        │
        ▼
分配 semantic_seq
调用 initialize_scheduler 注册的 CT callback
  ├─ inline config → handle_inline_config
  └─ 普通 CT → CTExecutor::execute
记录 RuntimeEffectLog
生成 CT trace event
可选发布系统级 CT_SEND signal
发布 local send-mail
PC++
```

## 12. 与 `TickScheduler::step()` 的关系

`initialize_scheduler()` 只安装机制；实际触发点都在后续 `step()` 中：

| step 阶段 | 可能触发的本函数配置 |
|---|---|
| Phase 1：所有 executor tick | data completion callback、effect commit gate、SI readiness gate、mail send |
| Phase 2：CT dispatch | CT callback、CT wait/send callback、effect barrier |
| Phase 3：收集 events | 使用预先选择的 trace detail |
| Phase 4：完成判断 | CT_ED 且所有 executor idle 才 done |

executor 在 CT dispatch 之前推进，这个顺序是同 tick 可见性的基础。

## 13. 多核和多设备语义

每个 `CoreInstanceRuntime` 都有自己的：

- `TickScheduler`
- `CoreState`
- 本地 `Mailbox`
- `RuntimeEffectLog`
- executor 集合

而以下对象可以由 `SystemSimulator` 或 daemon fabric 在核间/设备间共享：

- `CoreSyncContext`：CT_WAIT/CT_SEND；
- `InterCoreQueue[][]`：SO/SI；
- `MemoryRouter` 指向的 `SystemMemoryContext`；
- fabric topology 和 memory mutex。

因此要区分两类“mail/sync”：

| 机制 | 状态位置 | 用途 |
|---|---|---|
| instruction `recv_mail/send_mail` | 本核 `TickScheduler::Mailbox` | 同一核 CT 与 executor lane 间依赖 |
| CT_WAIT/CT_SEND IDs | `CoreSyncContext` | 核间同步，可由 daemon 扩展到设备间 |
| SO/SI queue | 系统级 `InterCoreQueue` | 核间 payload 或 trace-only timing token 传输 |

`initialize_scheduler()` 正是把这三套机制接到同一个核级时序模型中的位置。

## 14. 异常、阻塞与风险点

### 14.1 回调异常直接向上传播

这些 lambda 没有本地 `try/catch`。CT executor、memory materializer、router、SI/SO peer 校验或队列操作抛出的异常，会穿过 `TickScheduler::step()`、`CoreInstanceRuntime::step()` 和 `SystemSimulator::run_launch()` 传播到外层。

### 14.2 SI 可无限等待

SI MOV 对已配置但始终为空的 incoming queue 会持续停在 commit gate。scheduler 将其视为外部事件等待；在 daemon 场景可以等另一个 device worker 的 SO，但生产者永远不发布时可能永久挂起。

### 14.3 CT_WAIT 可无限等待

CT_WAIT token 不齐时持续返回 `STALLED_SYNC`，同样没有本函数级 timeout 或 deadlock detector。

### 14.4 callback 捕获生命周期依赖 `CoreInstanceRuntime::Impl`

CT、sync 和 SI lambda 捕获 `this`；data callbacks 捕获 executor 指针并引用 `runtime_effect_log`。当前设计中 scheduler 和这些对象同属一个 `Impl`，正常执行安全，但不能把 scheduler 脱离该 runtime 单独保存或异步延长使用。

### 14.5 trace 输出开关也影响运行成本

JSON trace 会要求每条事件复制 mnemonic、fields 和 timing features；binary 只保留 compact scalar；无输出不保留事件。这不应改变语义，但会显著影响内存和 CPU 开销。

### 14.6 effect barrier 与 calibrated trace-only 的语义不同

functional/analysis 路径强调 payload 的语义顺序；calibrated trace-only 强调硬件 lane overlap。排查两个模式 timing 不一致时，应先确认差异是否来自这个有意的 barrier 策略，而不是直接判断为调度 bug。

## 15. 核心结论

`initialize_scheduler()` 的本质是为一个核建立四个边界：

1. **控制边界**：CT/inline-config 在 dispatch 时执行；
2. **数据边界**：普通 executor 指令在成本倒计时完成并通过 commit gate 后才产生副作用；
3. **同步边界**：local mail、系统级 CT token、SO/SI queue 分别解决不同范围的依赖；
4. **模式边界**：functional/full-debug 物化 payload，trace-only/analysis-only 保留计划和诊断语义，并对必要控制数据及 SISO timing 做最小模拟。

它没有负责推进仿真；真正推进由 `SystemSimulator` 的全局循环反复调用本核 `CoreInstanceRuntime::step()`，继而调用 `TickScheduler::step()` 完成。

## 16. 关键源码索引

- `cpp/src/runtime/core_instance.cpp:46-57`：CT ID mask 解析
- `cpp/src/runtime/core_instance.cpp:82-104`：核初始化顺序
- `cpp/src/runtime/core_instance.cpp:257-308`：executor 与 remote router wiring
- `cpp/src/runtime/core_instance.cpp:310-323`：SO/SI queue wiring
- `cpp/src/runtime/core_instance.cpp:325-386`：`initialize_scheduler()`
- `cpp/src/dispatch/tick_scheduler.cpp:30-81`：scheduler 初始化、effect barrier 和 executor commit gate
- `cpp/src/dispatch/tick_scheduler.cpp:97-140`：每 tick 的四阶段执行顺序
- `cpp/src/dispatch/tick_scheduler.cpp:161-177`：idle fast-forward 判定
- `cpp/src/dispatch/ct_dispatch.cpp:32-170`：CT 执行、同步/mail stall 与 data enqueue
- `cpp/src/dispatch/executor_unit.cpp:96-176`：传统 executor 状态机和 commit callback
- `cpp/src/dispatch/executor_unit.cpp:196-266`：calibrated pipeline retire/issue
- `cpp/src/runtime/data_executor_pipeline.cpp:16-50`：data completion pipeline
- `cpp/src/runtime/data_executor_pipeline.cpp:54-81`：八类 executor callback 注册
- `cpp/src/executor/si/si_executor.cpp:54-85`：SI readiness 与 trace-only token 消费
- `cpp/src/executor/si/si_executor.cpp:105-166`：SI MOV payload 接收
- `cpp/src/executor/so/so_executor.cpp:53-73`：trace-only SO timing token 发布
- `cpp/src/executor/so/so_executor.cpp:93-136`：SO MOV payload 发布
- `cpp/include/zeus3sim/trace/trace_event.h:78-99`：trace detail 选择
- `cpp/src/runtime/execution_mode.cpp:20-52`：execution mode 的 pipeline preset

