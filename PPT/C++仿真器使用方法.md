C++版仿真器有两种主要使用方式：

1. One-shot模式：直接运行传统Case目录，适合功能验证和调试；
2. Resident Daemon模式：由Runtime注册共享内存并异步提交Launch，适合系统集成和连续运行。

# 1. 构建仿真器

环境要求：

- Linux或WSL；
- CMake 3.16及以上；
- 支持C++17的编译器；
- POSIX共享内存、Unix Domain Socket和`mmap`。

在仓库根目录执行：

```
cmake -S cpp -B cpp/build
cmake --build cpp/build -j
```

运行测试：

```
ctest --test-dir cpp/build --output-on-failure
```

如果只构建仿真器和工具，不构建测试：

```
cmake -S cpp -B cpp/build \
  -DZEUS3SIM_BUILD_TESTS=OFF

cmake --build cpp/build -j
```

主要生成文件：

| 程序                     | 用途                 |
| ------------------------ | -------------------- |
| `zeus3sim`               | Resident Daemon      |
| `zeus3sim_oneshot`       | Case目录兼容客户端   |
| `zeus3_trace_export`     | 二进制Trace转JSON    |
| `zeus3_trace_stats`      | Trace统计            |
| `zeus3_dependency_check` | 离线依赖冲突分析     |
| `zeus3sim_step`          | 单指令一致性验证工具 |

# 2. One-shot模式

One-shot适合直接运行包含`init.json`、指令和初始化数据的Case目录。

## 基本用法

```
cpp/build/zeus3sim_oneshot \
  -c <case_folder>
```

例如：

```
cpp/build/zeus3sim_oneshot \
  -c test/debug/<case_name>
```

One-shot会自动完成：

```
读取init.json
      │
      ▼
加载指令、输入和权重
      │
      ▼
创建Resident Shared Memory
      │
      ▼
启动临时Daemon
      │
      ▼
Register Device
      │
      ▼
Enqueue Launch
      │
      ▼
Wait Launch
      │
      ▼
Dump输出并进行Golden Compare
      │
      ▼
关闭临时Daemon
```

如果没有通过`--socket`指定已有Daemon，One-shot会自动启动临时Daemon，并在任务结束后关闭。

## 使用已有Daemon

先启动Daemon：

```
cpp/build/zeus3sim \
  --daemon \
  --socket /tmp/zeus3sim.sock
```

再运行Case：

```
cpp/build/zeus3sim_oneshot \
  -c <case_folder> \
  --socket /tmp/zeus3sim.sock
```

这种方式可以让多个Case复用同一个Daemon进程。

# 3. 选择执行模式

C++版支持四种执行模式。

## Functional

```
cpp/build/zeus3sim_oneshot \
  -c <case_folder> \
  --execution-mode functional
```

功能：

- 执行控制流；
- 执行真实Tensor Payload；
- 更新L2和DDR；
- Dump输出；
- 与Golden比较。

适合：

- 普通功能回归；
- 编译器输出验证；
- 最终数据结果检查。

## Trace-only

```
cpp/build/zeus3sim_oneshot \
  -c <case_folder> \
  --trace-only \
  --trace-output trace/core \
  --trace-json trace/core
```

或者：

```
cpp/build/zeus3sim_oneshot \
  -c <case_folder> \
  --execution-mode trace-only \
  --trace-output trace/core
```

功能：

- 执行动态控制流；
- 执行指令调度；
- 计算Latency和Issue Gap；
- 处理Mail和同步；
- 生成Timing Trace；
- 跳过大部分Tensor Payload。

适合：

- 调度分析；
- Executor重叠分析；
- 性能模型调试；
- 大规模Timing Trace。

边界：

> Trace-only不验证完整Tensor数值，也不执行Golden Compare。

## Analysis-only

```
cpp/build/zeus3sim_oneshot \
  -c <case_folder> \
  --analysis-only \
  --conflict-report-dir reports
```

