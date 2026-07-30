# torch_zeus runtime 到 sim C、Python simulator 与 C++ simulator 的调用链

日期：2026-07-21

## 1. 文档范围与结论

本文基于当前仓库中的 `torch_zeus` 源码，说明非真机 runtime 如何执行三类 kernel：

1. V1 zbin 中内嵌的 sim C PIC ELF；
2. V3 zbin 交给 Python functional simulator resident daemon；
3. V3 zbin 交给 C++ simulator resident daemon。

当前 `#ifndef USE_REAL_RUNTIME` 路径的核心分派结论如下：

| zbin/条件 | 执行路径 | 执行位置 |
|---|---|---|
| V1，且 `isa_version == 0` | sim C loader | `torch_zeus` 进程内直接执行宿主机 ELF |
| V3，未设置非空 `ZEUS3_CPP_SIMULATOR` | Python simulator | 独立的 Python resident daemon 进程 |
| V3，设置非空 `ZEUS3_CPP_SIMULATOR` | C++ simulator | 独立的 `zeus3sim` resident daemon 进程 |
| V3，设置非空 `ZEUS_SIM_DAEMON_SOCKET` | 外部 daemon | runtime 不拉起子进程，并按 C++ daemon 协议连接外部 socket |
| 未知 zbin，或 V1 但 `isa_version != 0` | 不支持 | 返回 `zertErrorArgsInvalid` |

这里需要区分两层选择：

- 第一层由 zbin 格式决定走 sim C 还是 V3 simulator；
- 第二层仅在 V3 路径中，由环境变量决定走 Python daemon 还是 C++ daemon。

源码总入口和版本分派位于：

- `torch_zeus/runtime/zeus_runtime.cpp:3775-3825`
- `torch_zeus/runtime/zeus_runtime.cpp:3828-3879`

若编译时定义了 `USE_REAL_RUNTIME`，`launch_kernel_dispatch()` 会调用 `zeusLaunchKernel()`，不属于本文分析的模拟 runtime 路径，见 `torch_zeus/runtime/zeus_runtime.cpp:3830-3833`。

## 2. 重要概念

### 2.1 zbin

zbin 是 runtime 接收的 kernel binary。`zertLaunchKernel()` 的 `func` 参数不是普通宿主函数地址，而是指向完整 `.zbin` 数据的指针。runtime 直接读取其 header，无需额外注册 binary。

相关代码：

- zbin 格式定义与辅助函数：`torch_zeus/runtime/zbin.h`
- `func` 语义说明：`torch_zeus/runtime/zeus_runtime.cpp:3778-3786`
- 版本识别：`zbin_detect_version(func)`，调用点在 `zeus_runtime.cpp:3796-3797`

本 runtime 识别的主要格式为：

- V1：旧格式，当前用于承载 sim C 的 PIC ELF；
- V3：Zeus V3 指令、参数描述符、各 core 入口以及 patch 位置等信息。

### 2.2 `zertLaunchKernel()` 参数 ABI

公共入口为：

```cpp
zertRet_t zertLaunchKernel(const void* func,
                           int num_cores,
                           void** args,
                           zertStream_t stream);
```

其中 `args` 采用 CUDA 风格的 per-argument pointer ABI：`args[i]` 指向第 `i` 个参数的值，而不是一块已经打包完成的连续 kernarg。

声明及注释位于 `torch_zeus/runtime/zeus_runtime.h:728-762`；实现位于 `torch_zeus/runtime/zeus_runtime.cpp:3874-3879`。

zecc JIT 编译完成后也使用该统一入口：

```text
zecc::jit::lookup_or_compile(spec)
  -> CompiledKernel::zbin
  -> zertLaunchKernel(kernel->zbin.data(), kernel->num_cores, args, stream)
```

对应代码：`torch_zeus/torch_zeus/csrc/jit/ZeccJitLauncher.cpp:195-220`。

### 2.3 resident daemon

daemon 是一个独立、常驻的仿真器服务进程。第一次 V3 launch 时，runtime 懒启动 Python 或 C++ daemon；后续 kernel 复用同一 daemon，而不是每次重新启动仿真器。

daemon 和 runtime 的职责划分：

| 组件 | 职责 |
|---|---|
| `torch_zeus` runtime | 内存分配、zbin/args staging、地址 patch、daemon 生命周期、RPC |
| Python/C++ daemon | 映射 runtime 的共享内存，解释/执行 V3 指令，写回输出 |
| Unix domain socket | 传输 `register`、`launch`、`wait_launch`、`sync` 等控制消息 |
| POSIX shared memory | 承载 GDG、weight、tensor、zbin code 和 kernarg 等大块数据 |

daemon 可以理解为“软件实现的 NPU”，Unix socket 是命令通道，共享内存是虚拟设备内存。

### 2.4 Unix domain socket

