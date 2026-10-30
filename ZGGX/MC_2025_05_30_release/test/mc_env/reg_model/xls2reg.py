#!/opt/application/anaconda/anaconda3/bin/python
import os
import re
import xlrd
import xlwt
import argparse
import sys

# file define
XLS_PATH = './'; XLS_NAME = 'Module_reg.xls';MODULE_NUB = '1'; REG_BOCKDOOR = '1';
# column define
MO_NA_C = 0; OFFSET_ADDR = 1; REG_NA = 2; SIG_NA = 3; S_BIT = 4; SIZE_C = 5; TYPE_C = 6; RST_VAL = 7; DES_C = 8;

def give_reg(sheet,nrows,module):
    data1='';data2='';data3='';data4='';data5='';data6='';
    fname=''
    base_addr=''
    reg_name=''
    signal_name=''
    start_bit=''
    size=''
    reg_type=''
    reset_v=''
    reg_ro_flag = 0
    r_offset    = ''
    r_reg       = ''
    check_bit   = 0.0

    fname = "ral_"+module + ".sv"
    OF1 = open(fname,"w")
    data1+="`ifndef " + "RAL_" + module + "\n"
    data1+="`define " + "RAL_" + module + "\n\n"
    #data1+="import uvm_pkg::*;\n"
    data1+="`define UVM_REG_ADDR_WIDTH 32\n\n"
#--------------------------------------------------------------------
#class ral for one data, class block for one data
    for cnt in range(1,nrows):
        base_addr = del_block(sheet,cnt,OFFSET_ADDR)
       # base_addr = sheet.cell(nr,nc).value
        reg_name  = del_block(sheet,cnt,REG_NA)
        if(reg_name != "reserved"):
            if(base_addr != ""):
                if((check_bit != 0.0) and (check_bit != 32)):
                    #print(r_reg,"try bit total error",check_bit,"bit : reg bit must be 32bit")
                    reg_ro_flag = 1;
                r_offset = base_addr
                r_reg = reg_name
                data6+= data1 + data2 + data3 + data4 + data5
                data1 = '';data2 = '';data3 = '';data4 = '';data5 = ''
                if(reg_ro_flag == 0):
                    data1+="class ral_reg_"+ module +"_top_"+ reg_name +" extends uvm_reg;\n"
                check_bit = 0.0

            signal_name = del_block(sheet,cnt,SIG_NA)
            start_bit   = del_block(sheet,cnt,S_BIT)
            size        = del_block(sheet,cnt,SIZE_C)
            if(del_block(sheet,cnt,TYPE_C) == "ROD"):
                reg_type    = "RO"
            else: 
                reg_type    = del_block(sheet,cnt,TYPE_C)
            #print(reg_type)
            reset_v     = del_block(sheet,cnt,RST_VAL)
            #print(check_bit,start_bit)
            if( check_bit != float(start_bit) and check_bit != 0.0):
                print(signal_name,"error bit",check_bit,start_bit)
            check_bit = float(start_bit)+float(size)
            if(reg_ro_flag == 0):
                if(signal_name != "reserved"):
                    data2+=" "*4+"rand uvm_reg_field "+ signal_name +";\n"
                if(base_addr != ""):
                    data3+="\n"+" "*4+"function new(string name = \""+ module +"_top_"+ reg_name +"\");\n"
                    data3+=" "*8+"super.new(name,32,build_coverage(UVM_NO_COVERAGE));\n"+" "*4 + "endfunction: new\n"+" "*4+"virtual function void build();\n"
                if(signal_name != "reserved"):
                    data4+=" "*8 + "this."+ signal_name +" = uvm_reg_field::type_id::create(\""+ signal_name +"\",,get_full_name());\n"
                    data4+=" "*8 + "this."+ signal_name +".configure(this,"+ size +","+ start_bit +",\""+ reg_type +"\",0,32'h"+ reset_v +",1,0,0);\n"
                if(base_addr != ""):
                    data5+=" "*4+"endfunction: build\n\n"+" "*4+" `uvm_object_utils(ral_reg_"+ module +"_top_"+ reg_name +")\n"+"endclass:ral_reg_"+ module +"_top_"+ reg_name +"\n\n"
            reg_ro_flag = 0;
    if(check_bit != 32):
        print(r_reg,"bit total error",check_bit,"bit : reg bit must be 32bit")
    data6+= data1 + data2 + data3 + data4 + data5
    print(data6,file=OF1)
    OF1.close()
    return fname