功能：

- 执行动态控制流；
- 规划Memory Effect；
- 建立Happens-Before图；
- 检查RAW、WAR和WAW；
- 跳过大部分Tensor Payload；
- 不进行Dump和Golden Compare。

适合：

- 检查缺失Mail；
- 检查内存访问依赖；
- 快速分析多Executor和多Core冲突。

## Full-debug

```
cpp/build/zeus3sim_oneshot \
  -c <case_folder> \
  --full-debug \
  --trace-output trace/core \
  --conflict-report-dir reports
```

功能：

- 执行真实Payload；
- 输出Trace；
- 执行依赖冲突分析；
- Dump输出；
- Golden Compare。

适合：

- 功能失败的完整定位；
- 联合分析数据、执行过程和依赖关系。

代价是运行时间和输出量最大。

# 4. 使用Topology

不指定Topology时，默认配置为：

```
1个Device
2个Core
4个远端Port全部断开
```

单Device示例：

```
cpp/build/zeus3sim_oneshot \
  -c <case_folder> \
  --topology cpp/examples/topology_single_device.json
```

双Device示例：

```
cpp/build/zeus3sim_oneshot \
  -c <case_folder> \
  --topology cpp/examples/topology_two_devices.json
```

或者在Daemon启动时指定：

```
cpp/build/zeus3sim \
  --daemon \
  --socket /tmp/zeus3sim.sock \
  --topology cpp/examples/topology_two_devices.json
```

注意：

- Topology属于Daemon启动配置；
- One-shot连接已有Daemon时，应与Daemon的Topology保持一致；
- 跨Device Kernel必须显式提供Topology；
- 访问未连接Port会作为Memory MISS或路由错误处理。

# 5. 配置Timing模型

## 使用Timing文件

```
cpp/build/zeus3sim \
  --daemon \
  --socket /tmp/zeus3sim.sock \
  --timing timing.json
```

Timing配置可以定义：

- 指令Latency；
- Issue Gap；
- Drain；
- 退休顺序；
- 与Bytes、Rows、MAC数量相关的Cost。

## 命令行覆盖Cost

按Executor覆盖：

```
cpp/build/zeus3sim \
  --daemon \
  --socket /tmp/zeus3sim.sock \
  --cost PE=100 \
  --cost VP=50
```

按具体指令覆盖：

```
cpp/build/zeus3sim \
  --daemon \
  --socket /tmp/zeus3sim.sock \
  --cost PE.PE_CONV=120 \
  --cost LD.LD_MOV=30
```

命令行Cost主要适合：

- 调试；
- 压力测试；
- 验证调度行为；
- 临时回退到固定Cost。

未经RTL或芯片数据校准时，不应将默认Tick直接解释为真实芯片周期。

# 6. 生成和查看Trace

## 生成二进制Trace

```
cpp/build/zeus3sim_oneshot \
  -c <case_folder> \
  --trace-only \
  --trace-output trace/core
```

## 直接生成JSON Trace

```
cpp/build/zeus3sim_oneshot \
  -c <case_folder> \
  --trace-only \
  --trace-json trace/core
```

## 转换已有二进制Trace

```
cpp/build/zeus3_trace_export \
  <trace_file> \
  <output.json>
```

## 统计Trace

```
cpp/build/zeus3_trace_stats \
  <trace_file>
```

Trace主要包含：

- PC；
- 指令；
- Executor；
- 发射和完成Tick；
- Duration；
- Send/Receive Mail；
- 主要Memory访问范围。

# 7. 执行依赖冲突分析

## 只输出汇总

```
cpp/build/zeus3sim_oneshot \
  -c <case_folder> \
  --analysis-only \
  --conflict-report-dir reports
```

默认报告包括完整冲突数量，但不一定保存每条冲突明细。

## 输出冲突明细

