# VCS 环境手工配置 NPU Trace

本文说明如何不依赖 Zeus518 测试框架，直接在 VCS 测试环境中手工完成以下操作：

1. 为每个 NPU core 分配对应的 GDG trace buffer；
2. 按固定顺序配置 trace 寄存器；
3. 启动 Kernel 并等待完成；
4. 读取 trace 实际长度；
5. 从 GDG 后门导出 trace 文件；
6. 清除本次执行的 done 和 trace 状态。

整体流程如下：

```text
为每个 NPU core 分配对应 GDG bank 中的 buffer
→ 按固定顺序配置 trace 寄存器
→ 写 Kernel entry
→ 写 config_end 启动
→ 等待 done
→ 读取 trace length
→ 从 GDG backdoor 导出对应字节
→ 清 done 和 trace 状态
```

> 注意：部分源码注释仍写着“22/25 次写”，但当前实际执行的固定 `trace_init_seq` 是 26 次 APB 写，再加 2 次 trace buffer 地址写。应以本文列出的实际数组为准。

## 1. 每个 core 的地址空间

NPU APB 基地址：

```c
#define NPU0_APB_BASE 0x66000000U
#define NPU1_APB_BASE 0x6E000000U
```

对应 GDG：

```c
#define GDG0_BASE 0x10F00000000ULL
#define GDG1_BASE 0x11F00000000ULL

#define GDG_SIZE       (960ULL * 1024 * 1024)  /* 每个 GDG 960 MB */
#define GDG_WORD_BYTES 128                     /* 1024 bit */
```

必须满足以下约束：

- core0 的 trace buffer 必须位于 GDG0；
- core1 的 trace buffer 必须位于 GDG1；
- buffer 起始地址至少按 128 字节对齐；
- buffer 不能与 zbin、输入、输出和参数区重叠；
- 建议初始配置为每核 16 MB；
- `buffer_offset + buffer_size` 必须小于 960 MB。

例如，假设每个 GDG 的 `0x10000000` 偏移确认未被占用：

```c
uint64_t core0_trace_buf = GDG0_BASE + 0x10000000ULL;
uint64_t core1_trace_buf = GDG1_BASE + 0x10000000ULL;
uint32_t trace_capacity  = 16 * 1024 * 1024;
```

这只是地址计算示例，实际 offset 必须根据自己的 GDG 内存布局选择。

## 2. 固定 trace 寄存器序列

所有 offset 都相对于相应的 `NPUx_APB_BASE`，必须严格按以下顺序写入：

```c
struct RegWrite {
    uint32_t offset;
    uint32_t value;
};

static const struct RegWrite trace_init_seq[] = {
    {0x1828c, 0x00000001},   /* timestamp_clear */
    {0x18220, 0x00000200},   /* trace master enable, bit 9 */

    {0x1822c, 0x0000001c},
    {0x18230, 0x0000001c},
    {0x18234, 0x0000001c},
    {0x18238, 0x0000001c},
    {0x1823c, 0x0000001c},
    {0x18240, 0x0000001c},
    {0x18244, 0x0000001c},
    {0x18248, 0x0000001c},
    {0x1824c, 0x0000001c},

    /* Trigger Round 1: 启动条件 */
    {0x18254, 0x00000009},   /* trg_name = timestamp */
    {0x18258, 0x00000000},   /* trg_type = start */
    {0x1825c, 0x00000008},   /* trg_event */
    {0x18250, 0x00000001},   /* commit/pulse */

    /* Trigger Round 2: 终止条件 */
    {0x18254, 0x00000009},
    {0x18258, 0x00000001},   /* trg_type = end */
    {0x1825c, 0x0000000c},
    {0x18250, 0x00000001},   /* commit/pulse */

    {0x18280, 0x00000200},
    {0x18284, 0x00000200},
    {0x1827c, 0x00000001},
    {0x1829c, 0x00000001},
    {0x182b4, 0xffffffff},
    {0x182bc, 0x00000015},
    {0x182c0, 0x00000100},
};
```

最容易出错的是两轮 trigger 配置。两轮都必须执行，并且每轮最后都要写一次：

```c
npu_cfg_write32(npu_apb_base + 0x18250, 1);
```

如果只配置第二轮，可能导致启动 trigger 没有注册，最终出现 NPU done bit 不拉高、Kernel 永久等待的问题。

## 3. 配置 trace buffer 地址

完成固定序列后，将 64 位 GDG 绝对物理地址拆成低 32 位和高 32 位：

```c
#define TRACE_ADDR_LOW  0x182ac
#define TRACE_ADDR_HIGH 0x182b0

uint32_t addr_low  = (uint32_t)(trace_buf_addr & 0xffffffffULL);
uint32_t addr_high = (uint32_t)(trace_buf_addr >> 32);

npu_cfg_write32(npu_apb_base + TRACE_ADDR_LOW,  addr_low);
npu_cfg_write32(npu_apb_base + TRACE_ADDR_HIGH, addr_high);
```

