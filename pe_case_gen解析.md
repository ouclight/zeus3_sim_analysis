`zeus_v3_pe_case_gen` 是 Zeus V3 仿真器的 **PE（Processing Element）测例生成工具链**。它不参与 Python 仿真器的运行时执行，而是负责生成能够驱动 PE/GEMM 指令执行、验证计算结果的测试数据和配置。

## 核心作用

整体流程可以概括为：

```text
随机/指定约束
    ↓
生成 GEMM 配置
    ↓
生成 activation、weight、uscale 等输入
    ↓
生成 LD / PE / ST / CT 指令文本
    ↓
根据 ISA 描述编码 instructions.bin
    ↓
按芯片计算顺序产生 golden
    ↓
生成 init.json
    ↓
Python 仿真器运行并比较结果
```

### 1. 生成受约束