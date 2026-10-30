suggested use vcs2021
After entering the mc_wrapper verification environment

1. cd sim,open setup.csh

2. modify "SIM_PATH,DESIGNWARE_HOME,VIP_APB_DIR,VIP_AXI_DIR,DW_DIR" path pointing

3. under the sim path,source setup.csh

4. make all seq=mc_reg_vseq USER_DEFINE=NO_INIT, detail please refer to script/case_list

5. if regression, use "./run_regression.pl -comp -run -suite=all"

6. collect regression result, use "./run_regression.pl -report"

