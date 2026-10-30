    parameter STOP_ON_ERROR    =       0; // If set to 1, the model will halt on command sequence/major errors
  
  
    parameter  ROW_BITS            =   13;
    parameter  COL_BITS            =    8;
    parameter  IO_BITS             =   256;
    parameter  PAR_BITS            =    16;
    parameter  DATA_BITS           =   IO_BITS+PAR_BITS;
    parameter  MEM_BITS            =   ROW_BITS+COL_BITS;
    parameter  alpha               = 10;   
    
    reg   [23:0]  ROSC_TRM_CODE    = 24'b1011_0011_0000_1010_0110_1100;
    
    reg   [23:0]  ROSC_RINGO1      = 24'b0010_1101_0000_0000_0000_0000;
    reg   [23:0]  ROSC_RINGO2      = 24'b0010_0100_0000_0000_0000_0000;
    reg   [23:0]  ROSC_RINGO3      = 24'b0011_1000_0000_0000_0000_0000;
    reg   [23:0]  ROSC_RINGO4      = 24'b0010_1000_0000_0000_0000_0000;
    reg   [23:0]  ROSC_RINGO5      = 24'b0011_0000_0000_0000_0000_0000;
    reg   [23:0]  ROSC_RINGO6      = 24'b0010_0000_0000_0000_0000_0000;
    
    realtime     dum_ready_time=1000000;
    
    
    reg [7:0]  BK0=0;
    reg [7:0]  BK1=1;
    reg [7:0]  BK2=2;
    reg [7:0]  BK3=3;
    reg [7:0]  BK4=4;
    reg [7:0]  BK5=5;
    reg [7:0]  BK6=6;
    reg [7:0]  BK7=7;
    reg [7:0]  BK8=8;
    reg [7:0]  BK9=9;
    
    reg [7:0]  BK10=10;
    reg [7:0]  BK11=11;
    reg [7:0]  BK12=12;
    reg [7:0]  BK13=13;
    reg [7:0]  BK14=14;
    reg [7:0]  BK15=15;
    reg [7:0]  BK16=16;
    reg [7:0]  BK17=17;
    reg [7:0]  BK18=18;
    reg [7:0]  BK19=19;
    
      
    reg [7:0]  BK20=20;
    reg [7:0]  BK21=21;
    reg [7:0]  BK22=22;
    reg [7:0]  BK23=23;
    reg [7:0]  BK24=24;
    reg [7:0]  BK25=25;
    reg [7:0]  BK26=26;
    reg [7:0]  BK27=27;
    reg [7:0]  BK28=28;
    reg [7:0]  BK29=29;
    
    
    reg [7:0]  BK30=30;
    reg [7:0]  BK31=31;
    reg [7:0]  BK32=32;
    reg [7:0]  BK33=33;
    reg [7:0]  BK34=34;
    reg [7:0]  BK35=35;
    reg [7:0]  BK36=36;
    reg [7:0]  BK37=37;
    reg [7:0]  BK38=38;
    reg [7:0]  BK39=39;
    
      
    reg [7:0]  BK40=40;
    reg [7:0]  BK41=41;
    reg [7:0]  BK42=42;
    reg [7:0]  BK43=43;
    reg [7:0]  BK44=44;
    reg [7:0]  BK45=45;
    reg [7:0]  BK46=46;
    reg [7:0]  BK47=47;
    reg [7:0]  BK48=48;
    reg [7:0]  BK49=49;
    
      
    reg [7:0]  BK50=50;
    reg [7:0]  BK51=51;
    reg [7:0]  BK52=52;
    reg [7:0]  BK53=53;
    reg [7:0]  BK54=54;
    reg [7:0]  BK55=55;
    reg [7:0]  BK56=56;
    reg [7:0]  BK57=57;
    reg [7:0]  BK58=58;
    reg [7:0]  BK59=59;
    
        
    
    parameter real tRAS           =       27;
    `ifdef CLK_500M
    parameter real tCCD           =       4;
    `elsif CLK_300M
    parameter real tCCD           =       6.67;
    `else
    parameter real tCCD           =       2.49;
    `endif
    parameter real tRC            =       40;
    parameter real tRCD           =     14.5;
    parameter real tRP            =       13;
    parameter real tAA            =        6;
    parameter real tRTW           =      7.5;
    parameter real tWTR           =        5;     
    parameter real tRTP           =        0;
    parameter real tWTP           =        15;
    
    parameter real trask_min      =     -0.1;    
    parameter real trask_max      =      0.1;    
    parameter real trask_dly      =      0.1; 
    
    
    parameter real tcask_min      =     -1.8;    
    parameter real tcask_max      =      1.8;    
    parameter real tcask_dly      =      1.8;    
    
    
    
    
    parameter real tRCH_min      =      0.45*tCCD;    
    parameter real tRCH_max      =      0.55*tCCD;    
    parameter real tRCL_min      =      0.45*tCCD;    
    parameter real tRCL_max      =      0.55*tCCD;    
    
    
    parameter real tWCH_min      =      0.45*tCCD;    
    parameter real tWCH_max      =      0.55*tCCD;    
    parameter real tWCL_min      =      0.45*tCCD;    
    parameter real tWCL_max      =      0.55*tCCD;    
    
    
    parameter real tprdrdy_min   =      0.4*tCCD;    
    parameter real tprdrdy_max   =      0.6*tCCD;    
    
