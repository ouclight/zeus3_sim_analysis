tc  = trim_common_test
seq = trim_common_vseq
TST_NAME = $(tc)
SEQ_NAME = $(seq)

PWD                 := $(shell pwd)
SEED                := $(shell perl -e "print int(rand(100000000))")
PARTCOMP            := 1 #if collect coverage,need config PARTCOMP=0
##lid#3TIMEOUT             := 10000000000000000 ##10ms
TIMEOUT             := 200000000 ##100ms
REGRESS             := 0
COV                 := 0
UVM_VERBOSITY		:= UVM_LOW
MAX_QC				:= 500
SVA_DUMP_ON			:= 0

dump_mode           :=fsdb#vpd,fsdb,off
gui                 :=off#off#dve,verdi,off

ifeq ($(dump_mode),vpd)
    GUI_OPT = +vpdfile+./trim_tb.vpd
endif
ifeq ($(dump_mode),fsdb)
    GUI_OPT = +fsdbfile+./trim_tb.fsdb
endif

ifeq ($(gui),dve)
    GUI_OPT += -gui
endif
ifeq ($(gui),verdi)
    GUI_OPT += -gui=verdi
endif
ifeq ($(gui),off)
    GUI_OPT +=
endif

ifeq ($(REGRESS),1)
UVM_VERBOSITY		= UVM_LOW	
ifeq ($(TST_NAME),trim_common_test)
sim_dir   = $(SIM_PATH)/regression/$(SEQ_NAME)_$(USER_DEFINE)_$(SEED)
cov_dir   = $(SEQ_NAME)_$(SEED)
else
sim_dir   = $(SIM_PATH)/regression/$(TST_NAME)_$(SEQ_NAME)_$(USER_DEFINE)_$(SEED)
cov_dir   = $(TST_NAME)_$(SEQ_NAME)_$(SEED)
endif
WORK_PATH = $(SIM_PATH)/regression
log_dir   = $(WORK_PATH)/log_dir/log_dir_$(USER_DEFINE)
exe_dir   = $(WORK_PATH)/exe_dir/exe_dir_$(USER_DEFINE)
else
ifeq ($(TST_NAME),trim_common_test)
sim_dir   = $(SIM_PATH)/$(SEQ_NAME)_$(USER_DEFINE)_$(SEED)
cov_dir   = $(SEQ_NAME)_$(SEED)
else
sim_dir   = $(SIM_PATH)/$(TST_NAME)_$(SEQ_NAME)_$(USER_DEFINE)_$(SEED)
cov_dir   = $(TST_NAME)_$(SEQ_NAME)_$(SEED)
endif
WORK_PATH = $(sim_dir)
log_dir   = $(WORK_PATH)/log_dir_$(USER_DEFINE)
exe_dir   = $(WORK_PATH)/exe_dir_$(USER_DEFINE)
endif

$(shell mkdir -p $(sim_dir) $(log_dir) $(exe_dir) $(WORK_PATH))
$(shell cp $(PWD)/synopsys_sim.setup  $(WORK_PATH))

COMP_OPTS   := -sverilog -full64 +libext+.v+.vp -ntb_opts uvm-1.1 +define+VCS -timescale=1ns/1ps \
              +define+UVM_NO_DEPRECATED+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR+SYNOPSYS_SV \
              +define+UVM_PACKER_MAX_BYTES=1500000+UVM_HDL_MAX_WIDTH=1280  \
			  +define+DW_MODEL_MISSAMPLES+TSMC_CM_UNIT_DELAY \
			  +define+SVT_UVM_TECHNOLOGY \
			  +define+UVM_DISABLE_AUTO_ITEM_RECORDING \
			  +define+UVM_REG_NO_INDIVIDUAL_FIELD_ACCESS\
			  +define+UVM_USE_REALTIME_IN_MSGS \
			  +define+SYNOPSYS_SV \
			  +define+SVT_APB_DISCONNECT_TOP_LEVEL_APB_IF_SIGNALS \
			  +define+SVT_APB_MAX_DATA_WIDTH=32 \
			  +define+SVT_APB_MAX_ADDR_WIDTH=11 \
			  +define+APB_SLAVE_NUM=1 \
			  +define+SVT_MEM_INITIALIZE_RAND=5 \
			  +define+RTLSIM \
			  +define+$(USER_DEFINE) -debug_all -debug_region+cell+encrypt -kdb -lca
			  #+define+$(USER_DEFINE) -debug_acc+all+dmptf -debug_region+cell+encrypt -kdb
			  #lid#+define+IDLE_CHECK \
			  
			  
