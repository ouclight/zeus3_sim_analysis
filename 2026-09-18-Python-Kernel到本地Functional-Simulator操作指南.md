# 从 Python Kernel 到本地 Functional Simulator 操作指南

- 整理日期：2026-09-18
- 适用主机：70.210
- 适用账号与工作区：`/home/zhangds/workspace`
- 示例 kernel：`triton_shared/python/zeus_business_kernels/mhc/mhc_sinkhorn_fp32_kernel.py`
- 验证范围：本地 Python Functional Simulator

## 1. 目标与边界

本文介绍如何从一个带仿真注解的 Triton Python kernel 出发，完成：

```text
Python kernel
  -> Triton/Zeus 前端编译
  -> ZeusHigh IR
  -> Zeus 后端编译
  -> kernel.zbin
  -> 生成输入、运行时参数和 golden
  -> 生成本地 simulator case
  -> Zeus3 Functional Simulator 执行
  -> 仿真输出与 golden 比较
```

这条流程完全在本机运行：

- 不需要 Relay 登录或 token；
- 不需要 SSH 隧道；
- 不会提交远端 Functional/VCS 任务；
- 不涉及 VCS；
- `ZEUS_RELAY_SERVER` 等变量即使存在，也不会被本流程使用。

本文同时给出两种运行方式：

1. 一条命令自动完成全部阶段，适合日常回归；
2. 拆分为“准备 case、运行 simulator、验证输出”三步，适合学习和调试。

## 2. 相关目录

当前已经验证的目录如下：

| 项目 | 路径 |
|---|---|
| 环境激活脚本 | `/home/zhangds/workspace/activate_torch_zeus_vcs.sh` |
| Triton Shared | `/home/zhangds/workspace/triton_shared` |
| Triton | `/DATA210/Application/caof/workspace/triton` |
| Functional Simulator | `/home/zhangds/workspace/ZeusV3FunctionalSimulator` |
| 仿真主工具 | `$TRITON_SHARED_ROOT/sim_check/sim_test.py` |
| Python simulator 入口 | `$ZEUSV3_SIMULATOR_DIR/main.py` |
| 示例 kernel | `$TRITON_SHARED_ROOT/python/zeus_business_kernels/mhc/mhc_sinkhorn_fp32_kernel.py` |
| 示例 golden | `$TRITON_SHARED_ROOT/sim_check/sim_framework/golden/mhc_sinkhorn.py` |

项目内的原始说明文档：

```text
/home/zhangds/workspace/triton_shared/sim_check/docs/user_guide.md
/home/zhangds/workspace/triton_shared/sim_check/docs/adding_new_kernel.md
/home/zhangds/workspace/ZeusV3FunctionalSimulator/README.md
```

## 3. 第一步：激活环境

每个新终端先执行：

```bash
source /home/zhangds/workspace/activate_torch_zeus_vcs.sh
```

确认关键路径：

```bash
echo "$CONDA_PREFIX"
echo "$TRITON_SHARED_ROOT"
echo "$TRITON_ROOT"
echo "$ZEUSV3_SIMULATOR_DIR"
echo "$ZEUS_COMPILER"
```

当前期望值包括：

```text
CONDA_PREFIX=/home/zhangds/miniconda3/envs/zeus-py312
TRITON_SHARED_ROOT=/home/zhangds/workspace/triton_shared
TRITON_ROOT=/DATA210/Application/caof/workspace/triton
ZEUSV3_SIMULATOR_DIR=/home/zhangds/workspace/ZeusV3FunctionalSimulator
```

做最小工具检查：

```bash
python --version
"$ZEUS_COMPILER" --version
command -v zeusv3-backend
 test -f "$ZEUSV3_SIMULATOR_DIR/main.py"
```

期望 Python 为 3.12，编译器报告 LLVM 22，且 simulator 的 `main.py` 存在。

检查仿真 Python 依赖：

```bash
python -c 'import numpy, ml_dtypes, numpyencoder, xlrd; print("sim dependencies: OK")'
```

## 4. 第二步：理解 kernel 中的仿真注解

