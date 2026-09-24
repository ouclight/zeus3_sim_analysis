# VCS NPU Trace 文件解析指南

本文说明如何解析手工从 VCS/GDG 导出的 NPU trace 文件，包括：

- 输入文件格式和命名；
- 使用 Zeus518TestFramework 内置 profiler 完整解析；
- 使用底层 parser 快速检查；
- 将 `$writememh` 文本转换为原始二进制；
- 字节序、header 和长度诊断；
- trace 时钟频率配置。

## 1. 确认输入文件格式

如果已经生成最终原始二进制 trace，例如：

```text
output_trace_core0.bin
output_trace_core1.bin
```

可以直接使用内置 profiler。

Profiler 推荐使用以下两种命名之一：

```text
output_trace_core0.bin
output_trace_core1.bin
```

或：

```text
Trace_core_0.bin
Trace_core_1.bin
```

例如准备一个输入目录：

```bash
mkdir -p /tmp/manual_trace
cp /path/to/core0_trace.bin /tmp/manual_trace/output_trace_core0.bin
cp /path/to/core1_trace.bin /tmp/manual_trace/output_trace_core1.bin
```

如果只有一个 core，只需放置：

```text
/tmp/manual_trace/output_trace_core0.bin
```

## 2. 安装解析依赖

进入 Zeus518TestFramework：

```bash
cd /home/zhangds/zeus518_test_framework
```

安装分析依赖：

```bash
python3 -m pip install -r requirements/analysis.txt
```

配置 Python 模块路径：

```bash
export PYTHONPATH="$PWD/python${PYTHONPATH:+:$PYTHONPATH}"
```

## 3. 执行完整解析

解析输入目录中的所有 core：

```bash
python3 -m profiler /tmp/manual_trace \
  --skip-convert \
  --network-name manual_trace \
  --output-dir /tmp/manual_trace_result
```

只解析 core0：

```bash
python3 -m profiler /tmp/manual_trace \
  --skip-convert \
  --core 0 \
  --network-name manual_trace \
  --output-dir /tmp/manual_trace_result
```

`--skip-convert` 表示输入已经是原始二进制文件，不再尝试旧版“文本 trace 转 bin”流程。

解析成功后，主要产物布局如下：

```text
/tmp/manual_trace_result/manual_trace/
├── aggregate.json
├── profile_manifest.json
├── clock_profile.json
└── core_0/
    ├── parse_report_core0.json
    ├── performance_summary.json
    ├── backend_profiler.json
    ├── manual_trace_core_0_trace.json
    ├── manual_trace_core_0.xlsx
    ├── manual_trace_core_0_inst_queue.jpg
    ├── manual_trace_core_0_bar_chart.jpg
    └── logs/
        ├── core_0_trace_bits.txt
        ├── core_0_instqueues.txt
        └── core_0_continuous.txt
```

各产物含义：

- `*_trace.json`：Perfetto 时间线；
- `*.xlsx`：Excel 性能报告；
- `*_inst_queue.jpg`：指令执行时间线；
- `performance_summary.json`：指令周期、利用率等汇总；
- `parse_report_core0.json`：trace 完整性和解析质量；
- `core_0_instqueues.txt`：便于人工阅读的指令开始/结束周期列表；
- `aggregate.json`：多核结果汇总。

## 4. 使用底层解析器快速检查

如果暂时不需要 Excel、图片和 Perfetto JSON，可以直接调用底层 `trace_format` 解析器：

```bash
cd /home/zhangds/zeus518_test_framework

PYTHONPATH="$PWD/python" python3 - /tmp/manual_trace/output_trace_core0.bin <<'PY'
import sys
from trace_format import parse_trace

path = sys.argv[1]
result = parse_trace(path, core_id=0)

print("header valid:", result.header.valid)
print("header order:", result.header.packet_order)
print("events:", len(result.events))
print("report:", result.report.to_dict())

print("\n前 20 条指令事件：")
for event in result.events[:20]:
    print(
        f"{event.unit:>2} "
        f"{event.mnemonic:<24} "
        f"start={event.start_ts:<12} "
        f"end={event.end_ts:<12} "
        f"duration={event.duration}"
    )
PY
```

