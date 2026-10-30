#!/usr/bin/perl -w
use Getopt::Long;
use Term::ANSIColor qw(:constants);
#$Term::ANSIColor::AUTORESET = 1 ;

my $dir=$ENV{'PWD'};
my $suite=0;
my $run=0;
my $report=0;
my $cov=0;
my $comp=0;
my $num=0;
my $comp_num=1;
my $max=0;
my $rm_pass=0;
my $dump_fail=0;
my $clk_freq=450;
my $help=0;
$jobs=60;


$work_dir = $dir;
$list_dir = $dir;
$list_dir =~ s/sim(.*)/script/ ;


GetOptions(
    'suite=s'   => \$suite,
    'run'       => \$run,
    'report'    => \$report,
    'rm_pass'   => \$rm_pass,
    'dump_fail' => \$dump_fail,
    'cov'       => \$cov,
    'comp'      => \$comp,
    'num=s'     => \$num,
    'comp_num=s'=> \$comp_num,
    'clk_freq=s'=> \$clk_freq,
    'max'       => \$max,
    'h'         => \$help
);


#if($suite eq "all") {
#    open(CASE_LIST,"$list_dir/case_list");
#}
#else {
#    open(CASE_LIST,"$list_dir/case_list_$suite");
#}

open(CASE_LIST,"$list_dir/case_list");
my @case_list = <CASE_LIST>;
my $seqname=0;
my $cmd_line=0;
my $run_cnt=0;
my $comp_define=0;
my @define;

foreach $line (@case_list) {
    if($line =~ /^case_list:/){
        last;
    }
    $comp_num++;
}
#print "comp_num =$comp_num\n";
if($comp){
    system("rm -rf $work_dir/regression*");
}
for(0..$comp_num){
    $comp_define = shift @case_list;
    if($comp){
        @define = split/\n+/, $comp_define ;
        #system("rm -rf $work_dir/regression*");
        print @define;
        foreach $comp_define (@define){
            if($comp_define =~ /^USER_DEFINE=(\w*).*/){
                if($cov){
                    #system("make clean comp_all $comp_define  COV=1 REGRESS=1");
                    system("make clean comp_all $comp_define  COV=1 PARTCOMP=0 REGRESS=1");
                }
                else {
                    system("make clean comp_all $comp_define REGRESS=1");
                }
            }
        }
    }
}
for(0..$num){
    foreach $line (@case_list) {
        chomp($line);
        if($suite ne 0) {
            if($line =~ /^SUITE=(\w*).*case_num=(\d*)(.*)/){
                $case_num=$2;
                $cmd_line=$3;
                if(($1 eq $suite) || ($suite eq "all")){
                    if(!($report)){
                        print"=================================================================================================================\n";
                        print"\n";
                        print "running case is suite=$suite TESTCASE=$cmd_line\n";
                        print"\n";
                        print"=================================================================================================================\n";
                    }
                    for(1..$case_num){
                        if($run) {
                            if($cov){
                                system("make simv $cmd_line COV=1 PARTCOMP=0 dump_mode=off REGRESS=1 CLK_FREQ=$clk_freq");
                            }
                            else{
                                system("make simv $cmd_line dump_mode=off REGRESS=1 CLK_FREQ=$clk_freq");
                            }
                            sleep 10;
                            $casepid = `ps -ef | grep \`whoami\` | grep 'simv.demo' | grep -v grep | wc -l`;
                            while($casepid > $jobs) {
                              sleep 10;
                              $casepid = `ps -ef | grep \`whoami\` | grep 'simv.demo' | grep -v grep | wc -l`;
                            }
                        }
                    }
                }
            }
        }
    }
    
    #&handle_all_log;
}

if($report){
    &handle_all_log;
}

