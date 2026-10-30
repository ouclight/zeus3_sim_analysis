tc  = mc_common_test
seq = mc_common_vseq
TST_NAME = $(tc)
SEQ_NAME = $(seq)

PWD                 := $(shell pwd)
seed                := $(shell perl -e "print int(rand(100000000))")
PARTCOMP            := 1 #if collect coverage,need config PARTCOMP=0
TIMEOUT             := 500000000000
REGRESS             := 0
COV                 := 0
UVM_VERBOSITY		:= UVM_MEDIUM

dump_mode           :=fsdb#vpd,fsdb,off
gui                 :=off#dve,verdi,off



ifeq ($(REGRESS),1)
UVM_VERBOSITY		= UVM_LOW	
ifeq ($(TST_NAME),mc_base_test)
sim_dir   = $(SIM_PATH)/regression/$(SEQ_NAME)_$(seed)
cov_dir   = $(SEQ_NAME)_$(seed)
else
sim_dir   = $(SIM_PATH)/regression/$(TST_NAME)_$(SEQ_NAME)_$(seed)
cov_dir   = $(TST_NAME)_$(SEQ_NAME)_$(seed)
endif
WORK_PATH = $(SIM_PATH)/regression
log_dir   = $(WORK_PATH)/log_dir/log_dir_$(USER_DEFINE)
exe_dir   = $(WORK_PATH)/exe_dir/exe_dir_$(USER_DEFINE)
else
ifeq ($(TST_NAME),mc_base_test)
sim_dir   = $(SIM_PATH)/$(SEQ_NAME)_$(seed)
cov_dir   = $(SEQ_NAME)_$(seed)
else
sim_dir   = $(SIM_PATH)/$(TST_NAME)_$(SEQ_NAME)_$(seed)
cov_dir   = $(TST_NAME)_$(SEQ_NAME)_$(seed)
endif
WORK_PATH = $(sim_dir)
log_dir   = $(WORK_PATH)/log_dir
exe_dir   = $(WORK_PATH)/exe_dir
endif

$(shell mkdir -p $(sim_dir) $(log_dir) $(exe_dir) $(WORK_PATH))
$(shell cp $(PWD)/synopsys_sim.setup  $(WORK_PATH))
RANDOM_TAA = $(shell awk -v min=6 -v max=18 'BEGIN{srand(); print 3+int(rand()*(max-min+1))/2}')
$(shell sed -i -E "s/assign [0-9](.[0-9])?/assign $(RANDOM_TAA)/" $(PWD)/gen.txt)
#+define+DW_MODEL_MISSAMPLES+TSMC_CM_UNIT_DELAY
COMP_OPTS   := -sverilog -full64 +libext+.v+.vp -ntb_opts uvm-1.2 +define+VCS -timescale=1ns/1ps \
              +define+UVM_NO_DEPRECATED+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR+SYNOPSYS_SV \
              +define+UVM_PACKER_MAX_BYTES=1500000+UVM_HDL_MAX_WIDTH=1280  \
			  +define+DW_MODEL_MISSAMPLES+TSMC_CM_UNIT_DELAY \
			  +define+SVT_UVM_TECHNOLOGY \
			  +define+UVM_DISABLE_AUTO_ITEM_RECORDING \
			  +define+UVM_REG_NO_INDIVIDUAL_FIELD_ACCESS\
			  +define+SYNOPSYS_SV \
			  +define+SVT_APB_DISCONNECT_TOP_LEVEL_APB_IF_SIGNALS \
              +define+SVT_APB_MAX_DATA_WIDTH=32 \
              +define+SVT_APB_MAX_ADDR_WIDTH=32 \
			  +define+SVT_APB_MAX_NUM_SLAVES_1\
			  +define+UVM_USE_REALTIME_IN_MSGS\
			  +define+RTLSIM \
			  +define+INIT_DRAM_ALL_EN \
			  +define+$(USER_DEFINE) -debug_acc+all+dmptf -debug_region+cell+encrypt -kdb
			  
			  
ELAB_OPTS   := -liblist_work +vcs+lic+wait -full64 -debug_acc+all+dmptf -debug_region+cell+encrypt -ntb_opts uvm-1.2 +vpi \
              +warn=noINAV +warn=noTFIPC +warn=noFRCREF +warn=noTIME-RESOLUTION-WRN-SRC +nolibcell -j4 -fgp\
			  -parameters $(PWD)/gen.txt\
			  +nospecify -kdb -lca 

ifeq ($(strip $(PARTCOMP)),1)
ELAB_OPTS += -partcomp -fastpartcomp=j4
endif

ifeq ($(COV),1)
COV_DIR     = $(SIM_PATH)/cov_database
#PARTCOMP   := 0 #if collect coverage,need config PARTCOMP=0
COV_COPTS  = -cm_dir $(COV_DIR)/cm -cm line+cond+fsm+tgl+branch+assert -cm_tgl portsonly+mda -cm_noconst -cm_line contassign -cm_cond basic+allops+full+std+event+anywidth+for+tf -cm_hier $(PWD)/../script/cov_file -cm_libs yv+celldefine
COV_ROPTS  = -cm line+cond+fsm+tgl+branch+assert -cm_name $(cov_dir)
SIM_OPTS += $(COV_ROPTS)
endif