```
cpp/build/zeus3sim_oneshot \
  -c <case_folder> \
  --analysis-only \
  --conflict-report-dir reports \
  --conflict-report-details
```

可能输出：

```
reports/
└── <case_name>/
    └── launch_<id>/
        ├── conflicts_system.txt
        └── conflicts_system.json
```

## 将冲突作为执行失败

```
cpp/build/zeus3sim_oneshot \
  -c <case_folder> \
  --analysis-only \
  --conflict-report-dir reports \
  --fail-on-conflict
```

适合CI使用。

# 8. Resident Daemon模式

外部Runtime接入时，先启动Daemon：

```
cpp/build/zeus3sim \
  --daemon \
  --socket /tmp/zeus3sim.sock \
  --topology <topology.json> \
  --timing <timing.json>
```

Runtime通过控制通道执行：

```
hello
  │
  ▼
register
  │
  ▼
enqueue_launch
  │
  ▼
query_launch / wait_launch
  │
  ▼
读取共享内存中的输出
```

## 注册Device

```
{
  "cmd": "register",
  "device": 0,
  "memory_transport": "shm",
  "shm_namespace": "/zeus_v3_12345_0"
}
```

Runtime需要提前创建：

```
<namespace>_gdg0
<namespace>_gdg1
<namespace>_wdram_c0
<namespace>_wdram_c1
```

## 提交Launch

```
{
  "cmd": "enqueue_launch",
  "device": 0,
  "entry_addrs": [
    1163936137216,
    1163936137216
  ],
  "num_cores": 2,
  "stream_id": 0,
  "execution_mode": "functional"
}
```

响应：

```
{
  "status": 0,
  "launch_id": 1,
  "state": "queued"
}
```

## 等待Launch

```
{
  "cmd": "wait_launch",
  "launch_id": 1
}
```

完成响应：

```
{
  "status": 0,
  "launch_id": 1,
  "state": "completed",
  "device": 0,
  "stream_id": 0
}
```

# 9. 输出结果

Functional和Full-debug模式下，One-shot根据`init.json`配置生成：

```
simu_out0.bin
simu_out1.bin
……
```

如果Case包含Golden文件，还会执行比较并输出：

```
Test Success
```

或者：

```
Test Failure
```

其他可能输出包括：

- 二进制或JSON Timing Trace；
- Dependency Conflict Report；
- Launch状态和错误信息；
- Snapshot；
- GDG或WDRAM Dump。

# 10. 常用命令组合

## 普通功能验证

```
cpp/build/zeus3sim_oneshot \
  -c <case_folder>
```

## 调度和Timing分析

```
cpp/build/zeus3sim_oneshot \
  -c <case_folder> \
  --trace-only \
  --trace-json trace/core
```

## 内存依赖检查

```
cpp/build/zeus3sim_oneshot \
  -c <case_folder> \
  --analysis-only \
  --conflict-report-dir reports
```

## 完整问题定位

```
cpp/build/zeus3sim_oneshot \
  -c <case_folder> \
  --full-debug \
  --trace-json trace/core \
  --conflict-report-dir reports \
  --conflict-report-details
```

## 跨Device功能验证

```
cpp/build/zeus3sim_oneshot \
  -c <case_folder> \
  --topology cpp/examples/topology_two_devices.json
```

# 使用流程总结

```
离线Case验证：
构建 → zeus3sim_oneshot → 自动启动Daemon
     → 执行 → Dump → Golden Compare

Runtime集成：
启动zeus3sim Daemon → 创建共享内存
     → Register → Enqueue → Wait → 读取输出

调度分析：
Trace-only → Timing Trace → Trace Export/Stats

依赖分析：
Analysis-only → Memory Effect → Conflict Report
```

一句话概括：

> 日常Case验证优先使用`zeus3sim_oneshot`；Runtime集成使用常驻`zeus3sim` Daemon；根据验证目标选择Functional、Trace-only、Analysis-only或Full-debug模式。