正常结果应类似：

```text
header valid: True
header order: ('TS', 'CT', 'LD', 'LW', 'SI', 'ST', 'SO', 'VP', 'PE', 'DT')
events: 非零
```

如果 `header valid` 为 `False`，通常应先排查原始数据导出地址和字节序，而不是直接分析指令事件。

## 5. Trace 二进制格式

当前解析器使用以下格式约定：

- 每个 trace packet 为 8 字节；
- RTL/GDG 中按小端原始字节保存；
- 文件开头包含 10 个固定 header packet，共 80 字节；
- header 的类型顺序应为：

```text
TS, CT, LD, LW, SI, ST, SO, VP, PE, DT
```

- header 之后是指令事件 packet；
- 全零的 8-byte packet 被视为 padding/noise；
- 末尾不足 8 字节的内容被报告为 trailing partial packet；
- timestamp 由 TS packet 的高 44 bit 和事件 packet 的低 20 bit 拼接。

## 6. 如果当前文件是 `$writememh` 文本

如果文件内容类似：

```text
a8000000000000008800000000000000...
```

并且每行有 256 个十六进制字符，那么它是 1024-bit GDG word 文本，不能直接交给 profiler。

先将其转换为原始二进制。创建 `gdg_hex_to_trace.py`：

```python
#!/usr/bin/env python3
import sys

hex_path = sys.argv[1]
bin_path = sys.argv[2]
trace_length = int(sys.argv[3], 0)

raw = bytearray()

with open(hex_path, "r") as src:
    for line in src:
        line = line.strip()

        if not line or line.startswith("//") or line.startswith("@"):
            continue

        # $writememh 将 1024-bit word 以大端 hex 文本输出；
        # trace 原始文件按该 word 的小端字节序存储。
        word = int(line, 16)
        raw.extend(word.to_bytes(128, byteorder="little"))

with open(bin_path, "wb") as dst:
    dst.write(raw[:trace_length])
```

执行转换：

```bash
python3 gdg_hex_to_trace.py \
  trace_core0.hex \
  /tmp/manual_trace/output_trace_core0.bin \
  0x123456
```

最后一个参数必须使用 trace length 寄存器 `0x182cc` 读取的实际字节数。

不要把整个预分配的 16 MB buffer 全部保存到最终文件，否则尾部会包含未使用空间或旧 GDG 数据。

## 7. 检查原始文件

文件至少应满足：

- 长度不小于 80 字节；
- 文件长度最好是 8 字节整数倍；
- 第一个 64-bit packet 是 TS header；
- 最终小端二进制文件的第 7 字节通常是 `0xa8`。

查看文件大小和前 80 字节：

```bash
stat -c '%n: %s bytes' /tmp/manual_trace/output_trace_core0.bin

od -An -tx1 -N80 /tmp/manual_trace/output_trace_core0.bin
```

也可以执行自动检查：

```bash
python3 - /tmp/manual_trace/output_trace_core0.bin <<'PY'
import sys
from pathlib import Path

data = Path(sys.argv[1]).read_bytes()

print("size:", len(data))
print("at least 80 bytes:", len(data) >= 80)
print("8-byte aligned:", len(data) % 8 == 0)
print("first packet:", data[:8].hex())
print("first packet byte[7]:", hex(data[7]) if len(data) >= 8 else "missing")
print("TS marker OK:", len(data) >= 8 and data[7] == 0xa8)
PY
```

如果 `byte[7] != 0xa8`，优先检查：

1. `$writememh` 到二进制的字节序是否反了；
2. GDG word index 是否按 `(trace_addr - GDG_BASE) / 128` 计算；
3. core1 是否错误读取了 GDG0；
4. 是否按 `0x182cc` 的长度裁剪；
5. trace buffer 中是否仍是上一次执行的残留数据。