这里的 socket 不是互联网 TCP socket，而是同一台机器上进程间通信使用的 `AF_UNIX + SOCK_STREAM` 通道。默认路径形如 `/tmp/zeus_v3_<pid>.sock`。

服务端 daemon 执行概念上的：

```text
socket -> bind(socket_path) -> listen -> accept
```

runtime 客户端执行：

```text
socket(AF_UNIX, SOCK_STREAM) -> connect(socket_path)
```

runtime 的连接实现位于 `torch_zeus/runtime/npu_simulator/npu_simulator.cpp:1301-1335`：最多尝试 1000 次，每次等待 10 ms，以容忍新启动 daemon 的初始化时间；若子进程提前退出或约 10 秒内仍无法连接，则返回错误。

连接建立后，`V3Simulator::rpc()` 通过该 socket 传输长度前缀 JSON 请求和回复。大块 tensor 不复制进 JSON，而由双方直接访问已注册的共享内存。

### 2.5 resident DRAM 与设备地址

V3 runtime 创建并 mmap 常驻 POSIX shm，模拟设备物理内存。相关类为 `V3Simulator`，声明于 `torch_zeus/runtime/npu_simulator/npu_simulator.h:35-218`。

主要区域包括：

- GDG0/GDG1：通用设备内存；
- 每个 core 的 weight DRAM；
- 每次 V3 launch 临时分配的 patched zbin image；
- 每次 V3 launch 临时分配的 packed args。

`zertMalloc` 暴露的是设备物理地址。runtime 自身通过 `host_view()` 找到 shm 中的宿主映射；daemon 映射同一份 shm，因此可以直接读取输入并写回输出。

## 3. 三条路径的公共上层入口

### 3.1 算子/JIT 调用 `zertLaunchKernel()`

以 zecc JIT 为例：

```text
operator launcher
  -> zecc::jit::lookup_or_compile(spec)
  -> 得到 CompiledKernel { zbin, num_cores, ... }
  -> zertLaunchKernel(zbin.data(), num_cores, args, stream)
```

代码位置：

- JIT lookup/compile：`ZeccJitLauncher.cpp:195-209`
- 调用 runtime：`ZeccJitLauncher.cpp:214-215`

AOT/内嵌 zbin 最终也调用同一个 `zertLaunchKernel()`。

### 3.2 stream、graph 与直接执行

`zertLaunchKernel()` 立即进入 `launch_kernel_dispatch()`：

```text
zertLaunchKernel
  -> launch_kernel_dispatch
```

代码位置：`zeus_runtime.cpp:3828-3879`。

非真机 runtime 下有三种调度情况：

1. graph capture：记录 `CapturedOp`，同时 eagerly 调用 `launch_kernel_impl()`，见 `zeus_runtime.cpp:3839-3852`；
2. 指定 stream：通过 `stream->submit_sync()` 在 stream worker 上执行，见 `zeus_runtime.cpp:3855-3864`；
3. 无 stream：调用线程直接执行，见 `zeus_runtime.cpp:3867-3870`。

三种情况最终都进入：

```cpp
launch_kernel_impl(func, num_cores, args, device)
```

### 3.3 按 zbin 版本分派

`launch_kernel_impl()` 位于 `zeus_runtime.cpp:3791-3825`：

```text
zbin_detect_version(func)
  |
  +-- V1 + isa_version == 0
  |     -> zertSimcLoadKernelFromZbin()
  |     -> sim C
  |
  +-- V3
  |     -> launch_npu_simulator()
  |     -> Python/C++ daemon
  |
  +-- 其他
        -> zertErrorArgsInvalid
```

这一步不读取 `ZEUS3_CPP_SIMULATOR`。环境变量只影响进入 V3 后选择哪一种 daemon。

## 4. sim C（V1 zbin）详细调用链

### 4.1 总调用链

```text
算子/AOT launcher
  -> zertLaunchKernel(func, num_cores, args, stream)
     [zeus_runtime.cpp:3876-3879]
  -> launch_kernel_dispatch(...)
     [zeus_runtime.cpp:3828-3872]
  -> launch_kernel_impl(...)
     [zeus_runtime.cpp:3791-3825]
  -> zbin_detect_version(func) == 1
     [zeus_runtime.cpp:3796-3799]
  -> 检查 hdr->isa_version == 0
     [zeus_runtime.cpp:3800-3803]
  -> zertSimcLoadKernelFromZbin(func)
     [zeus_runtime.cpp:3803-3804]
  -> 校验 V1 header 与内嵌 ELF
     [simc_backend.cpp:56-75]
  -> memfd_create("zenl_sim")
     [simc_backend.cpp:77-82]
  -> 把 zbin code section 中的 ELF 写入 memfd
     [simc_backend.cpp:84-95]
  -> dlopen("/proc/self/fd/<fd>")
     [simc_backend.cpp:97-105]
  -> 构造符号 zecc_<kernel_name>_kernel_sim
     [simc_backend.cpp:107-109]
  -> dlsym() 取得宿主函数地址
     [simc_backend.cpp:110-121]
  -> 按 func 指针缓存 LoadedSim
     [simc_backend.cpp:45-53, 122]
  -> fn(args, zertSimcRuntime())
     [zeus_runtime.cpp:3804-3809]
  -> sim C kernel 在 torch_zeus 进程内执行
```