ifeq ($(gui),verdi)
    GUI_OPT += -gui=verdi
endif
ifeq ($(gui),off)
    GUI_OPT +=
endif

SIM_OPTS += +seed=$(seed) +fsdb+force +fsdbfile+./mc_tb.fsdb +define+$(USER_DEFINE) +dump_mode=$(dump_mode) -ucli -i ./run_vcs.ucli

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
	vlogan $(COMP_OPTS) -assert svaext  $(COMP_INCDIR) -work work -f $(PWD)/../flist/flist.f -l $(log_dir)/comp.log \
	#-y /opt/synopsys2/syn/U-2022.12-SP7/dw/sim_ver -y $(COMMON_DIR)
	@echo "========================================"
	@echo "============>  Compile Done  <=========="
	@echo "========================================"

.PHONY: elab
elab:
	cd $(WORK_PATH) ;\
	vcs $(ELAB_OPTS) $(COV_COPTS) mc_tb -o $(exe_dir)/simv.demo -l $(log_dir)/elab.log -Mdirectory=$(exe_dir)/csrc +error+50
	@echo "========================================"
	@echo "============>  Elab Done  <============="
	@echo "========================================"

.PHONY: simv
simv:
	ln -s  $(exe_dir)/simv.demo $(sim_dir)/simv.demo; \
	ln -s  $(exe_dir)/simv.demo.daidir $(sim_dir)/simv.demo.daidir; \
	ln -s  $(exe_dir)/csrc $(sim_dir)/csrc; \
	cd $(sim_dir); \
	cp $(PWD)/*.do* $(PWD)/*.ucli $(PWD)/synopsys_sim.setup ./ ; \
	./simv.demo +ntb_random_seed=$(seed) +UVM_VERDI_TRACE=HIER +UVM_TESTNAME=$(TST_NAME) +UVM_SEQ_NAME=$(SEQ_NAME) +UVM_VERBOSITY=$(UVM_VERBOSITY) +UVM_TIMEOUT=$(TIMEOUT) $(SIM_OPTS) $(GUI_OPT) -l vcs_sim.log &
	@echo "\n--------------------------------- sim_reuslt ------------------------------------"
	@echo "sim_dir: $(WORK_PATH)"
	@echo "sim_log: $(sim_dir)/vcs_sim.log"
	@echo "---------------------------------------------------------------------------------&"

.PHONY: simy
simy:
	ln -s  $(exe_dir)/simv.demo $(sim_dir)/simv.demo; \
	ln -s  $(exe_dir)/simv.demo.daidir $(sim_dir)/simv.demo.daidir; \
	ln -s  $(exe_dir)/csrc $(sim_dir)/csrc; \
	cd $(sim_dir); \
	cp $(PWD)/*.do* $(PWD)/*.ucli $(PWD)/synopsys_sim.setup ./ ; \
	./simv.demo +ntb_random_seed=$(seed) +UVM_VERDI_TRACE=HIER +UVM_TESTNAME=$(TST_NAME) +UVM_SEQ_NAME=$(SEQ_NAME) +UVM_VERBOSITY=$(UVM_VERBOSITY) +UVM_TIMEOUT=$(TIMEOUT) $(SIM_OPTS) $(GUI_OPT) -l vcs_sim.log +fsdb+delta
	@echo "\n--------------------------------- sim_reuslt ------------------------------------"
	@echo "sim_dir: $(WORK_PATH)"
	@echo "sim_log: $(sim_dir)/vcs_sim.log"
	@echo "---------------------------------------------------------------------------------&"

all:comp elab simv
run:comp elab simy

PHONY: comp_all
comp_all: comp elab

.PHONY: help
help:
	@echo "|------------------------------------------------------------------------------------------|"
	@echo "|-------------------------          cmd help          -------------------------------------|"
	@echo "|                                                                                          |"
	@echo "| make all seq=**        dump_mode=fsdb gui=verdi      //run with verdi-gui and dump fsdb  |"
	@echo "| make allu seq=**       dump_mode=fsdb gui=verdi      //In this way, operation can be paused(Ctrl+c),if want continue(run), quit(q)|"
	@echo "| make all seq=**        dump_mode=fsdb gui=off        //run without gui and dump fsdb     |"
	@echo "|                                                                                          |"
	@echo "| make all seq=**        dump_mode=vpd  gui=dve        //run with dve-gui and dump vpd     |"
	@echo "| make all seq=**        dump_mode=vpd  gui=off        //run without gui and dump vpd      |"
	@echo "|                                                                                          |"
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
	\urg -dir $(SIM_PATH)/cov_database/cm.vdb -dbname $(SIM_PATH)/cov_merged_$(shell date +%m%d%H%M%S).vdb