`sim_test.py` 从 Python 注释中读取仿真契约。示例 kernel 文件开头为：

```python
# SIM_PARAMS: out_ptr:ptr:out:[1,1,"T",16]:fp32  comb_logits_ptr:ptr:in:[1,1,"T",16]:fp32  T:i32  repeat:i32  eps:f32
# SIM_GOLDEN: mhc_sinkhorn
# SIM_RANGE: T=4:16 repeat=2:6
```

### 4.1 `SIM_PARAMS`

`SIM_PARAMS` 描述 kernel 的运行时 ABI、输入输出、shape 和 dtype。

基本格式：

```text
name:type:direction:[shape]:dtype[:layout]
```

常见参数类型：

| 类型 | 示例 | 说明 |
|---|---|---|
| GDG 输入指针 | `input:ptr:in:[1,1,"T",16]:fp32` | 自动生成输入文件并分配 GDG 地址 |
| GDG 输出指针 | `output:ptr:out:[1,1,"T",16]:fp32` | 生成 dump 配置并参与结果比较 |
| Weight | `weight:weight:in:[1,"N","K"]:bf16` | 自动执行 weight layout 转换 |
| 多核 Weight | `weight:wgt_ptr:in:[1,"N","K"]:bf16` | 为多核 weight ABI 生成地址槽 |
| BAS 指针 | `buffer:bas_ptr:in:[...]:int8:raw` | BAS/AR 指针 |
| i32 标量 | `T:i32` | 一个 32-bit 参数槽 |
| f32 标量 | `eps:f32` | 按 IEEE-754 编码写入参数槽 |

最重要的规则：`SIM_PARAMS` 参数顺序必须与 kernel 的运行时参数顺序完全一致。

示例 kernel 的运行时签名是：

```python
signature = {
    "out_ptr": "*fp32",
    "comb_logits_ptr": "*fp32",
    "T": "i32",
    "repeat": "i32",
    "eps": "fp32",
}
```

因此注解也必须按以下顺序排列：

```text
out_ptr, comb_logits_ptr, T, repeat, eps
```

`N`、`NN`、`CORE_NUM` 和 `BLOCK_T` 是编译期常量，不进入 `SIM_PARAMS`：

```python
constants = {
    "N": 4,
    "NN": 16,
    "CORE_NUM": 2,
    "BLOCK_T": 4,
}
```

### 4.2 Shape 中的动态参数

注解：

```text
[1,1,"T",16]
```

运行时传入：

```bash
--dynamic T=8
```

最终生成的 tensor shape 为：

```text
[1, 1, 8, 16]
```

FP32 每个元素 4 bytes，所以单个输入或输出文件大小为：

```text
1 * 1 * 8 * 16 * 4 = 512 bytes
```

### 4.3 `SIM_GOLDEN`

```python
# SIM_GOLDEN: mhc_sinkhorn
```

该名称对应注册表：

```text
sim_check/sim_framework/golden/__init__.py
```

实际实现为：

```text
sim_check/sim_framework/golden/mhc_sinkhorn.py
```

Golden 函数负责用 NumPy 等主机计算生成期望结果。其通用接口为：

```python
def golden_xxx(inputs, dynamic, params=None):
    return {"输出参数名": numpy_array}
```

返回字典的 key 必须匹配 `SIM_PARAMS` 中声明的输出名。本例返回：

```python
return {"out_ptr": result}
```

### 4.4 `SIM_RANGE`

```python
# SIM_RANGE: T=4:16 repeat=2:6
```

它主要用于批量随机测试：

```bash
python "$TRITON_SHARED_ROOT/sim_check/sim_test.py" "$KERNEL" --batch 20
```

单次测试通常使用 `--dynamic` 显式传值。没有写进 `SIM_RANGE` 的浮点标量也可以直接传入，例如：

```bash
--dynamic T=8 repeat=4 eps=1e-6
```

## 5. 推荐方式：一条命令执行完整流程

### 5.1 设置 kernel 和输出目录