例如：

```text
trace_buf_addr = 0x10F10000000
addr_low       = 0x10000000
addr_high      = 0x0000010F
```

这里写入的是绝对物理地址，不是 GDG 内部 word index。

## 4. 配置 Kernel 并启动

trace 配置和 trace buffer 地址必须在 `config_end` 之前完成。

```c
#define INST_START_ADDR_LOW  0x14004
#define INST_START_ADDR_HIGH 0x14008
#define ONE_TASK_CONFIG_END  0x1400c
#define TASK_EXECUTE_END     0x142d4
#define TASK_EXECUTE_END_CLR 0x142d8
```

启动函数示例：

```c
void start_kernel_with_trace(
    uint32_t npu_apb_base,
    uint64_t kernel_entry,
    uint64_t trace_buf_addr)
{
    /* 1. 完整 trace 固定序列 */
    for (unsigned i = 0;
         i < sizeof(trace_init_seq) / sizeof(trace_init_seq[0]);
         ++i) {
        npu_cfg_write32(
            npu_apb_base + trace_init_seq[i].offset,
            trace_init_seq[i].value);
    }

    /* 2. trace 输出地址 */
    npu_cfg_write32(
        npu_apb_base + TRACE_ADDR_LOW,
        (uint32_t)(trace_buf_addr & 0xffffffffULL));

    npu_cfg_write32(
        npu_apb_base + TRACE_ADDR_HIGH,
        (uint32_t)(trace_buf_addr >> 32));

    /* 3. Kernel entry */
    npu_cfg_write32(
        npu_apb_base + INST_START_ADDR_LOW,
        (uint32_t)(kernel_entry & 0xffffffffULL));

    npu_cfg_write32(
        npu_apb_base + INST_START_ADDR_HIGH,
        (uint32_t)(kernel_entry >> 32));

    /* 4. 最后才触发 */
    npu_cfg_write32(
        npu_apb_base + ONE_TASK_CONFIG_END,
        1);
}
```

正确顺序是：

```text
trace 固定配置
→ trace buffer 地址
→ instruction entry
→ config_end
```

多核情况下，应先配置并触发所有参与 core，然后再分别轮询完成：

```c
start_kernel_with_trace(NPU0_APB_BASE, core0_entry, core0_trace_buf);
start_kernel_with_trace(NPU1_APB_BASE, core1_entry, core1_trace_buf);

/* 然后再 poll core0/core1 */
```

## 5. 等待完成并读取 trace 长度

轮询每个 core 的 `TASK_EXECUTE_END` bit 0：

```c
uint32_t done;

do {
    npu_cfg_read32(
        npu_apb_base + TASK_EXECUTE_END,
        &done);
} while ((done & 1) == 0);
```

done 拉高后，必须先读取 trace 长度：

```c
#define TRACE_LENGTH 0x182cc

uint32_t trace_length;

npu_cfg_read32(
    npu_apb_base + TRACE_LENGTH,
    &trace_length);
```

`0x182cc` 返回的是字节数。必须用预分配 buffer 大小进行上限保护：

```c
if (trace_length > trace_capacity) {
    trace_length = trace_capacity;
}
```

关键顺序为：

```text
done bit == 1
→ 读取 0x182cc
→ 导出 GDG
→ 清 done/trace
```

不要先清 done 再读取 `0x182cc`，清除动作可能导致 trace length 被复位。

## 6. 从 GDG 导出 trace 文件

将 trace buffer 绝对地址转换为 GDG backdoor word index：

```c
uint64_t relative = trace_buf_addr - gdg_base;

uint32_t word_start = relative / GDG_WORD_BYTES;
uint32_t word_count = (trace_length + GDG_WORD_BYTES - 1) / GDG_WORD_BYTES;
uint32_t word_end   = word_start + word_count - 1;
```

core0 使用：

```c
mem_save_gdg_top(
    "trace_core0.hex",
    word_start,
    word_end);
```

core1 使用：

```c
mem_save_gdg_top_nddg1(
    "trace_core1.hex",
    word_start,
    word_end);
```

`$writememh` 输出的每行是一个 1024-bit word，即 256 个十六进制字符。要得到 profiler 可读取的原始二进制文件，需要把每行转换成 128 字节小端数据，最后裁剪到 `trace_length`。

转换脚本示例：

```python
#!/usr/bin/env python3
import sys

hex_path = sys.argv[1]
bin_path = sys.argv[2]
trace_length = int(sys.argv[3], 0)

raw = bytearray()

with open(hex_path, "r") as f:
    for line in f:
        line = line.strip()
        if not line or line.startswith("//"):
            continue

        # $writememh 将 1024-bit word 以大端 hex 文本打印；
        # trace 文件使用该 word 的小端字节序。
        word = int(line, 16)
        raw.extend(word.to_bytes(128, byteorder="little"))

with open(bin_path, "wb") as f:
    f.write(raw[:trace_length])
```