def define_reg(fnm,sheet,nrows,module):
    data1='';data2='';data3='';data4=''
    reg_name=''
    signal_name=''
    r_reg = ''

    OF1 = open(fnm,"a")
    data1 += "class ral_block_" + module + "_top extends uvm_reg_block;\n"
#------------------------------------------------------------------------
    for cnt in range(1,nrows):
        reg_name = del_block(sheet,cnt,REG_NA)
        if(reg_name != "reserved"):
            if(reg_name != ""):
                r_reg = reg_name
                data4 += data2 + data3
                data3 = ''
                data2 = " "*4+"rand ral_reg_"+ module +"_top_"+ reg_name +" "+ reg_name +";\n"
            signal_name = del_block(sheet,cnt,SIG_NA)
            if(signal_name != "reserved"):
                 data3 +=" "*4+"rand uvm_reg_field "+ r_reg + "_" + signal_name +";\n"
                 data3 +=" "*4+"rand uvm_reg_field "+ signal_name +";\n"
        
    data4 += data2 + data3 + "\n"
    data4 += " "*4+"function new(string name = \"ral_block_"+module +"_top\");\n"
    data4 += " "*8+"super.new(name,build_coverage(UVM_NO_COVERAGE));\n"
    data4 += " "*4+"endfunction: new\n\n"
    print(data1,file=OF1)
    print(data4,file=OF1)
    OF1.close()

def def_reg(fnm,sheet,nrows,module,hd_s):
    data1='';data2='';data3='';data4='';data_hdl=''
    offset_address=''
    reg_name=''
    signal_name=''
    r_reg = ''

    OF1 = open(fnm,"a")
    data1+=" "*4+"virtual function void build();\n"
    data1+=" "*8+"this.default_map = create_map(\"\",0,4,UVM_LITTLE_ENDIAN, 0);\n"
#--------------------------------------------------------------------
    for cnt in range(1,nrows):
        reg_name = del_block(sheet,cnt,REG_NA)
        if(reg_name != "reserved"):
            if( reg_name != ""):
                r_reg = reg_name
                offset_address = del_block(sheet,cnt,OFFSET_ADDR)
                data4 += data2 + data3
                data3 = ''
                data2 =" "*8+ "this."+r_reg+" = ral_reg_"+module+"_top_"+r_reg+"::type_id::create(\""+r_reg+"\",,get_full_name());\n"
                data2+=" "*8+"this."+r_reg+".configure(this, null, \"\");\n"
                data2+=" "*8+"this."+r_reg+".build();\n"
                data2+=" "*8+"this.default_map.add_reg(this."+r_reg+", `UVM_REG_ADDR_WIDTH'h"+offset_address+",\"RW\",0);\n"
            signal_name = del_block(sheet,cnt,SIG_NA)
            if(signal_name != "reserved"):
                data3+=" "*12+"this."+r_reg+"_"+signal_name+" = this."+r_reg+"."+signal_name +";\n"
                if(r_reg != signal_name):
                    data3+=" "*12+"this."+signal_name+" = this."+r_reg+"."+signal_name +";\n\n"
                else:
                    data3+="\n"
                #if(r_reg != signal_name):
                #    print(data3)
    data4 += data2 + data3
    #print(data4)
    data_hdl = def_hdl(fnm,sheet,nrows)
    if(hd_s == '1'):
        data4 += data_hdl + "\n"
    data4 += " "*4+"endfunction : build\n\n"+" "*4+"`uvm_object_utils(ral_block_"+module+"_top)\n\n"
    data4 += "endclass : ral_block_"+module+"_top\n\n"
    #print(data4)

    print(data1,file=OF1)
    print(data4,file=OF1)
    OF1.close()

