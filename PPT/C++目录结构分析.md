C++版代码位于 [cpp](/home/zhangds/Zeus3FunctionalSimulator/cpp)，整体采用“公共接口与实现分离、按功能模块分层”的目录结构。

# 1. 总体目录结构

```
cpp/
├── CMakeLists.txt                 # CMake构建配置
├── build_release.sh               # Release构建脚本
├── README.md                      # C++版使用及协议说明
│
├── examples/                      # 示例配置
│   ├── topology_single_device.json
│   └── topology_two_devices.json
│
├── include/zeus3sim/              # 公共头文件
│   ├── analysis/                  # 依赖冲突分析接口
│   ├── app/                       # Case和客户端应用接口
│   ├── config/                    # 配置与命令行接口
│   ├── core/                      # Core状态及基础数据结构
│   ├── daemon/                    # Daemon接口
│   ├── decoder/                   # 指令表示与译码接口
│   ├── dispatch/                  # CT、Executor和Tick调度接口
│   ├── executor/                  # 各类指令Executor接口
│   ├── isa/                       # ISA字段访问
│   ├── memory/                    # L2、DDR和端口地址接口
│   ├── runtime/                   # 系统运行时核心接口
│   ├── timing/                    # 性能Cost模型
│   └── trace/                     # Trace事件及读写接口
│
├── src/                           # C++实现代码
│   ├── analysis/
│   ├── app/
│   ├── config/
│   ├── core/
│   ├── daemon/
│   ├── decoder/
│   ├── dispatch/
│   ├── executor/
│   ├── memory/
│   ├── runtime/
│   ├── timing/
│   ├── trace/
│   ├── main.cpp                   # Daemon程序入口
│   └── oneshot_main.cpp           # One-shot程序入口
│
├── tools/                         # Trace、审计和单指令工具
├── tests/                         # C++单元测试与端到端测试
└── third_party/                   # 第三方依赖预留目录
```

# 2. 程序入口

## `src/main.cpp`

Daemon主程序入口，生成：

```
zeus3sim
```

主要职责：

- 解析命令行；
- 加载Topology和Timing配置；
- 启动Unix Socket；
- 运行Resident Daemon；
- 接受Runtime控制消息。

调用关系：

```
main.cpp
   │
   ▼
CLI Options
   │
   ▼
Daemon
   │
   ▼
Async Session / Device Worker
```

## `src/oneshot_main.cpp`

Case目录兼容入口，生成：

```
zeus3sim_oneshot
```

主要职责：

- 读取Case目录；
- 准备共享内存；
- 连接或临时启动Daemon；
- 注册Device；
- 提交Launch；
- 等待执行完成；
- Dump结果；
- 执行Golden Compare。

One-shot不绕过Daemon直接执行：

```
Case Folder
    │
    ▼
One-shot Client
    │
    ▼
Resident Daemon
    │
    ▼
SystemSimulator
```

# 3. `app/`：应用适配层

```
include/zeus3sim/app/
src/app/
├── case_runner
├── daemon_client
├── golden_comparator
└── inst_json_resolver
```

| 文件                 | 主要职责                         |
| -------------------- | -------------------------------- |
| `case_runner`        | 加载Case配置、准备执行并处理Dump |
| `daemon_client`      | 实现One-shot到Daemon的控制协议   |
| `golden_comparator`  | 比较仿真输出和Golden结果         |
| `inst_json_resolver` | 查找和解析ISA描述文件            |

这一层主要服务于传统Case运行，不属于Core指令执行热路径。

# 4. `daemon/`：常驻服务与控制面

```
include/zeus3sim/daemon/daemon.h
src/daemon/daemon.cpp
```

主要职责：

- 监听AF_UNIX Socket；
- 解析长度前缀JSON消息；
- 处理`hello`和`register`；
- 处理`enqueue_launch`；
- 管理Launch状态；
- 处理`query`和各种`wait`；
- 管理Per-Device Worker；
- 处理Snapshot和Shutdown；
- 映射POSIX SHM或memfd。

核心关系：

```
Runtime
   │ 控制消息
   ▼
Daemon
   │
   ├── Device Context
   ├── Launch Record
   ├── Device Queue
   └── Device Worker
            │
            ▼
      SystemSimulator
```

# 5. `runtime/`：系统运行核心

这是C++版最重要的系统组织层。

```
runtime/
├── system_simulator
├── core_instance
├── system_memory
├── memory_router
├── remote_fabric_service
├── fabric_topology
├── memory_layout
├── data_executor_pipeline
├── deferred_memory_op
├── memory_materializer
├── effect_log
├── runtime_effect_log
├── effect_log_bridge
└── execution_mode
```

