module unload vcs
module unload verdi
module unload vcstatic
module load vcstatic/2021.09
#module load vcstatic/2022.06-sp1
#module load vcs/mx-2018
#module load verdi/2018.09

setenv SIM_PATH `pwd`

#setenv DESIGNWARE_HOME /home/jiaoyad/VIP/synopsys
setenv DESIGNWARE_HOME /opt/synopsys2/vc-vip/2021.12-2022.03
#setenv VIP_APB_DIR  $DESIGNWARE_HOME/viplist/vip_apb_201806
setenv VIP_APB_DIR  /home/anainv/VIP/synopsys/viplist/vip_apb_202112

#setenv MODULE_DIR      $PWD/../../..  #need modify manually
setenv ENV_DIR      $PWD/..
setenv RTL_DIR      $PWD/../../../rtl
setenv COMMON_DIR   $PWD/../../../../common/rtl 
setenv AUX_DIR      $PWD/../../../.. 
setenv QUAD_DIR     $PWD/../tb/quad
setenv PHY_DIR      $PWD/../../../../phy/rtl
setenv DW_DIR               /opt/synopsys2/syn/U-2022.12-SP7/dw/sim_ver