def def_hdl(fnm,sheet,nrows):
    data_hdl=''
    final_note=''
    
    s_bit    = ''
    size_bit = ''

    OF1 = open(fnm,"a")
    data_hdl+=" "*12+"//add hdl path\n"
    #--------------------------------------------------------------------
    for cnt in range(1,nrows):
        reg_name = del_block(sheet,cnt,REG_NA)
        if(reg_name != "reserved"):
            if( reg_name != ""):
                r_reg = reg_name
            signal_name = del_block(sheet,cnt,SIG_NA).lower()
            s_bit       = del_block(sheet,cnt,S_BIT)
            size_bit    = del_block(sheet,cnt,SIZE_C)
            reg_type    = del_block(sheet,cnt,TYPE_C)
            if(reg_type == "RW" or reg_type == "W1C"):
                final_note = "o"
            if(reg_type == "RO" or reg_type == "ROD"):
                final_note = "i"
            if(signal_name != "reserved"):
                data_hdl+=" "*12+"this."+r_reg+".add_hdl_path_slice(\""+signal_name+"_"+final_note+"\","+s_bit+","+size_bit+");\n"
    #print(data_hdl)
    return data_hdl

def def_block(fnm,module,regb,args,addr):
    data1=''
    top_reg=''
    matic=''
    top_reg = module.swapcase()

    b_addr = del_block(module_base,1,0)
    b_addr = int(b_addr,16)

    OF1 = open(fnm,"a")
    data1+="class ral_sys_"+module+" extends uvm_reg_block;\n\n"
    if(args.num == "1"):
        data1+=" "*4+"rand ral_block_"+module+"_top "+ top_reg + "_ins;\n\n"
    else:
        data1+=" "*4+"rand ral_block_"+module+"_top "+ top_reg + "_ins["+ args.num +"];\n\n"
    data1+=" "*4+"function new(string name = \""+module+"\");\n"+" "*8+"super.new(name);\n"+" "*4+"endfunction: new\n\n"
    data1+=" "*4+"function void build();\n"
    data1+=" "*8+"this.default_map = create_map(\"\", 0, 4, UVM_LITTLE_ENDIAN, 0);\n\n"
    if(args.num == "1"):
        data1+=" "*8+"this."+ top_reg +"_ins = ral_block_"+module+"_top::type_id::create(\""+ top_reg +"_ins\",,get_full_name());\n"
        data1+=" "*8+"this."+ top_reg +"_ins.configure(this, \"\");\n"
        data1+=" "*8+"this."+ top_reg +"_ins.build();\n"
    else:
        data1+=" "*8+"foreach("+ top_reg + "_ins[ii])\n"
        data1+=" "*8+"begin\n"
        data1+=" "*12+"this."+ top_reg +"_ins[ii] = ral_block_"+module+"_top::type_id::create($sformatf(\""+ top_reg +"_ins%0d\",ii),,get_full_name());\n"
        data1+=" "*12+"this."+ top_reg +"_ins[ii].configure(this, \"\");\n"
        data1+=" "*12+"this."+ top_reg +"_ins[ii].build();\n"
        data1+=" "*8+"end\n"
    if(args.num == "1"):
        data1+=" "*8+"this.default_map.add_submap(this."+ top_reg +"_ins.default_map, `UVM_REG_ADDR_WIDTH\'h0);\n"
        if(regb[0] != '' and args.back == '1'):
            data1+=" "*8+"this."+ top_reg +"_ins.add_hdl_path(\""+regb[0]+"\");\n"
    else:
        #for cnt in range(0,len(addr)):
        for cnt in range(0,int(args.num)):
            data1+=" "*8+"this.default_map.add_submap(this."+ top_reg +"_ins["+str(cnt)+"].default_map, `UVM_REG_ADDR_WIDTH\'h"+ str(hex(int(addr[cnt],16) + b_addr))+");\n"
            if(regb[cnt] != '' and args.back == '1' ):
                data1+=" "*8+"this."+ top_reg +"_ins["+str(cnt)+"].add_hdl_path(\""+regb[cnt]+"\");\n"

    data1+="\n"+" "*4+"endfunction : build\n\n"
    data1+=" "*4+"`uvm_object_utils(ral_sys_"+module+")\n"
    data1+="endclass : ral_sys_"+module+"\n\n"
    data1+="`endif"
    print(data1,file=OF1)
    OF1.close()

