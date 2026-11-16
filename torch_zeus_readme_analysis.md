# torch_zeus README 分析

## 项目定位

`torch_zeus` 是面向 Zeus 加速器的 PyTorch PrivateUse1 后端，包含 Runtime、ZENL 算子库、PyTorch 扩展、Triton AOT/JIT Kernel 和测试体系。

执行链路是：`PyTorch → torch_zeus → Zeus Runtime → .zbin Kernel → 硬件或 Functional Simulator`。

主要目录：`runtime/` 提供 `libzert.so`；`zenl/` 提供 ZENL C 算子库和 Triton AOT Kernel；`torch_zeus/` 提供 PyTorch 后端、ATen 算子、流、事件和分配器；`sgl-kernel-zeus-triton/` 提供 SGLang Triton JIT 算子；`tests/` 提供测试。

## AOT 和 JIT

ZENL 的 AOT 流程为：`zenl/src/triton/*.py → zeus-compiler → .zbin → libzenl.so`。Kernel 清单是 `zenl/configs/zenl_ops.yaml`，当前清单中的 Kernel 会全部编译，旧的 `TRITON_KERNELS` 和 `TRITON_KERNELS_CONFIG` 已移除。

`sgl-kernel-zeus-triton` 使用 Triton JIT，依赖 Zeus Triton wheel、`zecc` 和 simulator 环境。AOT/JIT 最终都通过 `zertLaunchKernel`，使用 `.zbin` 镜像和 packed `kargs` 启动。

## ZCCL

Zeus 的 `torch.distributed` 使用 ZCCL，而不是 NCCL。ZCCL 在独立仓库编译和安装：`make build-sim-c`，再执行 `make install BUILD_DIR=build-sim-c PREFIX=<prefix>`，最后在本项目执行 `ZCCL_ROOT=<prefix> make torch_zeus`。

`ZCCL_ROOT` 没有默认值。主要限制是：多 rank 的 `broadcast` 和 `reduce` 不支持；`recvAnysource` 不支持；`all_gather_object` 等对象通信不支持；`supportsCoalescing()` 为 false；多进程 collective 测试需要 `zeus_sim_run`。

collective 出错时建议使用 `ZCCL_DEBUG=WARN python your_script.py`，因为 PyTorch 报错通常只包含源文件位置，具体原因在 ZCCL 日志中。

## 环境要求

要求包括：Python >= 3.10（推荐 3.12）、PyTorch >= 2.8（推荐 2.10）、CMake >= 3.14、C++17、`nlohmann_json`、`pyyaml`、`pytest`、`numpy`、Git LFS、Zeus Triton wheel、预编译 ZCCL 和 Zeus3FunctionalSimulator。

README 建议不要在同一 Conda 环境混用 Conda 版和 pip 版 PyTorch，避免 C++ 头文件、库和 ABI 不匹配。推荐环境命令是：`conda create -n <env> python=3.12 pip nlohmann_json -c conda-forge`，再使用 pip 安装 `torch==2.10.0 numpy pytest pybind11 pyyaml`。

开始构建前应先运行 `make env-check`。

## 构建流程

构建顺序为：`runtime → ZENL → torch_zeus`。基本命令是 `make runtime`、`make zenl`、`make torch_zeus`，完整重建使用 `make rebuild`。

推荐 editable 安装流程是：先执行 `make clean clean-runtime clean-zenl`，再执行 `make runtime`、`make zenl`，最后执行 `python -m pip install -e . --no-build-isolation --no-deps`。

主要产物为 `runtime/build/libzert.so`、`zenl/build/libzenl.so` 和 `torch_zeus/_C*.so`。

默认 Runtime 是 `runtime/zeus_runtime.cpp` 中的开发 Stub。真实 Runtime 需要 `git lfs install`、`git lfs pull`，然后执行 `make rebuild USE_REAL_RUNTIME=ON`。

## 测试

基础测试使用 `./run_tests.sh`；Triton JIT 测试使用 `./run_tests.sh --sgl-kernel-triton`。JIT 测试最好单独运行 `python -m pytest -q -ra tests/test_basic/jit`，因为 ZECC 的 JIT cache 是进程级状态。

常用 focused 测试包括：`python -m pytest tests/test_basic -v`、`python -m pytest tests/test_op -v`、`cd zenl && make test`、`python -m pytest tests/problem_case -v`。

## Python/C++ simulator

默认使用 Python simulator；设置 `ZEUS3_CPP_SIMULATOR` 后使用 C++ simulator：`export ZEUS3_CPP_SIMULATOR=/path/to/build/zeus3sim`。同时仍需设置 `ZEUSV3_SIMULATOR_DIR=/path/to/ZeusV3FunctionalSimulator`。

二者含义不同：前者是 C++ daemon 可执行文件，后者是 simulator 资源目录。

C++ simulator 使用 CMake 构建：`cmake -S /path/to/ZeusV3FunctionalSimulator/cpp -B /path/to/build -DCMAKE_BUILD_TYPE=Release`，然后 `cmake --build /path/to/build -j`。

C++ simulator 采用 resident-memory daemon。Runtime/one-shot 创建共享内存、写入 code/args/data、提交 launch，daemon 执行 CT/LD/VP/DT/PE/ST，完成后由 Runtime dump 和 golden compare。case 流程使用 `cpp/build/zeus3sim_oneshot -c <case_folder>`。

## 关键配置

`ZEUS_SIM_DEVICE_COUNT=2` 表示 simulator 提供两个 device，不是 `CUDA_VISIBLE_DEVICES` 风格的设备筛选；多设备拓扑通过 `ZEUS_SIM_TOPOLOGY` 指定。

内存大小必须在第一次 Zeus allocation 前设置：`ZEUS_SIM_GDG_DDR_SIZE_B` 和 `ZEUS_SIM_WEIGHT_DDR_SIZE_B`。默认每个 GDG 区域 920 MiB、每个 core 的 Weight DDR 8 GiB；GDG 需 4 KiB 对齐，Weight DDR 需 16 KiB 对齐。

`ZEUS_INDEX_MODE` 默认是 `int32`。`int64` 目前会抛出 `NotImplementedError`，不会静默回退到 int32；配置在第一次 native indexing 调用时缓存，修改环境变量后需要新进程。

## 推荐执行顺序

建议依次执行：`conda activate zeus-py312`、`make env-check`、`make clean clean-runtime clean-zenl`、`make runtime`、`make zenl`、`python -m pip install -e . --no-build-isolation --no-deps`、`./run_tests.sh`。

基础测试稳定后，再启用 C++ simulator 运行 `tests/problem_case`，最后使用 `python -m zeus_sim_run -- python -m pytest tests/test_basic/test_zccl.py` 验证多设备和 ZCCL。

## 总体评价

README 覆盖了项目架构、依赖、编译、Runtime、AOT/JIT、ZCCL、Python/C++ simulator 和测试流程，更接近项目维护者手册，而不是完全从零开始的教程。

最关键的理解是：`torch_zeus` 不是单独的 PyTorch Python 包，而是 Runtime、ZENL、Zeus Triton、ZCCL 和 Functional Simulator 共同组成的完整执行环境。

实际搭建中最容易缺少的是 Zeus Triton wheel、`zecc`、`zeus-compiler`、ZCCL prefix、`ZeusV3FunctionalSimulator` 路径和 C++ simulator 可执行文件。建议优先完成 `make env-check`，再按 `runtime → zenl → torch_zeus → 基础测试 → C++ simulator → ZCCL/多设备测试` 推进。