sub handle_all_log{
    my $pass_num = 0;
    my $fail_num = 0;
    my $not_finish_num = 0;
    my $total_num = 0;
    my $comp_err = 0;
    
    system("rm -rf $work_dir/regression*/mc_common_test_mc_common_vseq*");
    my @log_dir = glob "$work_dir/regression*/*_[0-9]*";
    my @log_list = glob "$work_dir/regression*/*/vcs_sim.log";
    if($#log_list!=$#log_dir){
        $comp_err = 1;
        print BOLD RED;
        print "Error:vcs_run log of some cases not generate:log_num =$#log_list, log_dir_num=$#log_dir\n";
        print RESET;
    }
    my $report_name_tmp = 'regression_report.txt';
    
    open REPORT_NAME_TMP , '>', $report_name_tmp or die  "can not open $report_name_tmp";

    if($#log_list!=$#log_dir){
        $comp_err = 1;
        print REPORT_NAME_TMP"Error:vcs_run log of some cases not generate:log_num =$#log_list, log_dir_num=$#log_dir\n";
    }

    print REPORT_NAME_TMP"=============================================================================================================================\n";
    print REPORT_NAME_TMP"     TESTCASE                                                                   Status    ERR_NUM    FATAL_NUM    WARNING_NUM\n";
    print REPORT_NAME_TMP"-----------------------------------------------------------------------------------------------------------------------------\n";

    print "=============================================================================================================================\n";
    print "     TESTCASE                                                                   Status    ERR_NUM    FATAL_NUM    WARNING_NUM\n";
    print "-----------------------------------------------------------------------------------------------------------------------------\n";
    
    for (0..$#log_list){
       my $log_name;
       my $testcase;
       my $status;
       my $WARNING_CNT=0;
       my $ERR_CNT=0;
       my $FATAL_CNT=0;
       my $finish=0;
       my $REPORT_FLAG=0;
       my $ARRAY_ERR_FILTER=0;
       my $DELAY_ERR_FILTER=0;
       my $array_rst_time=0;
       my $array_rst_release_time=0;
       $total_num = $total_num + 1;
    
       $log_name = shift @log_list;
       print REPORT_NAME_TMP "log_name: $log_name\n";#add
       $testcase = $log_name;
       open LOG_NAME , '<', $log_name or die  "can not open $log_name";
       #$testcase =~ s#.*vcs_run_(.*).log#$1#;
       $testcase =~ s#.*\/(.*)\/vcs_sim.log#$1#;

       $ERR_CNT=0;
       $REPORT_FLAG=0;
       while (<LOG_NAME>){
          if ($_ =~/UVM Report Summary/){
              $REPORT_FLAG=1;
          }
          if($_ =~ /\$finish at/){
              $finish = 1 ;
          }
          if($REPORT_FLAG==1){
              if($_ =~ /UVM_WARNING :\s+(\d+)/){
                  if ($1 != 0) {$WARNING_CNT = $WARNING_CNT+1;}
              }
              if($_ =~ /UVM_ERROR :\s+(\d+)/){
                  if ($1 != 0) {$ERR_CNT = $ERR_CNT+$1;}
              }
              if($_ =~ /UVM_FATAL :\s+(\d+)/){
                  if ($1 != 0) {$FATAL_CNT = $1;}
              }
          }
          else {
              if($_ =~ /UVM_WARNING/){
                  if($_ =~ /UVM_WARNING reports/) {}
                  else{
                      $WARNING_CNT = $WARNING_CNT+1;
                  }
              }
              if($_ =~ /UVM_ERROR/){
                  if($_ =~ /UVM_ERROR reports/) {}
                  #elsif(($testcase=~ /multi_pe2ddr_sr/)&&($_ =~ /send_data_trans_q not empty when case finished !!!/)){
                  #    $ERR_CNT = $ERR_CNT-1;
                  #}
                  #elsif(($testcase=~ /multi_pe2ddr_sr_big_pkt_test/)&&($_ =~ /send_data_trans_q not empty when case finished !!!/)){
                  #    $ERR_CNT = $ERR_CNT-1;
                  #}
                  #elsif($_ =~ /soc_stress_1logic_test_vseq] real sram final data not equal cmodel data. addr=5aa06, real data=2, cmodel data=1/){
                  #    $ERR_CNT = $ERR_CNT-1;
                  #}
                  else{
                      $ERR_CNT = $ERR_CNT+1;
                  }
              }
              if($_ =~ /UVM_FATAL/){
                  if($_ =~ /UVM_FATAL reports/) {}
                  else{
                      $FATAL_CNT = $FATAL_CNT+1;
                  }
              }
              if(($_ =~ /^ERROR:/)||($_ =~ /^Error/)){
                  $ERR_CNT = $ERR_CNT+1;
              }
              if(($_ =~ /^WARNING:/)||($_ =~ /^Warning/)){
                  $WARNING_CNT = $WARNING_CNT+1;
              }
              if($_ =~ /(\d*)\.(\d*) ns:.*resetn rst start/){
                  #if($_ =~ /(\d*)\.(\d*) ns: reporter \[RESET_CHECK\] array_reset ok/){
                  #array_rst_time = $1;
                  $ARRAY_ERR_FILTER = 1;
              }
              if($_ =~ /(\d*)\.(\d*) ns:.*resetn rst release/){
                  #$array_rst_release_time = $1;
                  $ARRAY_ERR_FILTER = 0;
              }
              #winbond
              #if($_ =~ /time 20.000 ns:ERROR_CUBE_HC03_BK0:   tWCH max violation, duration:  20.000 ns, spec: 1.375000 ns/){
              #    #$array_rst_release_time = $1;
              #    $ARRAY_ERR_FILTER = 1;
              #}
              #if($_ =~ /time 20.000 ns:ERROR_CUBE_HC03_BK0:   tRAS violation, duration:  20.000 ns, spec: 27.000000 ns/){
              #    #$array_rst_release_time = $1;
              #    $ARRAY_ERR_FILTER = 1;
              #}
              #if($_ =~ /time 20.000 ns:ERROR_CUBE_HC03_BK0:   tWTP violation, duration:   0.000 ns, spec: 15.000000 ns/){
              #    #$array_rst_release_time = $1;
              #    $ARRAY_ERR_FILTER = 1;
              #}
              #if($_ =~ /time 20.000 ns:ERROR_CUBE_HC03_BK0:   tRCH_max violation, duration:  20.000 ns, spec: 1.375000 ns/){
              #    #$array_rst_release_time = $1;
              #    $ARRAY_ERR_FILTER = 1;
              #}

              if($_ =~ /ARRAY_DIE_ERR.*time is\s*(\d*)\.(\d*).*ns/){
                  if(($ARRAY_ERR_FILTER==0)) {$ERR_CNT = $ERR_CNT+1;}
              }
              if($_ =~ /mc_rstn_chk_vseq/){
                  $ARRAY_ERR_FILTER = 1;
              }

              if($_ =~ /ERROR_CUBE_HC03_BK0/){
                  if($ARRAY_ERR_FILTER==0) {$ERR_CNT = $ERR_CNT+1;}
              }
              if($_ =~ /003 ns:ERROR_CUBE_HC03_BK/){
                  $ERR_CNT = $ERR_CNT-1;
              }
              if($_ =~ /Bank is not activative/){
                  $ERR_CNT = $ERR_CNT-1;
              }

          }
       }

       if (($ERR_CNT > 0)||($FATAL_CNT>0)){
          $status = "FAILED";
          print BOLD RED;
          printf "||  %-75s %-11s %-11s %-11s %-7s||\n",$testcase,$status,$ERR_CNT,$FATAL_CNT,$WARNING_CNT;
          print RESET;
          printf REPORT_NAME_TMP "||  %-75s %-11s %-11s %-11s %-7s||\n",$testcase,$status,$ERR_CNT,$FATAL_CNT,$WARNING_CNT;
          $fail_num = $fail_num + 1;
       }
       elsif($finish==0){
           $status = "NOT_FINISH";
           print BOLD BLUE;
           printf "||  %-75s %-35s %-7s||\n",$testcase,$status,$WARNING_CNT;
           print RESET;
           printf REPORT_NAME_TMP "||  %-75s %-35s %-7s||\n",$testcase,$status,$WARNING_CNT;
           $not_finish_num = $not_finish_num + 1;
       }
       else {
           $status = "PASSED";
           printf "||  %-75s %-35s %-7s||\n",$testcase,$status,$WARNING_CNT;
           printf REPORT_NAME_TMP "||  %-75s %-35s %-7s||\n",$testcase,$status,$WARNING_CNT;
           $pass_num = $pass_num + 1;
       }
      
       close LOG_NAME;
    }
    
    print"-----------------------------------------------------------------------------------------------------------------------------\n";
    print BOLD BLACK;
    print"          comp_err:$comp_err    Total:$total_num    NOT_FINISH:$not_finish_num    PASSED:$pass_num    FAILED:$fail_num\n";
    print RESET;
    print"=============================================================================================================================\n";
    print REPORT_NAME_TMP "-------------------------------------------------------------------------------------------\n";
    print REPORT_NAME_TMP "         comp_err:$comp_err    Total:$total_num      NOT_FINISH:$not_finish_num      PASSED:$pass_num      FAILED:$fail_num\n";
    print REPORT_NAME_TMP "===========================================================================================\n";
    close REPORT_NAME_TMP;
    
    print("log list analyze done!!!\n");

}


if($help) {
    print"===============================help start=================================\n";
    print"Usage run_regression.pl:./run_regression.pl [Options]\n";
    print"OPTIONS\n";
    print"    -suite=[option]\n";
    print"                    Specify the cases for simulate:can be 'suitename' or 'all',refer to case_list\n";
    print"    -comp\n";
    print"                    Perform compile,elab\n";
    print"    -num=[option]\n";
    print"                    Specify the round number for simulate:should be 'number'\n";
    print"    -run\n";
    print"                    Run simulate\n";
    print"    -cov\n";
    print"                    Collect code coverage\n";
    print"    -report\n";
    print"                    print simulate report of cases in your screen\n";
    print"    -h\n";
    print"                    Usage of this script\n";
    print"Example:\n";
    print"    run regression of many cases with compile: ./run_regression.pl -suite=*** -run -comp\n";
    print"    run regression of many cases without compile: ./run_regression.pl -suite=*** -run\n";
    print"    just check cases report: ./run_regression.pl -report\n";
    print"    run regression of all cases with coverage: \n";
    print"        ./run_regression.pl -run -cov -suite=all\n";
    print"==========================================================================\n";
}