### 4.2 V1 zbin 里装的是什么

V1 sim C zbin 的 code section 必须是真实 ELF，且开头必须为 `0x7f 'E' 'L' 'F'`。loader 会拒绝旧式 fake-zbin payload，见 `simc_backend.cpp:68-75`。

该 ELF 是位置无关的宿主机共享对象代码。runtime 不落盘生成普通 `.so`，而是：

1. `memfd_create()` 创建匿名内存文件；
2. 将 ELF bytes 写入 memfd；
3. 用 `/proc/self/fd/<fd>` 作为路径调用 `dlopen()`；
4. 用约定符号名 `zecc_<kernel_name>_kernel_sim` 调用 `dlsym()`。

### 4.3 sim C runtime services

sim C kernel 在宿主 CPU 上执行，不能直接解引用设备物理地址，因此 runtime 额外传入 `ZeccSimcRt` 服务表：

```cpp
static const ZeccSimcRt g_simc_rt = {
    &zecc_simc_as_device_ptr,
    &zecc_simc_lmem_to_host,
};
```

位置：`torch_zeus/runtime/simc_backend.cpp:29-40`。

服务含义：

- `zecc_simc_as_device_ptr()`：通过 `dev2host()` 将普通设备物理地址转换为 runtime shm 的 host pointer；
- `zecc_simc_lmem_to_host()`：将指定 core 的 local-memory 地址转换为 host pointer。

最终调用 ABI 为：

```cpp
fn(args, zertSimcRuntime());
```

sim C 与 V3 都收到 per-argument pointer array，但 sim C 多收到一个 runtime services 表。

### 4.4 sim C 路径的关键特征

- 不启动 daemon；
- 不建立 socket；
- 不发送 JSON RPC；
- 不解释 V3 指令；
- `num_cores` 在该 loader 调用点被忽略，见 `zeus_runtime.cpp:3805`；
- ELF/function pointer 按 zbin `func` 指针缓存，避免重复 `dlopen/dlsym`；
- kernel 与 runtime 位于同一进程，异常可能直接影响宿主进程。

## 5. V3 公共准备流程

Python 和 C++ simulator 从进入 `launch_npu_simulator()` 到 `V3Simulator::launch()` 之前，共用同一条准备链。

入口：`torch_zeus/runtime/npu_simulator/npu_simulator.cpp:484-584`。

### 5.1 确认 launch device

```text
zertGetDeviceCount()
  -> 校验 device 范围
  -> device_for(device)
  -> 获得进程级、按 device 缓存的 V3Simulator
```

代码位置：`npu_simulator.cpp:488-496`；`device_for()` 位于 `npu_simulator.cpp:1485-1495` 附近。

device 由上层明确传入：普通 eager launch 使用当前 device，graph replay 使用 capture 时保存的 device。

### 5.2 初始化 resident DRAM

```cpp
dev->ensure_dram();
```

调用位置：`npu_simulator.cpp:498`。

它创建并 mmap runtime-owned GDG/weight shm，同时初始化这些区域上的 allocator。V3 tensor、weight、code 和 args 都使用同一物理地址域。

### 5.3 校验 V3 zbin 版本

runtime 使用 `zbin_v3_version_ok(hdr)` 对 compiler/runtime 所需版本做严格匹配。版本不符时提示用匹配的 `zeus-compiler` 重新编译并返回 `zertErrorArgsInvalid`。

代码位置：`npu_simulator.cpp:499-508`；要求版本宏位于 `runtime/zbin.h:101-106`。

### 5.4 根据 ArgDescriptor 构造 kernarg

调用：

```cpp
build_resident_args(func, raw_args, dev, args_buf);
```

实现位置：`npu_simulator.cpp:253-336`；调用位置：`npu_simulator.cpp:515-520`。

转换规则：

| descriptor | raw args 内容 | 写入 V3 kernarg 的内容 |
|---|---|---|
| `ZBIN_ARG_POINT` | device pointer | 校验 4 KB 对齐和地址空间后写入 `addr >> 12` 页号 |
| `ZBIN_ARG_VALUE` | scalar 地址 | 按 descriptor `size/offset` 复制标量字节 |
| `ZBIN_ARG_WEIGHT` | 每 core device pointer 数组 | 校验 resident 地址，转换成每 core weight DRAM 相对偏移 |

ArgDescriptor 是 compiler/runtime ABI 的权威信息，runtime 不依赖 C++ host struct 自行猜测布局。

