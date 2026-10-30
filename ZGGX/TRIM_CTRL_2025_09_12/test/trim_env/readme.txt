You Need Update Some file:
1. update test/trim_env/sim/setup.csh - update envionment variables
   update envionment variables: SIM_PATH,DESIGNWARE_HOME,VIP_APB_DIR,VIP_AXI_DIR
Run case:
1. enter test/trim_env/sim
2. source setup.csh
3. source svn_up_rtl.csh (if your RTL is the latest version ,this step can be omitted )
4. run case (you can select from the test/trim_env/script/case_list )
   Example:make all seq=trim_power_up_init_vseq SEED=7011018(if you need run some seed,you can select this option) dump_mode=fsdb gui=verdi(gui option can not be used)
           make all tc=trim_reg_test seq=trim_regtest_seq dump_mode=fsdb gui=verdi(gui option can not be used) &
           make all tc=trim_reg_test gui=verdi(gui option can not be used) &
5. if set 6 layers dram,run case example:
  make all seq=trim_power_up_init_vseq dump_mode=fsdb gui=off USER_DEFINE=DRAM_6

  
Run Regression:
1. add your case to trim_env/script/case_list: SUITE=xxx  tc=xxx  case_num=xxx  USER_DEFINE=  timeout=xxxx  UVM_VERBOSITY=UVM_NONE(UVM_VERBOSITY also needn't)
2. run regression (you can select from the test/trim_env/script/case_list)
   Example: 
   ./run_regression.pl -comp -run -suite=xxx/all -num=10 (the total number of a case is 10*case_num(the case_num in case_list))

3. if regression test have failed seed, you can modify sim/regression_report.txt -> sim/regression_report_fail.txt, and delete old regression log, then you can execute this command to run regression with those failed seed:
   ./run_regression.pl -re_run