| 模块                     | 主要职责                                  |
| ------------------------ | ----------------------------------------- |
| `system_simulator`       | 组织一次Launch中的Core、调度、同步和结果  |
| `core_instance`          | 封装单Core运行状态与Executor连接          |
| `system_memory`          | 统一管理系统级L2、GDG和Weight DDR         |
| `memory_router`          | 将访问路由到本地或远端Memory Owner        |
| `remote_fabric_service`  | 提供跨Device存储和同步服务                |
| `fabric_topology`        | 解析Device与四个Port的连接关系            |
| `memory_layout`          | 定义Resident Memory地址布局               |
| `data_executor_pipeline` | 连接Executor执行、Effect规划与Payload执行 |
| `deferred_memory_op`     | 描述延迟提交的Memory Operation            |
| `memory_materializer`    | 执行真实Payload读写                       |
| `effect_log`             | 记录指令的控制和Memory Effect             |
| `runtime_effect_log`     | 汇总一次Runtime Launch的动态Effect        |
| `effect_log_bridge`      | 将Executor结果转换为系统级Effect          |
| `execution_mode`         | 定义Functional等执行模式                  |

主要调用关系：

```
SystemSimulator
      │
      ├── CoreInstance
      ├── SystemMemory
      ├── FabricTopology
      ├── MemoryRouter
      └── RuntimeEffectLog
               │
               ▼
       DataExecutorPipeline
          ┌────┴────┐
          ▼         ▼
       Effect    Payload
```

# 6. `dispatch/`：指令调度层

```
dispatch/
├── tick_scheduler
├── ct_dispatch
├── executor_unit
└── mailbox
```

| 模块             | 主要职责                                   |
| ---------------- | ------------------------------------------ |
| `tick_scheduler` | 按逻辑Tick推进CT和所有Executor             |
| `ct_dispatch`    | 取指、执行CT指令并分派数据指令             |
| `executor_unit`  | 维护Executor队列、Latency、Issue Gap和退休 |
| `mailbox`        | 管理Executor之间的Send/Receive Mail        |

结构关系：

```
TickScheduler
   ├── CTDispatchUnit
   ├── Mailbox
   └── ExecutorUnit[8]
       ├── LD
       ├── LW
       ├── ST
       ├── DT
       ├── VP
       ├── PE
       ├── SI
       └── SO
```

这是C++版确定性离散时间调度的核心。

# 7. `executor/`：指令功能实现层

```
executor/
├── ct/
│   ├── ct_executor
│   └── ct_setb
├── ld/
│   └── ld_executor
├── lw/
│   └── lw_executor
├── st/
│   └── st_executor
├── dt/
│   └── dt_executor
├── vp/
│   ├── vp_executor
│   ├── vp_inline_config
│   ├── vp_lut
│   └── vp_stage_plan
├── pe/
│   ├── pe_executor
│   └── pe_gemm
├── si/
│   └── si_executor
├── so/
│   └── so_executor
└── ld_st_predecode_contract
```

| Executor | 主要功能                     |
| -------- | ---------------------------- |
| CT       | 控制流、寄存器操作和部分同步 |
| LD       | 将数据加载到L2               |
| LW       | 加载权重数据                 |
| ST       | 从L2向目标存储写回           |
| DT       | 数据搬运、重排及相关处理     |
| VP       | 向量计算、广播、归约和LUT    |
| PE       | 矩阵乘、卷积和累加计算       |
| SI/SO    | 流输入输出与Core间数据连接   |

`vp/`和`pe/`进一步拆分，是因为内部功能和计算模式较复杂。

# 8. `decoder/`与`isa/`：指令解释层

## `decoder/`

```
decoder/
├── decoder
├── instruction
└── opcode_classify.cpp
```

主要职责：

- 读取指令编码；
- 根据Opcode识别Mnemonic；
- 将字段解析为`Instruction`；
- 分类CT及数据Executor指令；
- 解析Mail相关信息。

## `isa/`

```
isa/
├── generated_fields.h
└── instruction_view.h
```

主要职责：

- 提供ISA字段名称；
- 统一访问指令字段；
- 减少字符串字段拼写错误；
- 与`inst.json`保持字段对齐。

`generated_fields.h`由工具根据ISA Schema生成。

# 9. `core/`：架构状态和基础类型

```
core/
├── core_state
├── address_range
├── tile_layout
├── df_utils.h
└── float2fixed
```

| 模块            | 主要职责                      |
| --------------- | ----------------------------- |
| `core_state`    | PC、寄存器和Core架构状态      |
| `address_range` | 表示和计算内存地址范围        |
| `tile_layout`   | Tensor Tile布局和地址映射     |
| `df_utils`      | BF16、FP8、整数等数据格式转换 |
| `float2fixed`   | 浮点到定点转换及舍入          |

这一层为Executor提供基础计算和状态表示。

# 10. `memory/`：基础存储模块

```
memory/
├── l2_buffer
├── ddr_manager
└── port_address_decoder
```

| 模块                   | 主要职责                        |
| ---------------------- | ------------------------------- |
| `l2_buffer`            | Core本地L2数据读写              |
| `ddr_manager`          | 管理GDG和Weight DDR地址块       |
| `port_address_decoder` | 解析`zeus3-port-v1`远端地址窗口 |

