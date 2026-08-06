# C++版 issue_gap_coefficients.rows 字段说明

> `rows`影响的不是当前指令的完成延迟（Latency），而是同一Executor连续发射两条指令的最小间隔（Issue Gap）。

## 1. rows表示什么

`rows`表示当前指令处理的Tensor包含多少个逻辑数据行。

```text
MD0布局：
rows = tile_N × tile_H × tile_W

MD1布局：
rows = tile_N × tile_K
```

例如：

```text
Shape = N=1, H=4, W=8, C=64

rows = 1 × 4 × 8 = 32
```

可以理解为：

```text
第0行：64个元素
第1行：64个元素
……
第31行：64个元素
```

当一条指令涉及多个BR描述符时，当前通用`rows`特征主要取相关描述符中的最大逻辑行数。

## 2. Issue Gap是什么

假设一条LD指令需要50周期才能完成，但流水线不必等待50周期后才接收下一条指令：

```text
LD指令1：████████████████████████████████
LD指令2：    ████████████████████████████████
LD指令3：        ████████████████████████████████
            ▲   ▲
            相邻发射间隔
```

```text
Latency   = 50 cycles
Issue Gap = 4 cycles
```

含义：

- 单条LD从开始到完成需要50周期；
- 同一LD Executor每隔4周期可以发射一条新指令。

因此，`rows`影响Issue Gap表达的是：

> 数据行数越多，Executor准备、接收或启动下一条指令的间隔可能越长。

## 3. 为什么行数可能影响Issue Gap

同样搬运1024字节，可以采用不同的数据布局：

```text
情况A： 4行 × 256字节 = 1024字节
情况B：64行 ×  16字节 = 1024字节
```

虽然总字节数相同，情况B可能需要更多次：

- 行起始地址计算；
- Stride递增；
- Burst或存储请求创建；
- L2行访问；
- 边界判断；
- 对齐处理；
- 行状态更新；
- 内部循环推进。

概念上，每处理一行都可能执行：

```text
计算该行地址
      │
      ▼
发起存储请求
      │
      ▼
更新Stride
      │
      ▼
进入下一行
```

如果这些逐行控制操作不能完全流水化，行数越多，Executor越晚能够接收下一条指令，Issue Gap就会增加。

## 4. 配置及计算示例

```json
{
  "issue_gap_cycles": 2,
  "issue_gap_coefficients": {
    "rows": 0.25
  }
}
```

计算公式：

```text
Issue Gap
= ceil(issue_gap_cycles + rows × coefficient)
```

当`rows = 8`：

```text
Issue Gap
= ceil(2 + 8 × 0.25)
= 4 cycles
```

当`rows = 64`：

```text
Issue Gap
= ceil(2 + 64 × 0.25)
= 18 cycles
```

该配置表达的模型假设是：

> 每增加4个逻辑行，同一Executor连续发射间隔增加约1个周期。

## 5. rows与bytes的区别

| 特征 | 主要表达的开销 |
|---|---|
| `bytes` | 数据总量产生的传输或计算开销 |
| `rows` | 分行、Stride、地址生成和逐行控制开销 |
| `padding_rows` | 短行补齐到16B L2行宽的额外开销 |
| `padded_bytes` | 对齐后实际可能处理的数据量 |

例如：

```text
Tensor A： 4行 × 256B
Tensor B：64行 ×  16B
```

- 只使用`bytes`时，两者Cost相同；
- 加入`rows`后，可以表达Tensor B更高的逐行处理开销。

一句话理解：

```text
bytes：总共搬多少数据
rows ：数据被拆成多少次逐行操作
```

## 6. 为什么放在Issue Gap而不是Latency

这取决于硬件流水结构和实测结果。

一种可能的硬件行为是：

- 数据传输总时间主要由`bytes`决定；
- 每行地址生成或请求提交会占用前端发射资源；
- 行数增加会降低下一条指令进入流水线的速度；
- 但不一定按相同比例增加当前指令的端到端完成时间。

因此可以配置为：

```json
{
  "latency_cycles": 20,
  "coefficients": {
    "bytes": 0.03125
  },
  "issue_gap_cycles": 2,
  "issue_gap_coefficients": {
    "rows": 0.25
  }
}
```

对应含义：

```text
当前指令什么时候完成
主要由数据量bytes决定

下一条指令什么时候能发射
部分由逐行处理rows决定
```

如果实测表明`rows`也影响当前指令完成时间，可以同时配置：

```json
{
  "coefficients": {
    "bytes": 0.03125,
    "rows": 0.5
  },
  "issue_gap_coefficients": {
    "rows": 0.25
  }
}
```

此时`rows`分别以不同权重影响Latency和Issue Gap。

## 7. 使用与校准边界

- `rows`不会自动影响Timing，只有在JSON中显式配置对应系数才参与计算；
- `0.25`只是示例，不是仿真器内置硬件常数；
- 系数应来自RTL/VCS、FPGA、芯片计数器或性能数据拟合；
- 应使用“相同Bytes、不同Rows”的Microbenchmark分离逐行开销；
- 如果实测结果只与Bytes相关，`rows`系数应设为0或删除；
- `bytes`和`rows`可能高度相关，拟合时需要避免系数相互替代导致过拟合。

建议校准Case：

```text
Case A： 4行 × 256B
Case B： 8行 × 128B
Case C：16行 ×  64B
Case D：64行 ×  16B
```

这些Case总字节数相同，通过观察连续指令的实际发射间隔是否随`rows`增长，可以判断是否需要`rows`系数。

## 8. 一句话总结

> `issue_gap_coefficients.rows`用于拟合逐行地址生成、Stride更新、对齐和请求提交等开销对Executor连续发射吞吐的影响；它描述的是下一条指令最早何时能够进入流水线，而不是当前指令何时完成。