### 5.5 为本次 launch staging code 和 args

每次 launch 分配独立的 `launch_code` 和 `launch_args`：

```text
dev->alloc(zbin_size)
dev->alloc(args_bytes)
dev->host_view(...)
memcpy(zbin)
memcpy(args_buf)
```

代码位置：`npu_simulator.cpp:522-535`。

每次使用独立副本的原因是 zbin 中的地址需要按 launch patch；若异步 launch 共用一个 patched code copy，会发生竞态。

### 5.6 patch CT_SETA 地址

runtime 将物理地址转换成 4 KB 页号并 patch 到指令：

- `baseAddrPatchPos` 指向 code base 页号；
- `argsBasePatchPos[i]` 指向本次 args buffer 页号。

代码位置：

- `patch_ct_seta_addr()`：`npu_simulator.cpp:66-72`
- code/args patch：`npu_simulator.cpp:537-555`

### 5.7 计算每个 core 的指令入口

runtime 根据 `hdr->coreEntryOffsets[i]` 生成 `entry_addrs[]`；若某个 offset 为 0，则回退到 `codeOffset`。

代码位置：`npu_simulator.cpp:557-564`。

### 5.8 调用 daemon 层

准备完成后进入：

```cpp
dev->launch(launch_code.get(),
            entry_addrs,
            actual_cores,
            launch_args.get(),
            conflict_report_dir);
```

调用位置：`npu_simulator.cpp:577-583`；实现入口：`npu_simulator.cpp:1366`。

## 6. 后端选择与 daemon 启动

### 6.1 统一协议判断函数

`use_cpp_simulator_daemon()` 位于 `npu_simulator.cpp:74-79`：

```cpp
static bool use_cpp_simulator_daemon() {
  const char* external_socket = std::getenv("ZEUS_SIM_DAEMON_SOCKET");
  if (external_socket && *external_socket) return true;
  const char* cpp_bin = std::getenv("ZEUS3_CPP_SIMULATOR");
  return cpp_bin && *cpp_bin;
}
```

它决定后续使用哪套 register/launch/sync 协议：

- 外部 socket：按 C++ daemon 协议；
- `ZEUS3_CPP_SIMULATOR` 非空：按 C++ daemon 协议；
- 两者均无：按 Python daemon 协议。

`SIM_BACKEND=cpp` 不参与当前 resident-daemon runtime 的分支判断。

### 6.2 `V3Simulator::launch()` 触发 `ensure_daemon()`

```text
V3Simulator::launch()
  -> ensure_daemon()
```

代码位置：`npu_simulator.cpp:1366-1370`。

`ensure_daemon()` 位于 `npu_simulator.cpp:1243-1299`，内部步骤为：

```text
ensure_dram()
  -> SharedDaemon::ensure()
  -> connect_socket(sd.socket_path)
  -> 按后端构造 register JSON
  -> rpc(register)
  -> daemon_ready_ = true
```

这里要特别注意：不是 `ensure_daemon()` 返回以后才决定启动 Python 或 C++。启动分支就在 `ensure_daemon()` 内部调用的 `SharedDaemon::ensure()` 中发生。

### 6.3 `SharedDaemon::ensure_process()` 读取环境变量

代码位置：`npu_simulator.cpp:790-822`。

流程：

```text
检查 ZEUS_SIM_DAEMON_SOCKET
  |
  +-- 非空：记录外部 socket，不 fork 子进程
  |
  +-- 空：读取 ZEUS3_CPP_SIMULATOR
          -> 非空：use_cpp = true
          -> 空：use_cpp = false，并要求 ZEUSV3_SIMULATOR_DIR 非空
          -> spawn_child(cpp_bin, sim_dir, use_cpp)
```

### 6.4 `spawn_child()` 构造命令并执行

代码位置：`npu_simulator.cpp:824-882`。

C++ 分支：

```cpp
argv_s = {cpp_bin, "--daemon", "--socket", socket_path};
```

即：

```bash
$ZEUS3_CPP_SIMULATOR --daemon --socket <socket_path>
```

Python 分支：

```cpp
const char* python_env = std::getenv("ZEUS_SIMULATOR_PYTHON");
const std::string python = python_env && *python_env ? python_env : "python";
const std::string main_py = sim_dir / "main_torch_zeus.py";
argv_s = {python, main_py, "--daemon", "--socket", socket_path};
```

即：

```bash
${ZEUS_SIMULATOR_PYTHON:-python} \
  $ZEUSV3_SIMULATOR_DIR/main_torch_zeus.py \
  --daemon --socket <socket_path>
```

最后通过以下代码真正进入另一个程序：

```text
fork()
  -> child: prctl(PR_SET_PDEATHSIG, SIGTERM)
  -> child: execvp(cargv[0], cargv.data())
```

位置：`npu_simulator.cpp:863-875`。