```bash
source /home/zhangds/workspace/activate_torch_zeus_vcs.sh

export KERNEL="$TRITON_SHARED_ROOT/python/zeus_business_kernels/mhc/mhc_sinkhorn_fp32_kernel.py"
export CASE_DIR
CASE_DIR=$(mktemp -d /tmp/mhc-sinkhorn-functional.XXXXXX)

echo "$KERNEL"
echo "$CASE_DIR"
```

使用新的临时目录可避免覆盖以前的结果。

### 5.2 执行完整 Functional 流程

```bash
python "$TRITON_SHARED_ROOT/sim_check/sim_test.py" \
  "$KERNEL" \
  --dynamic T=8 repeat=4 eps=1e-6 \
  --keep-dir "$CASE_DIR"
```

正常输出会包含：

```text
Compiling: ...
Compilation done: ...mhc_sinkhorn_fp32_kernel.zeushigh.mlir
Simulation: ... params: T=8 repeat=4 eps=1e-06
Intermediate files saved to: /tmp/...
Result: PASS OK
```

只有最后出现 `Result: PASS OK` 且命令退出码为 0，才表示编译、仿真和 golden 比较均通过。

查看退出码：

```bash
echo $?
```

注意：必须在 `python sim_test.py ...` 命令执行结束后立即检查 `$?`。

## 6. 学习方式：拆成三个阶段执行

如果希望观察 simulator 启动前后的文件变化，推荐使用以下三段式流程。

### 6.1 阶段一：编译并准备 case，但不启动 simulator

```bash
source /home/zhangds/workspace/activate_torch_zeus_vcs.sh

export KERNEL="$TRITON_SHARED_ROOT/python/zeus_business_kernels/mhc/mhc_sinkhorn_fp32_kernel.py"
export CASE_DIR
CASE_DIR=$(mktemp -d /tmp/mhc-sinkhorn-split.XXXXXX)

python "$TRITON_SHARED_ROOT/sim_check/sim_test.py" \
  "$KERNEL" \
  --dynamic T=8 repeat=4 eps=1e-6 \
  --prepare-only "$CASE_DIR"
```

成功标志：

```text
Preparation done: /tmp/mhc-sinkhorn-split.xxxxxx
```

这一步内部完成：

1. 解析 `SIM_PARAMS`、`SIM_GOLDEN` 和 `SIM_RANGE`；
2. 读取 kernel 的 `signature` 和 `constants`；
3. 将 Python/Triton kernel 编译为 TTIR；
4. 将 TTIR lowering 为 ZeusHigh IR；
5. 调用 `zeusv3-backend` 生成 `kernel.zbin`；
6. 按 `SIM_PARAMS` 生成随机输入；
7. 调用 `mhc_sinkhorn` golden 生成参考输出；
8. 分配 GDG/Weight 地址；
9. 生成 `args.bin`；
10. 对 zbin 中的运行地址进行重定位；
11. 生成 simulator 使用的 `init.json`。

查看生成文件：

```bash
find "$CASE_DIR" -maxdepth 1 -type f -printf '%f %s bytes\n' | sort
```

本例在启动 simulator 前应包含：

```text
args.bin                     20 bytes
case_name.txt
compile_log.txt
golden_out_ptr.bin          512 bytes
init.json
kernel.zbin                4000 bytes
output.bin                  512 bytes
tensor_comb_logits_ptr.bin 512 bytes
zbin_relocated.bin         4000 bytes
```

此时还不应依赖 `simu_out0.bin`；它是 simulator 执行后生成的实际输出。

### 6.2 阶段二：手动运行本地 Functional Simulator

```bash
python "$ZEUSV3_SIMULATOR_DIR/main.py" \
  --case "$CASE_DIR" \
  --mode serial \
  --fast \
  --quiet \
  --no-trace \
  --no-compare
```

参数解释：

| 参数 | 说明 |
|---|---|
| `--case` | 指向包含 `init.json` 的 case 目录 |
| `--mode serial` | 使用串行执行模式 |
| `--fast` | 跳过模拟 timing sleep，做快速功能验证 |
| `--quiet` | 只输出关键结果 |
| `--no-trace` | 不生成体积较大的指令 trace |
| `--no-compare` | simulator 只执行；比较统一交给 `sim_test.py --verify-only` |