## 8. 如何判断解析质量

重点查看：

```text
<output>/manual_trace/core_0/parse_report_core0.json
```

主要字段包括：

- `status`：整体解析状态；
- `bytes_in_file`：输入文件大小；
- `header_valid`：10-packet header 是否有效；
- `header_order_valid`：header 类型顺序是否正确；
- `packet_count`：参与解析的事件 packet 数；
- `trailing_bytes`：末尾不足 8 字节的数量；
- `unknown_type_packets`：未知类型 packet 数；
- `malformed_packets`：格式损坏 packet 数；
- `timestamp_regressions`：时间戳倒退次数；
- `unpaired_start_events`：只有开始、没有结束的事件数；
- `unpaired_complete_events`：只有结束、没有开始的事件数；
- `task_start_seen`、`task_done_seen`：是否捕获任务开始/结束；
- `warnings`：完整性警告列表。

推荐判断顺序：

```text
header_valid
→ unknown/malformed packet
→ timestamp_regressions
→ unpaired events
→ task start/done
→ 最终 instruction_count
```

## 9. 配置 trace 时钟频率

Profiler 默认把 trace timestamp 按 400 MHz 解释。

如果本地 VCS 中 `zeus_core.core_clk` 不是 400 MHz，应显式指定真实频率。例如 500 MHz：

```bash
export ZEUS_TRACE_CLOCK_HZ=500000000

python3 -m profiler /tmp/manual_trace \
  --skip-convert \
  --network-name manual_trace \
  --output-dir /tmp/manual_trace_result
```

也可以在 trace 输入目录中放置 `clock_profile.json`：

```json
{
  "schema_version": 1,
  "profile_name": "local_vcs",
  "trace_clock_hz": 500000000,
  "trace_clock_domain": "zeus_core.core_clk",
  "module_clocks_hz": {
    "CT": 500000000,
    "LD": 500000000,
    "LW": 500000000,
    "ST": 500000000,
    "SI": 500000000,
    "SO": 500000000,
    "PE": 500000000,
    "VP": 500000000,
    "DT": 500000000
  }
}
```

优先级为：

```text
ZEUS_TRACE_CLOCK_HZ
> clock_profile.json / trace_clock.json
> 内置默认值 400 MHz
```

时钟频率只影响 cycle 到 ns 的换算，不影响 packet 类型和指令类型解码。

## 10. 常见问题

### 10.1 `header valid: False`

可能原因：

- 输入仍是 ASCII hex，而不是二进制；
- 每个 1024-bit GDG word 的字节序转换错误；
- GDG 起始 word index 错误；
- trace 地址不是对应 core 的 GDG bank；
- 文件没有从 trace buffer 首地址开始导出。

### 10.2 `events: 0` 或 `no instructions decoded`

可能原因：

- 文件只有 10 个 header packet，没有后续事件；
- `0x182cc` 长度读取过早；
- Kernel 没有真正开始执行；
- trace trigger 两轮配置不完整；
- 文件被错误裁剪；
- 事件开始/完成 packet 无法配对。

### 10.3 出现大量 unknown packet

可能原因：

- 64-bit packet 内部字节序错误；
- 从错误的 GDG byte offset 开始读取；
- trace RTL packet 格式与当前解析器版本不一致。

### 10.4 周期正确但纳秒时间错误

说明 packet 解析正常，但 `ZEUS_TRACE_CLOCK_HZ` 或 `clock_profile.json` 中的 trace 时钟频率不正确。

### 10.5 Excel 或图片生成失败，但指令可以解析

通常是 `matplotlib`、`openpyxl` 等可视化依赖缺失。先确认：

```bash
python3 -m pip install -r /home/zhangds/zeus518_test_framework/requirements/analysis.txt
```

底层指令解析结果仍可从以下文件查看：

```text
core_0/logs/core_0_instqueues.txt
core_0/parse_report_core0.json
core_0/performance_summary.json
```