`PR_SET_PDEATHSIG` 确保父 runtime 进程死亡时，子 daemon 收到 `SIGTERM`，避免遗留孤儿进程。

## 7. Python simulator 详细调用链

### 7.1 配置入口

典型配置：

```bash
unset ZEUS3_CPP_SIMULATOR
unset ZEUS_SIM_DAEMON_SOCKET
export ZEUSV3_SIMULATOR_DIR=/path/to/Zeus3FunctionalSimulator
export ZEUS_SIMULATOR_PYTHON=/path/to/python  # 可选，默认 python
```

Python simulator 的进程入口是外部工程中的：

```text
Zeus3FunctionalSimulator/main_torch_zeus.py
```

当前仓库内负责拉起它的代码是 `npu_simulator.cpp:839-845`。

### 7.2 端到端调用链

```text
operator/JIT launcher
  -> zertLaunchKernel()
     [zeus_runtime.cpp:3876]
  -> launch_kernel_dispatch()
     [zeus_runtime.cpp:3828]
  -> launch_kernel_impl()
     [zeus_runtime.cpp:3791]
  -> zbin_detect_version() == 3
     [zeus_runtime.cpp:3796, 3816]
  -> launch_npu_simulator()
     [zeus_runtime.cpp:3819; npu_simulator.cpp:484]
  -> ensure_dram + V3 version check + build_resident_args
     [npu_simulator.cpp:498-520]
  -> stage/patch zbin 与 args，计算 entry_addrs
     [npu_simulator.cpp:522-564]
  -> V3Simulator::launch()
     [npu_simulator.cpp:577; 1366]
  -> ensure_daemon()
     [npu_simulator.cpp:1369; 1243]
  -> SharedDaemon::ensure_process()
     [npu_simulator.cpp:795]
  -> ZEUS3_CPP_SIMULATOR 为空，use_cpp=false
     [npu_simulator.cpp:807-810]
  -> spawn_child(..., use_cpp=false)
     [npu_simulator.cpp:821, 824]
  -> 构造 python main_torch_zeus.py --daemon --socket 命令
     [npu_simulator.cpp:839-845]
  -> fork + execvp
     [npu_simulator.cpp:863-875]
  -> connect_socket()
     [npu_simulator.cpp:1251-1253; 1301]
  -> 发送 Python 格式 register
     [npu_simulator.cpp:1266-1277]
  -> 构造 cmd="launch" 请求
     [npu_simulator.cpp:1375-1384]
  -> rpc(request)
     [npu_simulator.cpp:1396]
  -> Python daemon 映射 shm、读取 code/args/tensor、解释 V3 指令
  -> daemon 将结果写回共享内存并同步回复 status
  -> runtime 收到 status==0 后返回成功
     [npu_simulator.cpp:1398-1405]
```

### 7.3 Python register 协议

Python daemon 需要 runtime 显式传递 shm 布局，代码位于 `npu_simulator.cpp:1266-1277`：

```json
{
  "cmd": "register",
  "device": 0,
  "shm": "<gdg0 shm name>",
  "shm_size": "<gdg0 size>",
  "gdg0_base": "<physical base>",
  "wdram_prefix": "<weight shm prefix>",
  "wdram_size": "<per-core size>",
  "wdram_base": "<core0 physical base>",
  "wdram_stride": "<per-core stride>",
  "wdram_cores": 4
}
```

### 7.4 Python launch 协议

Python 请求使用同步 `launch`：

```json
{
  "cmd": "launch",
  "device": 0,
  "entry_addrs": ["<core0 entry>", "<core1 entry>"],
  "num_cores": 2,
  "stream_id": 0,
  "code_addr": "<patched zbin physical address>",
  "args_addr": "<packed args physical address>"
}
```

构造位置：`npu_simulator.cpp:1373-1384`。

Python daemon 的 `launch` 回复已经代表执行完成，因此 `V3Simulator::launch()` 在 `!use_cpp` 时直接返回，见 `npu_simulator.cpp:1405`。

## 8. C++ simulator 详细调用链

### 8.1 配置入口

典型配置：

```bash
export ZEUS3_CPP_SIMULATOR=/path/to/zeus3sim
export ZEUSV3_SIMULATOR_DIR=/path/to/Zeus3FunctionalSimulator
```

实际后端选择开关是非空的 `ZEUS3_CPP_SIMULATOR`。其值同时是待执行的 C++ binary 路径。

C++ simulator 必须支持 resident-daemon 参数：

```bash
zeus3sim --daemon --socket <socket_path>
```

旧式仅支持 `-c <dump-dir>` 的 one-shot binary 不能直接用于该 runtime 路径。

### 8.2 端到端调用链