#def del_e(regb):
#    file_d = ''
#    pfl = open(regb,"r")
#    for line in pfl:
#        line = line.strip('\n')
#        file_d += line
#    return file_d

def upfile(fnm):
    file_up = ""
    file_data = ""
    file_up = open(fnm,"r")
    for line in file_up:
        if ".0" in line:
            line = line.replace(".0","")
        if "0x" in line:
            line = line.replace("0x","")
        file_data += line
    file_up = open(fnm,"w")
    file_up.write(file_data)
        
def del_block(sheet,nr,nc):
    word = str(sheet.cell(nr,nc).value)
    word = word.strip()
    return word

def check_offset(sheet,nrows):
    nub = 0
    for cnt in range(1,nrows):
        reg_name = del_block(sheet,cnt,REG_NA)
        if( reg_name != ""):
            offset_add = sheet.cell(cnt,OFFSET_ADDR).value
            offset_add = int(offset_add,16)
            check_add  = nub*4;
            #print(nub,check_add,offset_add)
            if(check_add != offset_add):
                print("warning:"+"missing"+hex(check_add))
            nub = nub + 1
            

if __name__ == '__main__':
    print('reg model start.')
    fnm=''
    module=''
    hdl_path = []
    o_addr = []

    parser = argparse.ArgumentParser();
    parser.add_argument('--path',default=XLS_PATH     ,help='--path is excl ')
    parser.add_argument('--f'   ,default=XLS_NAME     ,help='--f is excl file name')
    parser.add_argument('--num' ,default=MODULE_NUB   ,help='--num is number of module')
    parser.add_argument('--back',default=REG_BOCKDOOR ,help='--this option for backdoor')

    args = parser.parse_args()
    if not os.path.exists(args.path+args.f):
        print("ERROR:The register excel file \"" + args.path+args.f + "\" does not exist !!! Please check !!!")
        sys.exit()

    workbook=xlrd.open_workbook(args.path+args.f)

    sheet_n=workbook.sheet_names()
    #print(int(args.num))
    for word in sheet_n:
        if "ADDR" in word:
            if "BASE" in word:
                print("Sheet BASE_ADDR is for define file.")
            else:
                module_base = workbook.sheet_by_name(word)
        if "REG" in word:
            sheet=workbook.sheet_by_name(word)
    if(sheet == ""):
        print("error:can not find reg sheet in excel, please check sheet name!")
        sys.exit()
    brows=module_base.nrows
    bcols=module_base.ncols

    if(str(args.num) != str(brows - 3)):
        print("warning:you numbre is:"+args.num+"but module addr have:"+str(brows - 3))
    if(args.num != '1'):
        for i in range(3,brows):
            hdl_path.append(del_block(module_base,i,2))
            o_addr.append(del_block(module_base,i,1))
    elif(args.num == '1'):
        hdl_path.append(del_block(module_base,3,2))

    if(args.back != '1'):
        print("backdoor close.")
    if(hdl_path[0] == '' and args.back == '1'):
        print("warning:can not find path in excel,please check excel")

    nrows=sheet.nrows
    ncols=sheet.ncols
    check_offset(sheet,nrows)

    module = del_block(sheet,1,0)
    fnm    = give_reg(sheet,nrows,module)
    define_reg(fnm,sheet,nrows,module)
    def_reg(fnm,sheet,nrows,module,args.back)
    def_block(fnm,module,hdl_path,args,o_addr)
    upfile(fnm)
    
