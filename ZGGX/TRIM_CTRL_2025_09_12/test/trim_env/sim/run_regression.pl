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
my $all=0;
my $rm_pass=0;
my $dump_fail=0;
my $help=0;
my $re_run=0;

$work_dir = $dir;
$list_dir = $dir;
$list_dir =~ s/sim(.*)/script/ ;


GetOptions(
    'suite=s'   => \$suite,
    'run'       => \$run,
    'report'    => \$report,
    'rm_pass'   => \$rm_pass,
    're_run'    => \$re_run,
    'dump_fail' => \$dump_fail,
    'cov'       => \$cov,
    'comp'      => \$comp,
    'num=s'     => \$num,
    'all'      => \$all,
    'h'         => \$help
);
printf "%s\n",$list_dir;
if($cov){
    open(CASE_LIST,"$list_dir/case_list_cov");
}
else{
    open(CASE_LIST,"$list_dir/case_list");
}
my @case_list = <CASE_LIST>;

my $seqname=0;
my $tcname=0;
my $sim_cmd=0;
my $run_cnt=0;
my $comp_define=0;
my @define;
my $case_num=1;

$comp_define = shift @case_list;
if($comp){
    @define = split/\s+/, $comp_define ;
    print @define;
    foreach $comp_define (@define){
        if($cov){
            system("make clean comp_all $comp_define COV=1 PARTCOMP=0 REGRESS=1");
            #system("make clean comp_all $comp_define COV=1 REGRESS=1");
        }
        else {
            system("make clean comp_all $comp_define REGRESS=1");
        }
    }
}
for(0..$num){
    foreach $line (@case_list) {
        chomp($line);
        if($suite ne 0) {
            if($line =~ /^SUITE=(\w*)/){
                if(($1 eq $suite) || ($suite eq "all")){
                    if($line =~ /case_num=(\w*)/){$case_num=$1;}
                    for(1..$case_num){
                        if(($line =~ /seq=(\w*)/)||($line =~ /tc=(\w*)/)){$seqname=$1;}
                        if(($line =~ /(seq=\w*.*\z)/)||($line =~ /(tc=\w*.*\z)/)){
                            $sim_cmd=$1;
                            if(!($report)){
                                print"=================================================================================================================\n";
                                print"\n";
                                print "running case is suite=$suite TESTCASE=$seqname\n$sim_cmd case_num=$case_num\n";
                                print"\n";
                                print"=================================================================================================================\n";
                            }
                            if($run) {
                                if($cov){
                                    system("make simv $sim_cmd COV=1 PARTCOMP=0 REGRESS=1");
                                    #system("make simv $sim_cmd COV=1 REGRESS=1");
                                }
                                else{
                                    system("make simv $sim_cmd REGRESS=1");
                                }
                                $casepid = `ps -ef | grep \`whoami\` | grep 'simv.demo' | grep -v grep | wc -l`;
                                while($casepid > 30) {
                                  sleep 15;
                                  $casepid = `ps -ef | grep \`whoami\` | grep 'simv.demo' | grep -v grep | wc -l`;
                                }
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
    my $retry_cnt = 0;
    my $awarray_cnt = 0;
    my $ararray_cnt = 0;
    
    #my @log_dir = glob "$work_dir/*/trim*_vseq";
    #my @log_list = glob "$work_dir/*/vcs_sim*.log";

    system("rm -rf $work_dir/regression*/trim_common_vseq*");

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

    print REPORT_NAME_TMP"=============================================================================================================================\n";
    print REPORT_NAME_TMP"     TESTCASE                                                                  Status    ERR_NUM     FATAL_NUM    WARNING_NUM\n";
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
       my $RETRY_FIFO_MAX_CNT=0;
       my $AWARRAY_MAX_CNT=0;
       my $ARARRAY_MAX_CNT=0;

       $total_num = $total_num + 1;
    
       $log_name = shift @log_list;
       ####print REPORT_NAME_TMP "log_name: $log_name\n";#add
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
              if(($_ =~ /^ERROR/)||($_ =~ /^Error/)){
                  $ERR_CNT = $ERR_CNT+1;
                  if($_ =~ /^Error.*Violate rule/) {
                      $ERR_CNT = $ERR_CNT-1;
                  }
              }
              if(($_ =~ /^WARNING:/)||($_ =~ /^Warning/)){
                  $WARNING_CNT = $WARNING_CNT+1;
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
    print REPORT_NAME_TMP "-----------------------------------------------------------------------------------------------------------------------------\n";
    print REPORT_NAME_TMP "         comp_err:$comp_err    Total:$total_num      NOT_FINISH:$not_finish_num      PASSED:$pass_num      FAILED:$fail_num\n";
    print REPORT_NAME_TMP "=============================================================================================================================\n";
    close REPORT_NAME_TMP;
    
    print("log list analyze done!!!\n");


    #if($rm_pass){
    #    &remove_pass_dir;
    #}
    #if($dump_fail){
    #    &fail_case_dump_wave;
    #}
    
}

if($re_run){
    &fail_case_regression;
}

sub remove_pass_dir {
    print("delete dir of passed cases!!!\n");
    open(REPORT,"$dir/regression_report.txt");
    my @report_txt = <REPORT>;
    foreach $line_t (@report_txt) {
        chomp($line_t);
        if($line_t =~ /(s.*)PASSED/){
            system("rm -rf $work_dir/$1");
        }
    }
}

sub fail_case_dump_wave{
    print("dump wave of failed cases!!!\n");
    open(REPORT,"$dir/regression_report.txt");
    my @report_txt = <REPORT>;
    foreach $line_t (@report_txt) {
        chomp($line_t);
        if($line_t =~ /(s.*_vseq)_(\d*)\s*FAILED/){
            system("make simu seq=$1 SEED=$2");
        }
    }
}

sub fail_case_regression{
    print("re-regression failed cases!!!\n");
    open(REPORT,"$dir/regression_report_fail.txt");
    my @report_txt = <REPORT>;
    system("make clean comp_all REGRESS=1 USER_DEFINE=DRAM_6");
    ##system("make clean comp_all USER_DEFINE=PMU_COV REGRESS=1");
    foreach $line_t (@report_txt) {
        chomp($line_t);
        #print("$line_t\n");
        if($line_t =~ /(trim.*_test)_trim_common_vseq_DRAM_6_(\d*)\s*FAILED/){
            system("make simv tc=$1 SEED=$2 REGRESS=1 dump_mode=off UVM_VERBOSITY=UVM_NONE USER_DEFINE=DRAM_6");
        }
        elsif($line_t =~ /(trim.*_vseq)_DRAM_6_(\d*)\s*FAILED/){
            system("make simv seq=$1 SEED=$2 REGRESS=1 dump_mode=off UVM_VERBOSITY=UVM_NONE USER_DEFINE=DRAM_6");
        }
        ##elsif($line_t =~ /(*_vseq)_PMU_COV_(\d*)\s*FAILED/){
        ##    #print("$1,$2\n");
        ##    system("make sim seq=$1 SEED=$2 REGRESS=1 USER_DEFINE=PMU_COV");
        ##}
        ##elsif($line_t =~ /(*_vseq)__(\d*)\s*FAILED/){
        ##    #print("$1,$2\n");
        ##    system("make sim seq=$1 SEED=$2 REGRESS=1");
        ##}
    }
}

if($help) {
    print"===============================help start=================================\n";
    print"Usage run_regression.pl:./script/run_regression.pl [Options]\n";
    print"OPTIONS\n";
    print"    -suite=[option]\n";
    print"                    Specify the cases for simulate:can be 'suitename' or 'all'\n";
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
    print"    run regression of many cases with compile: ./script/run_regression.pl -suite=*** -run -comp\n";
    print"    run regression of many cases without compile: ./script/run_regression.pl -suite=*** -run\n";
    print"    just check cases report: ./script/run_regression.pl -report\n";
    print"    run regression of all cases with coverage: \n";
    print"        ./script/run_regression.pl -run -cov -suite=all\n";
    print"==========================================================================\n";
}