```text
operator/JIT launcher
  -> zertLaunchKernel()
     [zeus_runtime.cpp:3876]
  -> launch_kernel_dispatch()
     [zeus_runtime.cpp:3828]
  -> launch_kernel_impl()
     [zeus_runtime.cpp:3791]
  -> zbin_detect_version() == 3
     [zeus_runtime.cpp:3796, 3816]
  -> launch_npu_simulator()
     [zeus_runtime.cpp:3819; npu_simulator.cpp:484]
  -> V3 公共的 DRAM、args、staging、patch、entry 准备
     [npu_simulator.cpp:498-564]
  -> V3Simulator::launch()
     [npu_simulator.cpp:577; 1366]
  -> ensure_daemon()
     [npu_simulator.cpp:1369; 1243]
  -> SharedDaemon::ensure_process()
     [npu_simulator.cpp:795]
  -> 读取非空 ZEUS3_CPP_SIMULATOR，use_cpp=true
     [npu_simulator.cpp:807-808]
  -> spawn_child(..., use_cpp=true)
     [npu_simulator.cpp:821, 824]
  -> 构造 zeus3sim --daemon --socket 命令
     [npu_simulator.cpp:836-839]
  -> fork + execvp
     [npu_simulator.cpp:863-875]
  -> connect_socket()
     [npu_simulator.cpp:1251-1253; 1301]
  -> 发送 C++ 格式 register
     [npu_simulator.cpp:1261-1265]
  -> 构造 cmd="enqueue_launch" 请求
     [npu_simulator.cpp:1375-1380]
  -> rpc(enqueue_launch)
     [npu_simulator.cpp:1396]
  -> 解析 launch_id
     [npu_simulator.cpp:1407-1409]
  -> rpc(wait_launch, launch_id)
     [npu_simulator.cpp:1416-1419]
  -> C++ daemon 执行完成并回复 status
  -> runtime 返回成功
     [npu_simulator.cpp:1420-1434]
```

### 8.3 C++ register 协议

C++ daemon 只接收 namespace：

```json
{
  "cmd": "register",
  "device": 0,
  "shm_namespace": "zeus_v3_<pid>_d0"
}
```

代码位置：`npu_simulator.cpp:1261-1265`。

daemon 按约定从 namespace 推导 GDG0、GDG1 和各 core weight shm，而不是接受调用者传入的每个布局字段。

### 8.4 C++ enqueue/wait 协议

第一步：

```json
{
  "cmd": "enqueue_launch",
  "device": 0,
  "entry_addrs": ["<core entries>"],
  "num_cores": 2,
  "stream_id": 0
}
```

daemon 回复：

```json
{
  "status": 0,
  "launch_id": 123
}
```

第二步：

```json
{
  "cmd": "wait_launch",
  "launch_id": 123
}
```

对应代码：

- enqueue 请求：`npu_simulator.cpp:1375-1396`
- 解析 `launch_id`：`npu_simulator.cpp:1407-1409`
- wait 请求：`npu_simulator.cpp:1416-1419`
- 检查完成状态：`npu_simulator.cpp:1420-1425`

虽然 C++ daemon 协议内部区分 enqueue 与 wait，但当前 `V3Simulator::launch()` 紧接着等待，因此上层 `zertLaunchKernel()` 观察到的仍是同步完成语义。

### 8.5 C++ sync 与额外能力

`V3Simulator::sync()` 对 C++ 使用：

```json
{"cmd": "wait_device", "device": 0}
```

Python 则使用 `{"cmd": "sync"}`。代码位置：`npu_simulator.cpp:1437-1447`。

C++ daemon 还支持 dependency conflict 分析。runtime 可通过环境变量和额外参数配置报告目录；相关 runtime 逻辑包括：

- `make_launch_conflict_report_dir()`：`npu_simulator.cpp:147-159`
- `ZEUS_SIM_EXTRA_PARAMS` 转发：`npu_simulator.cpp:828-855`
- launch 请求携带 `conflict_report_dir`：`npu_simulator.cpp:1385-1388`

## 9. 外部 daemon socket 路径

设置：

```bash
export ZEUS_SIM_DAEMON_SOCKET=/path/to/existing.sock
```

后，`SharedDaemon::ensure_process()` 不再 `fork/execvp`：

```text
读取 ZEUS_SIM_DAEMON_SOCKET
  -> socket_path = external_socket
  -> external_daemon = true
  -> return zertSuccess
```

代码位置：`npu_simulator.cpp:795-805`。

随后 `ensure_daemon()` 直接连接该 socket。因为 `use_cpp_simulator_daemon()` 对非空外部 socket 返回 `true`，注册、launch 和 sync 均采用 C++ daemon 协议。

因此该入口要求外部服务兼容当前 C++ resident-daemon JSON/shm namespace 协议。

## 10. Python 与 C++ daemon 的分支并非只有一处

V3 流程中共有三个重要分支点：

