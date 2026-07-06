`parse_instruction_type(instruction)` 的功能是：
**把一条 64-bit 指令整数解析成对应的指令助记符字符串**，例如解析出 `"LD_MOV BRx BRy ..."`、`"DT_RES BRx BRy ..."`、`"CT_WAIT IDs"` 等。

位置：[opcode_518.py (line 438)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/instruction_arch/opcode_518.py:438)

函数代码：

```
def parse_instruction_type(instruction):
    """根据指令值解析指令类型"""
    opcode = (instruction >> 56) & 0xFF
    sub_opcode = (instruction >> 52) & 0xF

    for key, value in opcode_dic.items():
        if value == opcode:
            if key == 'opcode（CT_NOTI）':
                noti_subop = (instruction >> 45) & 0x7FF
                return CT_NOTI_subcode.get(noti_subop, "Unknown")

            sudcode = globals()[key[7:-1] + '_subcode']

            if key in [... CT 算术/逻辑类 ...]:
                return sudcode[sub_opcode][(instruction >> 44) & 0x1]
            elif len(sudcode) == 1:
                return sudcode[0]
            else:
                return sudcode[sub_opcode]
```

**1. 输入是什么**

`instruction` 是一条已经编码好的 64-bit 指令，类型是整数。

例如：

```
instruction = 0x7800_0000_0000_0000
```

函数不解析具体字段值，例如 BRx、BRy、mail、CSS，它只判断“这条指令是哪一种格式”。

**2. 先取 opcode**

```
opcode = (instruction >> 56) & 0xFF
```

意思是取 bit `[63:56]`，也就是最高 8 bit。

比如：

```
opcode（LD_MOV） = 0x78
opcode（ST_MOV） = 0x98
opcode（DT_RES） = 0xe9
```

如果 instruction 的最高 8 bit 是 `0xe9`，就会匹配到：

```
"opcode（DT_RES）": 0xe9
```

**3. 再取 sub_opcode**

```
sub_opcode = (instruction >> 52) & 0xF
```

意思是取 bit `[55:52]`，4 bit。

很多 opcode 下有多个子类型。例如 `CT_SETB` 下面有：

```
CT_SETB-A BRx BRy
CT_SETB-W BRx BRy
CT_SETBM-A ...
CT_SETBM-W ...
...
```

这些就靠 `sub_opcode` 选择。

**4. 遍历 opcode_dic 查找 opcode 名字**

```
for key, value in opcode_dic.items():
    if value == opcode:
```

`opcode_dic` 的 key 是这种字符串：

```
"opcode（DT_RES）"
```

value 是实际 opcode 数字：

```
0xe9
```

找到匹配后，函数就知道当前指令属于哪个大类。

**5. 特殊处理 CT_NOTI**

```
if key == 'opcode（CT_NOTI）':
    noti_subop = (instruction >> 45) & 0x7FF
    return CT_NOTI_subcode.get(noti_subop, "Unknown")
```

`CT_NOTI` 比较特殊，它不是用普通的 4-bit `sub_opcode [55:52]`，而是用 11-bit 字段 `[55:45]` 区分：

```
CT_GET
CT_WAIT
CT_SEND
```

对应表是：

```
CT_NOTI_subcode = {
    0b00000000000: "CT_GET",
    0b00100001000: "CT_WAIT IDs",
    0b00110001000: "CT_SEND IDs",
}
```

如果 11-bit 模式不在表里，就返回：

```
"Unknown"
```

**6. 根据 opcode 名字找到对应 subcode 表**

```
sudcode = globals()[key[7:-1] + '_subcode']
```

这里变量名写成了 `sudcode`，应该是 `subcode` 的拼写误差，但不影响运行。

关键是这句：

```
key[7:-1]
```

例如：

```
key = "opcode（DT_RES）"
```

`key[7:-1]` 会取出：

```
"DT_RES"
```

然后拼接：

```
"DT_RES_subcode"
```

再用 `globals()` 找到同名全局变量：

```
DT_RES_subcode = [
    "DT_RES BRx BRy {CSS} R(CT,LD,...,VP) S(CT,LD,...,VP)"
]
```

也就是说，它通过 opcode 名字动态找到对应的 subcode 表。

**7. CT 算术/逻辑类特殊处理 bit44**

对于这些指令：

```
CT_ADD
CT_SUB
CT_MUL
CT_DIV
CT_FADD
CT_FSUB
CT_FMUL
CT_FDIV
CT_LSL
CT_LSR
CT_ASR
CT_ROR
CT_AND
CT_OR
CT_XOR
CT_NOT
```

代码走这个分支：

```
return sudcode[sub_opcode][(instruction >> 44) & 0x1]
```

原因是这些指令的 subcode 表里有的元素本身是一个二级列表，例如：

```
CT_ADD_subcode = [
    ["CT_ADD Rx Ry Rz", "CT_ADD Rx Ry Imme"],
    ...
]
```

这里：

- `sub_opcode` 先选大子类
- bit `[44]` 再区分寄存器形式还是立即数形式

例如：

- bit44 = 0 -> `"CT_ADD Rx Ry Rz"`
- bit44 = 1 -> `"CT_ADD Rx Ry Imme"`

**8. 如果 subcode 表只有一个元素**

```
elif len(sudcode) == 1:
    return sudcode[0]
```

说明这个 opcode 下没有多个子类型。

例如：

```
DT_RES_subcode = [
    "DT_RES BRx BRy {CSS} R(CT,LD,...,VP) S(CT,LD,...,VP)"
]
```

不需要看 `sub_opcode`，直接返回唯一格式。

`LD_MOV`、`ST_MOV`、`DT_RES`、`PE_CONV` 等大多属于这种。

**9. 普通多 subcode 指令**

```
else:
    return sudcode[sub_opcode]
```

如果 subcode 表有多个元素，就直接用 bit `[55:52]` 作为索引。

例如：

```
VP_SETM_subcode = [
    "VP_SETM-LUT ...",   # sub_opcode = 0
    "VP_SETM-CMD ...",   # sub_opcode = 1
    "VP_SETM-CFS ...",   # sub_opcode = 2
    ...
    "VP_SETM-SPM ..."    # sub_opcode = 15
]
```

如果 instruction 的 `[55:52] = 2`，就返回：

```
"VP_SETM-CFS [SRLC,GPFSMDL1,SCFS,GPFS]"
```

**10. 返回值用于哪里**

调用点很多，例如：

```
instr_type = opcode_518.parse_instruction_type(instruction)
```

之后仿真器会用返回的字符串去：

- 查 `inst_dic` 中字段布局
- 解析 instruction 里的具体字段
- 分发到对应 executor

所以这个函数是“二进制指令整数 -> 指令格式名”的第一步解析。

**一个例子**

如果 instruction 的最高 8 bit 是 `0xe9`：

```
opcode = 0xe9
```

匹配：

```
"opcode（DT_RES）": 0xe9
```

得到：

```
DT_RES_subcode
```

因为这个表只有一个元素，所以返回：

```
"DT_RES BRx BRy {CSS} R(CT,LD,...,VP) S(CT,LD,...,VP)"
```

**需要注意的几个边界**

- 如果 opcode 不在 `opcode_dic` 里，函数当前没有显式返回，会返回 `None`。
- 如果普通指令的 `sub_opcode` 超出对应列表长度，可能抛 `IndexError`。
- 如果 subcode 表里对应项是 `"empty"`，函数会返回 `"empty"`，后续流程需要自己处理。
- `CT_NOTI` 是特殊编码，不走普通 4-bit `sub_opcode` 逻辑。