使用示例：

```bash
python3 gdg_hex_to_trace.py \
  trace_core0.hex \
  output_trace_core0.bin \
  0x<trace_length>
```

必须裁剪到 `0x182cc` 返回的实际长度，不能把整个预分配 buffer 写入文件，否则尾部会包含旧 GDG 数据。

## 7. 清除本次执行状态

文件导出后清除 task done 和 trace 状态机：

```c
/* 清 task done */
npu_cfg_write32(
    npu_apb_base + TASK_EXECUTE_END_CLR,
    1);

/* 清 trace 状态机，W1 pulse */
npu_cfg_write32(
    npu_apb_base + 0x18224,
    1);
```

`0x18224 = 1` 应在每次 launch 收尾执行，否则下一次 trace 可能继承上一次的状态，出现 trace 损坏或跨任务残留。

对于下一次不抓 trace 的 Kernel，还应显式关闭 master：

```c
npu_cfg_write32(
    npu_apb_base + 0x18220,
    0);
```

## 8. 完整伪代码

```c
int run_one_core_with_trace(
    int core,
    uint64_t kernel_entry,
    uint64_t trace_buf,
    uint32_t trace_capacity,
    const char *hex_output)
{
    uint32_t base =
        core == 0 ? NPU0_APB_BASE :
        core == 1 ? NPU1_APB_BASE :
                    0;

    uint64_t gdg_base =
        core == 0 ? GDG0_BASE :
                    GDG1_BASE;

    if (!base)
        return -1;

    if (trace_buf < gdg_base ||
        trace_buf + trace_capacity > gdg_base + GDG_SIZE)
        return -2;

    if ((trace_buf - gdg_base) % GDG_WORD_BYTES != 0)
        return -3;

    /* Trace 初始化 */
    for (unsigned i = 0;
         i < sizeof(trace_init_seq) / sizeof(trace_init_seq[0]);
         ++i) {
        npu_cfg_write32(
            base + trace_init_seq[i].offset,
            trace_init_seq[i].value);
    }

    /* Trace buffer */
    npu_cfg_write32(base + TRACE_ADDR_LOW,  (uint32_t)trace_buf);
    npu_cfg_write32(base + TRACE_ADDR_HIGH, (uint32_t)(trace_buf >> 32));

    /* Kernel entry + launch */
    npu_cfg_write32(base + INST_START_ADDR_LOW,  (uint32_t)kernel_entry);
    npu_cfg_write32(base + INST_START_ADDR_HIGH, (uint32_t)(kernel_entry >> 32));
    npu_cfg_write32(base + ONE_TASK_CONFIG_END, 1);

    /* Poll done；实际代码应增加超时 */
    uint32_t done = 0;
    while (!(done & 1))
        npu_cfg_read32(base + TASK_EXECUTE_END, &done);

    /* 必须在 clear 前读取 */
    uint32_t trace_len = 0;
    npu_cfg_read32(base + TRACE_LENGTH, &trace_len);

    if (trace_len > trace_capacity)
        trace_len = trace_capacity;

    /* GDG backdoor dump */
    uint64_t rel = trace_buf - gdg_base;
    int word_start = rel / GDG_WORD_BYTES;
    int word_count = (trace_len + GDG_WORD_BYTES - 1) / GDG_WORD_BYTES;

    if (trace_len != 0) {
        if (core == 0)
            mem_save_gdg_top(
                hex_output,
                word_start,
                word_start + word_count - 1);
        else
            mem_save_gdg_top_nddg1(
                hex_output,
                word_start,
                word_start + word_count - 1);
    }

    /* 收尾 */
    npu_cfg_write32(base + TASK_EXECUTE_END_CLR, 1);
    npu_cfg_write32(base + 0x18224, 1);

    return (int)trace_len;
}
```

生产代码还应补充：

- APB 读写返回值检查；
- APB 单次事务超时；
- done bit 总轮询超时；
- `trace_buf + trace_capacity` 的整数溢出检查；
- dump 失败时的状态保存；
- 多核场景先启动全部 core，再等待全部 core 完成。

## 9. Trace 快速有效性检查

正常 trace 的第一个 64-bit packet 是 TS header。按最终原始二进制文件的小端字节排列：

```c
trace_bytes[7] == 0xa8
```

如果 `trace_length > 0`，但第 7 字节不是 `0xa8`，通常表示：

- buffer 地址选择错误；
- core1 错误地使用了 GDG0；
- GDG dump 字节序转换错误；
- 读取到了上一次执行的残留数据；
- trace RTL 格式已经发生变化。