| 分支点 | 位置 | Python | C++ |
|---|---|---|---|
| daemon 启动命令 | `npu_simulator.cpp:795-845` | `python main_torch_zeus.py --daemon` | `zeus3sim --daemon` |
| 共享内存注册 | `npu_simulator.cpp:1261-1277` | 显式 shm/base/size | `shm_namespace` |
| kernel launch RPC | `npu_simulator.cpp:1375-1425` | `launch` | `enqueue_launch` + `wait_launch` |

所以准确表述是：

```text
ensure_daemon() 内部：
  选择并启动 daemon
  -> 建立 socket 连接
  -> 按后端注册共享内存

ensure_daemon() 返回后：
  daemon 已经就绪
  -> V3Simulator::launch() 按后端发送执行 RPC
```

## 11. 三条执行路径对比

| 维度 | sim C | Python simulator | C++ simulator |
|---|---|---|---|
| zbin | V1 | V3 | V3 |
| 选择依据 | `ver==1 && isa_version==0` | V3 且无 C++ 开关 | V3 且 `ZEUS3_CPP_SIMULATOR` 非空 |
| 执行进程 | runtime 进程内 | Python 子进程 | C++ 子进程 |
| kernel 表示 | zbin 内嵌宿主 ELF | Zeus V3 指令 | Zeus V3 指令 |
| 加载/执行入口 | `dlopen+dlsym` 后调用函数 | `main_torch_zeus.py --daemon` | `zeus3sim --daemon` |
| socket | 无 | Unix domain socket | Unix domain socket |
| 大块数据 | runtime shm，sim C 用地址转换器访问 | POSIX shm | POSIX shm |
| register | 无 | 显式内存布局 | shm namespace |
| launch 命令 | 直接函数调用 | `launch` | `enqueue_launch` + `wait_launch` |
| 返回语义 | 函数返回即完成 | `launch` 回复即完成 | `wait_launch` 回复即完成 |
| 指令执行器 | 编译后的 C/ELF | Python V3 interpreter/executor | C++ V3 executor |

## 12. 总体时序图

### 12.1 sim C

```text
Caller          zeus_runtime       simc_backend          Embedded ELF
  |                  |                   |                    |
  | zertLaunchKernel |                   |                    |
  |----------------->|                   |                    |
  |                  | detect V1/isa=0   |                    |
  |                  |------------------>| validate ELF       |
  |                  |                   | memfd + dlopen      |
  |                  |                   | dlsym entry         |
  |                  |<------------------| function pointer    |
  |                  | fn(args, rt) -------------------------->|
  |                  |<----------------------------------------|
  |<-----------------| success                                |
```

### 12.2 Python/C++ V3 daemon

```text
Caller        zeus_runtime/V3Simulator       SharedDaemon       Simulator daemon
  |                       |                       |                    |
  | zertLaunchKernel      |                       |                    |
  |---------------------->|                       |                    |
  |                       | build args            |                    |
  |                       | stage/patch zbin      |                    |
  |                       | ensure_daemon         |                    |
  |                       |---------------------->| env selection      |
  |                       |                       | fork + execvp      |
  |                       |                       |------------------->|
  |                       | connect(socket) -------------------------->|
  |                       | register RPC ----------------------------->|
  |                       |<-------------------------------------------|
  |                       | launch/enqueue RPC ----------------------->|
  |                       |                       |   execute from shm  |
  |                       |<-------------------------------------------|
  |                       | C++ only: wait_launch -------------------->|
  |                       |<-------------------------------------------|
  |<----------------------| success                                    |
```

## 13. 常用配置示例

### 13.1 Python simulator

```bash
unset ZEUS3_CPP_SIMULATOR
unset ZEUS_SIM_DAEMON_SOCKET
export ZEUSV3_SIMULATOR_DIR=/path/to/Zeus3FunctionalSimulator
export ZEUS_SIMULATOR_PYTHON=$(which python)  # 可选
```

预期启动命令：

```bash
python $ZEUSV3_SIMULATOR_DIR/main_torch_zeus.py \
  --daemon --socket /tmp/zeus_v3_<pid>.sock
```

### 13.2 C++ simulator

```bash
unset ZEUS_SIM_DAEMON_SOCKET
export ZEUSV3_SIMULATOR_DIR=/path/to/Zeus3FunctionalSimulator
export ZEUS3_CPP_SIMULATOR=/path/to/zeus3sim
```

预期启动命令：

```bash
$ZEUS3_CPP_SIMULATOR --daemon --socket /tmp/zeus_v3_<pid>.sock
```

### 13.3 外部 C++ 协议 daemon

```bash
export ZEUS_SIM_DAEMON_SOCKET=/path/to/existing.sock
```

runtime 不创建子进程，直接连接该 socket。

### 13.4 调试日志

```bash
export ZEUS_SIM_DEBUG=1
```

可观察 daemon spawn、socket connect、register、enqueue/wait 等 runtime 日志。调试判断函数位于 `npu_simulator.cpp:167-170`，相关日志分布在 daemon 启动、连接和 launch 流程中。

