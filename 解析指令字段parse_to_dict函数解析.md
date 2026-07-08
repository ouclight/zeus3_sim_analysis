`parse_to_dict` 在 [instruction_dispatch.py (line 1404)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/instruction_dispatch/instruction_dispatch.py:1404) 的作用是：把一条 64-bit 指令整数 `inst`，按照指令表 `parse_rule` 中定义的位域，解析成 executor 更容易使用的 `dict`。

核心流程如下：

1. 遍历 `parse_rule`
   `parse_rule` 来自 `self.core.inst_dic[inst[0]]`，也就是当前指令助记符对应的格式表。每个字段一般长这样：

   ```
   "Rx": {
       "length": 5,
       "index": [42, 38]
   }
   ```

   表示 `Rx` 占 5 bit，位于 bit `[42:38]`。

2. 跳过 `inst_type`

   ```
   if field_name == "inst_type":
       inst_type = field_info
       continue
   ```

   `inst_type` 不写入结果字典，只保存到局部变量里，后面解析 mailbox 字段时会用到。例如 `PE_CONV`、`CT_MAIL`、`SIA_SYN` 等。

3. 对普通位域做切片

   ```
   start, end = index
   mask = (1 << length) - 1
   shifted = inst >> end
   value = shifted & mask
   ```

   这里实际用的是 `end`，也就是字段最低位。含义是：

   - 先把目标字段右移到最低位；
   - 再用 `length` 位 mask 截出来。

   举例：如果字段是 `[42, 38]`、长度 5，那么：

   ```
   value = (inst >> 38) & 0b11111
   ```

   `start` 变量目前只是解包出来，没有直接参与计算；正确性依赖 `length == start - end + 1`。

4. `Imme` / `Immediate Data` 特殊处理为 `np.uint32`

   ```
   if field_name in ['Imme', 'Immediate Data']:
       result[field_name] = np.uint32(value)
   ```

   这说明这两个精确字段名被当作 32-bit 立即数处理。注意它不会处理所有带 `Imme` 的字段名，例如 `IQK0-FRx/Imme` 这种仍然走普通整数分支。

5. `Send Mails(9bit)` / `Rec Mails(9bit)` 特殊展开

   ```
   elif field_name == 'Send Mails(9bit)':
       result[field_name] = self.解析指令mailbox字段(inst_type, 'S-', value)
   elif field_name == "Rec Mails(9bit)":
       result[field_name] = self.解析指令mailbox字段(inst_type, 'R-', value)
   ```

   这两个字段不是直接保存 9-bit 数字，而是调用 [解析指令mailbox字段 (line 1437)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/instruction_dispatch/instruction_dispatch.py:1437) 展开成一个子字典。

   例如某条 `PE_CONV` 的 `Send Mails(9bit)` 值为 `0b000000101`，会变成类似：

   ```
   {
       "Send Mails(9bit)": 5,
       "S-PE-VP": 1,
       "S-PE-DT": 0,
       "S-PE-PE": 1,
       "S-PE-SO": 0,
       "S-PE-ST": 0,
       "S-PE-SI": 0,
       "S-PE-LW": 0,
       "S-PE-LD": 0,
       "S-PE-CT": 0,
   }
   ```

   这个结构后面会被 `等待发射条件`、`指令开始收信`、`指令结束寄信` 使用。比如 `指令结束寄信('PE', Send_mail)` 会读取 `Send_mail['S-PE-CT']`、`Send_mail['S-PE-DT']` 等字段。

6. 其他字段原样保存为 Python int

   ```
   else:
       result[field_name] = value
   ```

   包括 opcode、reserved 位、寄存器编号、模式字段等，都会以指令表里的原始字段名作为 key 写入结果。字段名允许中文和特殊字符，例如 `"opcode（CT_MOV）"`、`"DstBlock-BRx"`。

最终返回的 `result` 是 executor 和 trace 使用的统一解析结果。例如 `CT_MOV Rx Imme` 解析后大致会包含：

```
{
    "opcode（CT_MOV）": ...,
    "0000": ...,
    "rsv_0": ...,
    "Rx": ...,
    "rsv_1": ...,
    "Imme": np.uint32(...)
}
```

需要注意的几个细节：

- 该函数不做符号扩展，所有字段默认按无符号位域解析。
- `inst_type` 不会出现在返回结果里，只用于 mailbox 字段命名。
- mailbox 字段是嵌套字典，不是把 `S-PE-CT` 这些 key 展平到顶层。
- 函数开头有一个 `print("")`，每次解析都会输出空行，这是一个可见副作用。
- 如果某个字段没有 `index` 或 `length`，会被跳过。