成功时输出：

```text
Zeus-V3 NPU Simulator Simulation Complete
```

检查实际输出：

```bash
ls -l "$CASE_DIR/simu_out0.bin"
```

本例输出大小应为 512 bytes。

为什么这里使用 `--no-compare`：

- simulator 自带比较路径主要面向简单单输出 case；
- `sim_test.py` 的验证阶段理解 `SIM_PARAMS` 中的命名输出和 dtype；
- 对多输出 kernel，统一由 framework 验证可以避免只检查第一个输出。

### 6.3 阶段三：单独验证 simulator 输出

```bash
python "$TRITON_SHARED_ROOT/sim_check/sim_test.py" \
  --verify-only "$CASE_DIR"
```

成功输出：

```text
PASS OK
```

该步骤读取：

```text
simu_out0.bin       simulator 实际输出
output.bin          按硬件 dtype 编码的 golden
SIM_PARAMS 元数据    输出名称、dtype、shape 和比较策略
```

## 7. 编译阶段的内部关系

从源码到执行文件的核心关系为：

```text
mhc_sinkhorn_fp32_kernel.py
  |
  | zeus_compile.py
  v
TTIR
  |
  | Triton Shared frontend/midend lowering
  v
ZeusHigh MLIR
  |
  | zeusv3-backend
  v
kernel.zbin
  |
  | relocator 根据本次 case 的 GDG/args 地址打补丁
  v
zbin_relocated.bin
  |
  | init.json 提供入口地址和内存映射
  v
Zeus3FunctionalSimulator/main.py
```

`sim_test.py` 会在终端打印本次 ZeusHigh IR 所在目录，例如：

```text
.../mhc/out/mhc_sinkhorn_fp32_kernel__T8_repeat4_eps1e06_run_pidXXXX/
```

查看其中间 IR：

```bash
find "$TRITON_SHARED_ROOT/python/zeus_business_kernels/mhc/out" \
  -maxdepth 2 -type f \
  \( -name '*.ttir.mlir' -o -name '*.zeushigh.mlir' -o -name 'compile_py.log' \) \
  -print
```

case 目录内的 `compile_log.txt` 记录最终后端命令，例如：

```text
zeusv3-backend <kernel.zeushigh.mlir> -o <case>/kernel.zbin
```

## 8. 主要产物说明

| 文件 | 阶段 | 作用 |
|---|---|---|
| `kernel.zbin` | 后端编译 | 尚未针对本次 case 地址重定位的程序镜像 |
| `zbin_relocated.bin` | case 准备 | 已写入本次 GDG/args 地址的程序镜像 |
| `tensor_comb_logits_ptr.bin` | 数据生成 | 随机生成的输入 tensor |
| `golden_out_ptr.bin` | golden | 以输出参数名保存的参考结果 |
| `output.bin` | golden | simulator/framework 使用的硬件 dtype golden |
| `args.bin` | ABI 打包 | 按 `SIM_PARAMS` 顺序编码的参数槽 |
| `init.json` | case 配置 | 核数、指令入口、GDG 初始化和输出 dump 信息 |
| `simu_out0.bin` | simulator | Functional Simulator 的实际输出 |
| `compile_log.txt` | 编译日志 | 后端命令及相关编译信息 |
| `sim_log.txt` | 自动流程日志 | 使用一条命令运行时保存 simulator 输出 |

查看格式化后的 `init.json`：

```bash
python -m json.tool "$CASE_DIR/init.json" | less
```

本例的关键内容包括：

- `cores_per_die: 2`；
- 两个 core 的 `INSTRUCTION_ADDR`；
- 输入 `tensor_comb_logits_ptr` 的地址、大小和文件路径；
- `args.bin` 的地址和大小；
- 输出 `out_ptr` 的 dump 地址、dtype、大小及 `simu_out0.bin` 路径。

## 9. 数值结果如何理解