## 14. 排障检查顺序

### 14.1 V1 sim C 失败

依次检查：

1. `zbin_detect_version()` 是否识别为 V1；
2. `isa_version` 是否为 0；
3. code section 是否为真实 ELF；
4. `dlopen(/proc/self/fd/N)` 是否成功；
5. ELF 是否导出 `zecc_<kernel_name>_kernel_sim`；
6. kernel 是否通过 `ZeccSimcRt` 转换设备地址，而非直接解引用物理地址。

建议开启：

```bash
export ZENL_SIM_LOADER_DEBUG=1
```

对应日志代码：`simc_backend.cpp:123-126`。

### 14.2 V3 daemon 无法启动或连接

依次检查：

1. C++ 路径的 `ZEUS3_CPP_SIMULATOR` 是否指向支持 `--daemon --socket` 的 executable；
2. Python 路径的 `ZEUSV3_SIMULATOR_DIR/main_torch_zeus.py` 是否存在；
3. `ZEUS_SIMULATOR_PYTHON` 或默认 `python` 是否可执行；
4. daemon 是否在 runtime connect 前异常退出；
5. socket 路径是否创建、权限是否正确；
6. 外部 `ZEUS_SIM_DAEMON_SOCKET` 服务是否兼容 C++ 协议；
7. register 回复的 `status` 是否为 0。

### 14.3 V3 launch 失败

依次检查：

1. V3 zbin 版本是否匹配 runtime；
2. `ArgDescriptor` 的 offset/size/type 是否合法；
3. POINT 是否 4 KB 对齐且属于 launch device 地址空间；
4. WEIGHT 是否位于 resident weight region；
5. code/args staging 是否成功；
6. daemon 是在 register、launch/enqueue 还是 wait 阶段返回错误；
7. Python 与 C++ 是否因 executor 语义/校验差异产生不同结果。

## 15. 关键源码索引

| 内容 | 文件与位置 |
|---|---|
| kernel 公共 API | `torch_zeus/runtime/zeus_runtime.cpp:3874-3879` |
| stream/graph dispatch | `torch_zeus/runtime/zeus_runtime.cpp:3828-3872` |
| V1/V3 分派 | `torch_zeus/runtime/zeus_runtime.cpp:3791-3825` |
| sim C runtime services | `torch_zeus/runtime/simc_backend.cpp:29-40` |
| sim C ELF loader | `torch_zeus/runtime/simc_backend.cpp:56-127` |
| V3 参数打包 | `torch_zeus/runtime/npu_simulator/npu_simulator.cpp:253-336` |
| V3 launch staging | `torch_zeus/runtime/npu_simulator/npu_simulator.cpp:484-584` |
| 后端协议判断 | `torch_zeus/runtime/npu_simulator/npu_simulator.cpp:74-79` |
| daemon 环境变量选择 | `torch_zeus/runtime/npu_simulator/npu_simulator.cpp:795-822` |
| Python/C++ 命令构造 | `torch_zeus/runtime/npu_simulator/npu_simulator.cpp:824-855` |
| fork/exec daemon | `torch_zeus/runtime/npu_simulator/npu_simulator.cpp:863-875` |
| ensure/connect/register | `torch_zeus/runtime/npu_simulator/npu_simulator.cpp:1243-1301` |
| Python/C++ launch RPC | `torch_zeus/runtime/npu_simulator/npu_simulator.cpp:1366-1435` |
| V3Simulator 声明与内存模型 | `torch_zeus/runtime/npu_simulator/npu_simulator.h:35-218` |
| zbin ABI | `torch_zeus/runtime/zbin.h` |
| zecc JIT 到 runtime | `torch_zeus/torch_zeus/csrc/jit/ZeccJitLauncher.cpp:195-220` |

## 16. 最终总结

整个 runtime 可以压缩为两级分派：

```text
zertLaunchKernel
  -> 按 zbin 版本分派
       |
       +-- V1/isa0：内嵌 ELF -> memfd -> dlopen -> dlsym -> 进程内 sim C
       |
       +-- V3：构造 kernarg -> resident DRAM staging -> patch 地址
                -> ensure_daemon
                     -> ZEUS3_CPP_SIMULATOR 非空：启动 C++ zeus3sim
                     -> 否则：启动 Python main_torch_zeus.py
                -> socket register
                -> launch RPC
                     -> Python：launch
                     -> C++：enqueue_launch + wait_launch
```

sim C 与 Python/C++ simulator 的本质差别是：sim C 已经是可以由宿主 CPU 直接加载执行的 ELF；V3 zbin 则是 Zeus 指令，需要由独立的软件 NPU simulator 解释或执行。Python 与 C++ daemon 在 runtime 侧共享相同的 V3 ABI、resident memory 和 staging 流程，区别集中在 daemon executable、内存注册协议和 kernel launch RPC。