#0716#ELAB_OPTS   := -liblist_work +vcs+lic+wait -full64 -debug_acc+all+dmptf -debug_region+cell+encrypt -ntb_opts uvm-1.2 +vpi \
#0716#              +warn=noINAV +warn=noTFIPC +warn=noFRCREF +warn=noTIME-RESOLUTION-WRN-SRC +nolibcell -j10 -fgp\
#0716#			  +nospecify -kdb -lca +error+1000 

ELAB_OPTS   := -liblist_work +vcs+lic+wait -full64 -debug_acc+all+dmptf -ntb_opts uvm-1.1 +vpi \
              +warn=noINAV +warn=noTFIPC +warn=noFRCREF +warn=noTIME-RESOLUTION-WRN-SRC +nocelldefinepli+0 +nolibcell -j4 \
			  +nospecify -kdb -lca


ifeq ($(strip $(PARTCOMP)),1)
ELAB_OPTS += -partcomp -fastpartcomp=j10
endif

ifeq ($(COV),1)
COV_DIR     = $(SIM_PATH)/cov_database
#PARTCOMP   := 0 #if collect coverage,need config PARTCOMP=0
COV_COPTS  = -cm_dir $(COV_DIR)/cm -cm line+cond+fsm+tgl+branch+assert -cm_tgl portsonly+mda -cm_noconst -cm_line contassign -cm_cond basic+allops+full+std+event+anywidth+for+tf -cm_hier $(PWD)/../script/cov_file -cm_libs yv+celldefine
COV_ROPTS  = -cm line+cond+fsm+tgl+branch+assert -cm_name $(cov_dir)
SIM_OPTS += $(COV_ROPTS)
endif

ifeq ($(dump_mode),fsdb)
    SIM_OPTS += +fsdb+sva_success
endif

SIM_OPTS += +seed=$(SEED) +fsdb+force +fsdb+autoflush +vcs+flush+all +define+$(USER_DEFINE) +dump_mode=$(dump_mode) -ucli -i ./run_vcs.ucli -timescale=1ns/1ps