需要区分：

- `memory/`提供具体存储对象和地址解析原语；
- `runtime/memory_router`负责系统级本地/远端路由。

# 11. `timing/`：抽象性能模型

```
timing/
└── cost_model
```

主要职责：

- 加载Timing JSON；
- 提供指令Latency；
- 提供Issue Gap；
- 处理Drain策略；
- 处理退休顺序；
- 计算PE、VP及搬运指令的工作量特征；
- 支持命令行Cost覆盖。

输出给Scheduler的核心信息包括：

```
TimingEstimate
├── latency_cycles
├── issue_gap_cycles
├── drain_prior
└── retire_in_order
```

# 12. `trace/`：Timing Trace

```
trace/
├── trace_event.h
├── trace_writer
└── trace_reader
```

| 模块           | 主要职责                  |
| -------------- | ------------------------- |
| `trace_event`  | 定义Timing Event结构      |
| `trace_writer` | 将Trace写成二进制格式     |
| `trace_reader` | 读取二进制Trace供工具处理 |

与`tools/trace_export.cpp`、`trace_stats.cpp`配合完成：

```
Simulator
   │
   ▼
Binary Trace
   ├── JSON Export
   └── Statistics
```

# 13. `analysis/`：依赖冲突分析

```
analysis/
└── dependency_conflict_analyzer
```

主要职责：

- 读取动态Memory Effect；
- 构建Happens-Before关系；
- 按Memory Resource组织访问；
- 扫描重叠地址范围；
- 检测未排序的RAW、WAR和WAW；
- 生成文本及JSON报告；
- 支持`fail-on-conflict`。

# 14. `config/`：配置加载

```
config/
├── cli_options
└── config_loader
```

| 模块            | 主要职责                    |
| --------------- | --------------------------- |
| `cli_options`   | 解析Daemon和One-shot命令行  |
| `config_loader` | 读取Case的`init.json`等配置 |

主要配置包括：

- Case路径；
- Socket路径；
- Topology；
- Timing；
- Execution Mode；
- Trace；
- Conflict Analysis；
- Golden Compare。

# 15. `tools/`：辅助工具

```
tools/
├── trace_export.cpp
├── trace_stats.cpp
├── dependency_check.cpp
├── zeus3sim_step.cpp
├── bench_trace_detail.cpp
├── gen_isa_fields.py
├── check_field_names.py
└── audit_alignment.py
```

| 工具                   | 功能                                |
| ---------------------- | ----------------------------------- |
| `trace_export`         | 将二进制Trace转换为JSON             |
| `trace_stats`          | 统计Trace中的指令和事件             |
| `dependency_check`     | 离线运行依赖冲突分析                |
| `zeus3sim_step`        | 单指令Executor一致性测试            |
| `bench_trace_detail`   | 测试不同Trace Detail的调度开销      |
| `gen_isa_fields.py`    | 从ISA Schema生成字段定义            |
| `check_field_names.py` | 检查C++读取的字段是否合法           |
| `audit_alignment.py`   | 审计Python、C++和ISA Schema覆盖关系 |

# 16. `tests/`：测试体系

测试主要分为：

| 测试类别      | 代表文件                                        |
| ------------- | ----------------------------------------------- |
| 指令译码      | `test_decoder.cpp`                              |
| ISA Schema    | `test_isa_schema.cpp`                           |
| 调度与Mailbox | `test_scheduler.cpp`、`test_mailbox.cpp`        |
| 存储和地址    | `test_l2_buffer.cpp`、`test_remote_address.cpp` |
| 数值转换      | `test_df_parity.cpp`、`test_float2fixed.cpp`    |
| Executor语义  | `test_lw_executor.cpp`、VP/PE相关测试           |
| Timing模型    | `test_cost_model.cpp`                           |
| 依赖分析      | `test_dependency_conflict.cpp`                  |
| Runtime与系统 | `test_system_runtime.cpp`                       |
| 端到端Case    | `test_e2e.cpp`、`test_e2e.sh`                   |

# 17. 关键调用链总结

## Daemon运行链

```
main.cpp
  → daemon
  → register / enqueue_launch
  → Device Worker
  → SystemSimulator
  → CoreInstance
  → TickScheduler
  → CT Dispatch / Executor Unit
  → Data Executor Pipeline
  → Memory Router
  → Trace / Effect / Conflict
```

## One-shot运行链

```
oneshot_main.cpp
  → CaseRunner
  → DaemonClient
  → 临时或现有Daemon
  → SystemSimulator
  → Dump
  → GoldenComparator
```

一句话概括：

> C++版以`daemon`和`runtime`组织系统执行，以`dispatch`实现确定性调度，以`executor`实现指令功能，以`memory`和`runtime/memory_router`处理存储访问，并通过`trace`和`analysis`提供诊断能力。