本例实测参数：

```text
T=8
repeat=4
eps=1e-6
CORE_NUM=2
N=4
```

实测结果：

```text
Result: PASS OK
输出元素数：128 FP32
max_abs_diff：7.897615432739258e-06
mean_abs_diff：1.9319268176332116e-06
```

`output.bin` 与 `simu_out0.bin` 的 SHA-256 不同并不自动表示失败。浮点实现可能因运算顺序、近似指令或舍入产生很小差异，应以 framework 的 dtype-aware 比较结果为准。

如果需要手工观察误差：

```bash
CASE_DIR="$CASE_DIR" python - <<'PY'
import os
from pathlib import Path
import numpy as np

case = Path(os.environ["CASE_DIR"])
actual = np.fromfile(case / "simu_out0.bin", dtype=np.float32)
golden = np.fromfile(case / "output.bin", dtype=np.float32)
diff = np.abs(actual - golden)

print("elements:", actual.size)
print("finite:", np.isfinite(actual).all())
print("max_abs_diff:", diff.max())
print("mean_abs_diff:", diff.mean())
PY
```

手工统计只用于辅助观察，最终 PASS/FAIL 仍以 `sim_test.py --verify-only` 为准。

## 10. Simulator 执行模式

可用模式：

| 模式 | 用途 |
|---|---|
| `serial` | 默认快速功能验证，最容易复现和阅读日志 |
| `parallel` | 并行 executor 模式 |
| `parallel-pc` | 更接近多执行单元并行取指，用于同步、竞态和 mailbox 问题 |

日常正确性 smoke test 先用默认模式：

```bash
--mode serial
```

`sim_test.py` 检测到明确的跨核同步需求时，可能把 serial 智能升级到 `parallel-pc`。需要强制并行模式时显式指定：

```bash
python "$TRITON_SHARED_ROOT/sim_check/sim_test.py" \
  "$KERNEL" \
  --dynamic T=8 repeat=4 eps=1e-6 \
  --mode parallel-pc \
  --keep-dir "$CASE_DIR"
```

需要排查时序相关问题时可以加 `--no-fast`，但普通功能验证不需要。

## 11. 为其他 kernel 添加注解

最小注解模板：

```python
# SIM_PARAMS: output:ptr:out:[1,1,"M","N"]:bf16  input:ptr:in:[1,1,"M","N"]:bf16  M:i32  N:i32
# SIM_GOLDEN: your_golden
# SIM_RANGE: M=1:16 N=128:1024
```

添加步骤：

1. 列出 kernel 的所有运行时参数；
2. 排除 `tl.constexpr` 编译期常量；
3. 按 kernel ABI 原顺序编写 `SIM_PARAMS`；
4. 为所有指针声明 `in`、`out` 或 `inout`；
5. 用静态整数或双引号动态变量描述 shape；
6. 选择已经注册的 `SIM_GOLDEN`；
7. 如果没有对应 golden，在 `sim_check/sim_framework/golden/` 新增实现；
8. 在 `golden/__init__.py` 的 `BUILTIN_GOLDEN` 中注册；
9. 先跑一个固定 `--dynamic` case；
10. 固定 case PASS 后再用 `SIM_RANGE` 做 `--batch` 测试。

Golden 函数应返回：

```python
{"SIM_PARAMS 中的输出参数名": numpy_array}
```

不要只保证参数数量相同；参数顺序、pointer 类型、direction、shape、dtype 和输出名都必须正确。

## 12. 常见问题

### 12.1 找不到 `SIM_PARAMS`

现象：解析阶段提示缺少仿真参数。

处理：确保注解位于输入的 `.py` 或 `.mlir` 文件中，并使用准确拼写：

```text
# SIM_PARAMS:
# SIM_GOLDEN:
# SIM_RANGE:
```

Python 使用 `#`，MLIR 也可使用 `//`。

### 12.2 动态 shape 参数缺失

例如 shape 中出现 `"T"`，但命令没有传 `T`：

```bash
--dynamic T=8
```

所有无法从其他字段自动推导的动态维度都必须提供。