.PHONY: clean
clean:
	rm -rf $(sim_dir)/simv.demo* $(sim_dir)/csrc $(sim_dir)/*.log $(sim_dir)/work/ $(sim_dir)/*.fsdb

.PHONY: clean_all
clean_all:
	rm -rf sim_dir/*

.PHONY: comp
comp:
	mkdir -p $(sim_dir); \
	cd $(WORK_PATH) ;\
	vlogan $(COMP_OPTS) +define+UVM_VCS_RECORD+UVM_TR_RECORD+UVM_VERDI_NO_COMPWAVE -l $(log_dir)/comp_uvm.log
	#cd $(WORK_PATH) ;\
	#vhdlan -full64 -work vhd_lib -f vhd.f -l $(log_dir)/comp_vhd.log
	cd $(WORK_PATH) ;\
	vlogan $(COMP_OPTS) -assert svaext  $(COMP_INCDIR) -work work -f $(PWD)/../flist/flist.f -l $(log_dir)/comp.log
	cd $(WORK_PATH) ;\
	vlogan $(COMP_OPTS) -work phy_spine_u $(ENV_DIR)/tb/quad/phy/phy_spine_u.v -l $(log_dir)/phy_spine_u.log 
	cd $(WORK_PATH) ;\
	vlogan $(COMP_OPTS) -work phy_spine_d $(ENV_DIR)/tb/quad/phy/phy_spine_d.v -l $(log_dir)/phy_spine_d.log
	#+incdir+/opt/synopsys2/syn/S-2021.06-SP5-3/dw/sim_ver/ \
	#-y /opt/synopsys2/syn/U-2022.12-SP7/dw/sim_ver
	#-y /opt/synopsys2/syn/U-2022.12-SP7/dw/sim_ver -y $(COMMON_RTL_DIR)
	@echo "========================================"
	@echo "============>  Compile Done  <=========="
	@echo "========================================"
	@echo "sim_dir :  $(WORK_PATH)"
	@echo "comp_log:  $(log_dir)/comp.log"

.PHONY: elab
elab:
	cd $(WORK_PATH) ;\
	vcs $(ELAB_OPTS) $(COV_COPTS) trim_tb -o $(exe_dir)/simv.demo -l $(log_dir)/elab.log -Mdirectory=$(exe_dir)/csrc
	@echo "========================================"
	@echo "============>  Elab Done  <============="
	@echo "========================================"
	@echo "sim_dir :  $(WORK_PATH)"
	@echo "elab_log:  $(log_dir)/elab.log"

.PHONY: simv
simv:
	ln -s  $(exe_dir)/simv.demo $(sim_dir)/simv.demo; \
	ln -s  $(exe_dir)/simv.demo.daidir $(sim_dir)/simv.demo.daidir; \
	ln -s  $(exe_dir)/csrc $(sim_dir)/csrc; \
	cd $(sim_dir); \
	cp $(PWD)/*.do* $(PWD)/*.ucli $(PWD)/synopsys_sim.setup ./ ; \
	./simv.demo +ntb_random_seed=$(SEED) +UVM_VERDI_TRACE=HIER +UVM_TESTNAME=$(TST_NAME) +UVM_SEQ_NAME=$(SEQ_NAME) +UVM_VERBOSITY=$(UVM_VERBOSITY) +UVM_MAX_QUIT_COUNT=$(MAX_QC) +UVM_TIMEOUT=$(TIMEOUT) $(COV_ROPTS) -l vcs_sim.log &
	@echo ""
	@echo "--------------------------------- sim_reuslt ------------------------------------"
	@echo "sim_dir:  $(WORK_PATH)"
	@echo "sim_log:  $(sim_dir)/vcs_sim.log"
	@echo "sim_fsdb: $(sim_dir)/trim_tb.fsdb"
	@echo "---------------------------------------------------------------------------------"

.PHONY: simu
simu:
	ln -s  $(exe_dir)/simv.demo $(sim_dir)/simv.demo; \
	ln -s  $(exe_dir)/simv.demo.daidir $(sim_dir)/simv.demo.daidir; \
	ln -s  $(exe_dir)/csrc $(sim_dir)/csrc; \
	cd $(sim_dir); \
	cp $(PWD)/*.do* $(PWD)/*.ucli $(PWD)/synopsys_sim.setup ./ ; \
	./simv.demo +ntb_random_seed=$(SEED) +UVM_VERDI_TRACE=HIER +UVM_TESTNAME=$(TST_NAME) +UVM_SEQ_NAME=$(SEQ_NAME) +UVM_VERBOSITY=$(UVM_VERBOSITY) +UVM_MAX_QUIT_COUNT=$(MAX_QC) +UVM_TIMEOUT=$(TIMEOUT) $(SIM_OPTS) $(GUI_OPT) -l vcs_sim.log & 

	@echo ""
	@echo "--------------------------------- sim_reuslt ------------------------------------"
	@echo "sim_dir:  $(WORK_PATH)"
	@echo "sim_log:  $(sim_dir)/vcs_sim.log"
	@echo "sim_fsdb: $(sim_dir)/trim_tb.fsdb"
	@echo "---------------------------------------------------------------------------------"

allu:comp elab simv

all:comp elab simu

PHONY: comp_all
comp_all: comp elab

.PHONY: help
help:
	@echo "|------------------------------------------------------------------------------------------|"
	@echo "|-------------------------          cmd help          -------------------------------------|"
	@echo "|                                                                                          |"
	@echo "| make all seq=**        dump_mode=fsdb gui=verdi      //run with verdi-gui and dump fsdb  |"
	@echo "| make all seq=**        dump_mode=fsdb gui=off        //run without gui and dump fsdb     |"
	@echo "|                                                                                         |"
	@echo "| make all seq=**        dump_mode=vpd  gui=dve        //run with dve-gui and dump vpd     |"
	@echo "| make all seq=**        dump_mode=vpd  gui=off        //run without gui and dump vpd      |"
	@echo "|                                                                                         |"
	@echo "| make all seq=**        dump_mode=off  gui=off        //run without gui and NO fsdb&vpd   |"
	@echo "| make all seq=** tc=**  dump_mode=vpd  gui=dve        //when tc!=ddr_common_test,add tc=**|"
	@echo "|                                                                                          |"
	@echo "|-------------------------          cmd help          -------------------------------------|"
	@echo "|------------------------------------------------------------------------------------------|"

.PHONY: verdi
verdi:
	\novas -dbdir $(sim_dir)/simv.demo.daidir -ssf $(sim_dir)/*.fsdb

.PHONY: merge
merge:
	\urg -full64 -dir $(SIM_PATH)/cov_database/cm.vdb -dbname $(SIM_PATH)/cov_merged_$(shell date +%m%d%H%M%S).vdb