### 12.3 参数顺序错误

这是最危险的问题之一。`args.bin` 按 `SIM_PARAMS` 顺序打包，顺序错误会让 kernel 把一个参数的比特解释成另一个参数。

始终对照：

```text
kernel 函数参数
signature 字典
SIM_PARAMS
```

三者的运行时参数顺序必须一致。

### 12.4 `unknown SIM_GOLDEN`

检查 golden 是否已经注册：

```bash
rg -n '"mhc_sinkhorn"|your_golden' \
  "$TRITON_SHARED_ROOT/sim_check/sim_framework/golden/__init__.py"
```

### 12.5 Python 编译失败

终端会打印本次编译输出目录。检查：

```text
compile_py.log
*.ttir.mlir
*.zeushigh.mlir
```

### 12.6 后端编译失败

检查 case 目录：

```bash
sed -n '1,240p' "$CASE_DIR/compile_log.txt"
```

### 12.7 simulator 没有生成 `simu_out0.bin`

检查：

```bash
python -m json.tool "$CASE_DIR/init.json"
ls -l "$CASE_DIR"
```

重新以非 quiet 模式运行：

```bash
python "$ZEUSV3_SIMULATOR_DIR/main.py" \
  --case "$CASE_DIR" \
  --mode serial \
  --fast \
  --no-trace \
  --no-compare
```

### 12.8 `zeus-relay` 提示未登录

本地 Functional 流程不调用 `zeus-relay`。无需处理登录，也不要为了本地仿真提交 Relay 任务。

## 13. 已验证命令与结果

### 13.1 一条命令模式

已验证：

```bash
python "$TRITON_SHARED_ROOT/sim_check/sim_test.py" \
  "$TRITON_SHARED_ROOT/python/zeus_business_kernels/mhc/mhc_sinkhorn_fp32_kernel.py" \
  --dynamic T=8 repeat=4 eps=1e-6 \
  --keep-dir /tmp/zhangds-mhc-sinkhorn-functional.1kQvvk
```

结果：

```text
Result: PASS OK
```

### 13.2 三段式模式

已验证目录：

```text
/tmp/zhangds-mhc-sinkhorn-split.a2TvfQ
```

依次执行 `--prepare-only`、`main.py --case`、`--verify-only`，最终结果：

```text
PASS OK
```

## 14. 最短操作清单

只想逐步执行并观察流程时，复制下面命令：

```bash
source /home/zhangds/workspace/activate_torch_zeus_vcs.sh

export KERNEL="$TRITON_SHARED_ROOT/python/zeus_business_kernels/mhc/mhc_sinkhorn_fp32_kernel.py"
export CASE_DIR
CASE_DIR=$(mktemp -d /tmp/mhc-sinkhorn-learning.XXXXXX)

# 1. Python kernel -> ZeusHigh -> zbin，并生成输入、golden、args 和 init.json
python "$TRITON_SHARED_ROOT/sim_check/sim_test.py" \
  "$KERNEL" \
  --dynamic T=8 repeat=4 eps=1e-6 \
  --prepare-only "$CASE_DIR"

# 2. 查看 simulator 启动前的 case
find "$CASE_DIR" -maxdepth 1 -type f -printf '%f %s bytes\n' | sort
python -m json.tool "$CASE_DIR/init.json" | less

# 3. 运行本地 Functional Simulator
python "$ZEUSV3_SIMULATOR_DIR/main.py" \
  --case "$CASE_DIR" \
  --mode serial \
  --fast \
  --quiet \
  --no-trace \
  --no-compare

# 4. 确认产生实际输出
ls -l "$CASE_DIR/simu_out0.bin"

# 5. 使用 framework 做正式数值验证
python "$TRITON_SHARED_ROOT/sim_check/sim_test.py" \
  --verify-only "$CASE_DIR"

# 6. 保存目录，供后续查看
echo "CASE_DIR=$CASE_DIR"
```

最终看到 `PASS OK` 即表示本地 Python kernel 编译和 Functional Simulator 仿真全链路成功。
