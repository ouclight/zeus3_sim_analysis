// DO NOT CHANGE THE TIMESCALE
// MAKE SURE YOUR SIMULATOR USES "nS" RESOLUTION
`timescale 1ns/1ps

//`define WEC_DIS_DEBUG_CUBE_HC03_BK0
//`define WEC_DIS_ERROR_CUBE_HC03_BK0
//`define WEC_DIS_WARN_CUBE_HC03_BK0
`define WEC_DIS_INFO_CUBE_HC03_BK0


//-------------------------------------------------------------
module CUBE_HC03_BK0 (         
    bnksel_n_i,
    g_radd_i,
    g_cadd_i,
    g_cas_rd_i,
    g_cas_wr_i,
    g_rdrdy_n_o,
    g_rwdl_io,
    reset_n
);

    `include "Config-AC.v"
   
    // Declare Ports
    input                 bnksel_n_i;
    input [ROW_BITS-1:0]  g_radd_i;
    input [COL_BITS-1:0]  g_cadd_i;
     
    input                 g_cas_rd_i;
    input                 g_cas_wr_i;
    output                g_rdrdy_n_o;
    inout [DATA_BITS-1:0] g_rwdl_io;
    input                 reset_n;
   
    
   
    //internal signals
    
    
    
    wire  [ROW_BITS-1:0]  row_addr_in = g_radd_i;
    wire  [COL_BITS-1:0]  col_addr_in = g_cadd_i;
    
    
    reg  bank_in   ;
    reg  read_in   ;
    reg  write_in  ; 
   
  
    reg		dout_enable;
    reg		[DATA_BITS-1:0]    data_out_buff, data_out;
	wire	[DATA_BITS-1:0]    data_in = g_rwdl_io;
	assign  g_rwdl_io =(dout_enable) ? data_out : {DATA_BITS{1'bz}} ;
    
    reg    g_rdrdy_n_o ;  
  
  
    reg     [DATA_BITS-1:0] memory  [0:1<<ROW_BITS+COL_BITS];
  
  
  
   
  
// pragma protect
// pragma protect begin
	
int errors=0, warnings=0; 

	
`define INFO_CUBE_HC03_BK0(A) \
  do begin \
    `ifdef WEC_DIS_INFO_CUBE_HC03_BK0 \
      ; \
    `else \
      `ifdef DSPH $display("%m: time %0t:INFO_CUBE_HC03_BK0:   %s", $realtime, $sformatf A, ); `else $display("time %0t:INFO_CUBE_HC03_BK0:   %s", $realtime, $sformatf A, ); `endif \
    `endif \
  end while(0)

`define ERROR_CUBE_HC03_BK0(A) \
  do begin \
    `ifdef WEC_DIS_ERROR_CUBE_HC03_BK0 \
      errors = errors + 1; \
    `else \
      `ifdef DSPH $display("%m: time %0t:ERROR_CUBE_HC03_BK0:   %s", $realtime, $sformatf A, ); `else $display("time %0t:ERROR_CUBE_HC03_BK0:   %s", $realtime, $sformatf A, ); `endif \
      errors = errors + 1; \
      if (STOP_ON_ERROR) STOP(); \
    `endif \
  end while(0)

`define WARN_CUBE_HC03_BK0(A) \
  do begin \
    `ifdef WEC_DIS_WARN_CUBE_HC03_BK0 \
      warnings = warnings + 1; \
    `else \
      `ifdef DSPH $display("%m: time %0t:WARN_CUBE_HC03_BK0:   %s", $realtime, $sformatf A, ); `else $display("time %0t:WARN_CUBE_HC03_BK0:   %s", $realtime, $sformatf A, ); `endif \
      warnings = warnings + 1; \
    `endif \
  end while(0)
      
`define DEBUG_CUBE_HC03_BK0(A) \
  do begin \
    `ifdef WEC_DIS_DEBUG_CUBE_HC03_BK0 \
    `else \
      `ifdef DSPH $display("%m: time %0t:CUBE_HC03_BK0:   %s", $realtime, $sformatf A, ); `else $display("time %0t:CUBE_HC03_BK0:   %s", $realtime, $sformatf A, ); `endif \
    `endif \
  end while(0)
          
`define INFO_CUBE_HC03_BK0_DISP1 \
       $display("time %0t:INFO_CUBE_HC03_BK0:   ------------------------------------------------------------------------------------", $realtime); \
   
           
`define INFO_CUBE_HC03_BK0_DISP2 \
       $display("time %0t:INFO_CUBE_HC03_BK0:   ####################################################################################", $realtime); \
       
`define INFO_CUBE_HC03_BK0_DISP3 \
       $display("time %0t:INFO_CUBE_HC03_BK0:   ************************************************************************************", $realtime); \
       
function automatic void STOP();
  $display("time %0t:INFO_CUBE_HC03_BK0:   Warnings=%0d, Errors=%0d\n", $realtime, warnings, errors);
  $stop(0);
endfunction : STOP


    
// cmd encoding
reg [3*8:0] cmd_string;
    
reg [ROW_BITS-1:0]  row_addr;
reg [COL_BITS-1:0]  col_addr; 
reg [DATA_BITS-1:0] write_data; 


reg  bank_active;





//timing
realtime    tm_active, tm_write, tm_read, tm_precharge;
realtime    tm_pos_wr, tm_neg_wr, tm_pos_rd, tm_neg_rd;
realtime    tm_reset_n_high;
 


 
initial 
begin
    $timeformat (-9, 3, "ns",3);

    `INFO_CUBE_HC03_BK0_DISP3;        
    `INFO_CUBE_HC03_BK0(("#            CUBE_HC03  BANK%2d model                          ",BK0)); 
    `INFO_CUBE_HC03_BK0(("#            ROW : %2d bits, COL : %2d bits, DATA : %3d bits ",ROW_BITS, COL_BITS, DATA_BITS)); 
    `INFO_CUBE_HC03_BK0_DISP3;

     bank_active=0;
     dout_enable=0;
     

     g_rdrdy_n_o=1;
     
   
     
end


//read/write/active delay;

always @(g_cas_wr_i)
begin
    write_in <= #tcask_dly g_cas_wr_i;
end


always @(g_cas_rd_i)
begin
    read_in <= #tcask_dly g_cas_rd_i;
end


always @(bnksel_n_i)
begin
    bank_in <= #trask_dly bnksel_n_i;
end













//reset_n


//active timing mark and check
always @(negedge bnksel_n_i)
begin
      cmd_string = "ACT";
      
      `INFO_CUBE_HC03_BK0(("==> ACT BANK"));
      
         
        bank_active =1;
        
        if($realtime-tm_precharge < tRP && $realtime > 0)
          `ERROR_CUBE_HC03_BK0(("tRP violation, duration: %t, spec: %f ns", $realtime-tm_precharge , tRP));


        if($realtime- tm_active < tRC  && $realtime >0)
          `ERROR_CUBE_HC03_BK0(("tRC violation, duration: %t, spec: %f ns", $realtime-tm_active , tRC));

  

        tm_active = $realtime;  
       
       

end


always @(posedge bnksel_n_i)
begin
       cmd_string = "PRG";
        
       
        
       if(bank_active)
       begin        
        // bank_active =0;
         `INFO_CUBE_HC03_BK0(("==> Precharge BANK"));
       end
       else
        `INFO_CUBE_HC03_BK0(("Precharge BANK, but the bank is not activated"));
       
       tm_precharge = $realtime;
        
   
       if(tm_precharge - tm_active < tRAS && $realtime > 0)
      `ERROR_CUBE_HC03_BK0(("tRAS violation, duration: %t, spec: %f ns", tm_precharge - tm_active, tRAS));
      
       if(tm_precharge - tm_pos_rd < tRTP*(1-0.01) && $realtime > 0)
        `ERROR_CUBE_HC03_BK0(("tRTP violation, duration: %t, spec: %f ns",tm_precharge - tm_pos_rd, tRTP));
        
       if(tm_precharge - tm_neg_wr < tWTP*(1-0.01) && $realtime > 0 )
        `ERROR_CUBE_HC03_BK0(("tWTP violation, duration: %t, spec: %f ns",tm_precharge - tm_neg_wr, tWTP));


end

//latch row address
always @(negedge bank_in)
begin
        row_addr   = row_addr_in;
        
        `INFO_CUBE_HC03_BK0(("==> row addr: 'h%h", row_addr));
end

always @(posedge bank_in)
begin
     //delay bank precharge due to read/write signal delay
      if(bank_active)
        bank_active <= # 0.1 0;
end


//write

always @(posedge g_cas_wr_i)
begin
        cmd_string = "WR";
       
        
       `INFO_CUBE_HC03_BK0(("==> WRITE"));
        
        if(bank_active ==0)
          `ERROR_CUBE_HC03_BK0(("Bank is not activative, Write cmd can't be accepted"));
     
     
        
        tm_write  = $realtime;
        tm_pos_wr = $realtime;
        
        if(tm_pos_wr - tm_neg_wr < tWCL_min && $realtime > 0 )
        `ERROR_CUBE_HC03_BK0(("tWCL min violation, duration: %t, spec: %f ns", tm_pos_wr - tm_neg_wr, tWCL_min));
      
        if(tm_pos_wr - tm_active < tRCD && $realtime > 0 )
        `ERROR_CUBE_HC03_BK0(("tRCD violation for WR, duration: %t, spec: %f ns",tm_pos_wr - tm_active, tRCD));
end



always @(posedge write_in)
begin
        
       if(bank_active!=0)
       begin
         col_addr   = col_addr_in; 
        
         mem_write({ row_addr, col_addr}, data_in);
         
         `INFO_CUBE_HC03_BK0(("WRITE , row addr : 'h%h, col addr : 'h%h, DATA: 'h%h", row_addr, col_addr,data_in ));
       
       end
  
end

always @(negedge g_cas_wr_i)
begin
      
        tm_neg_wr = $realtime ;
        
     
        if(tm_neg_wr - tm_pos_wr < tWCH_min &&  $realtime > 0 )
        `ERROR_CUBE_HC03_BK0(("tWCH min violation, duration: %t, spec: %f ns", tm_neg_wr - tm_pos_wr , tWCH_min));
        
        if(tm_neg_wr - tm_pos_wr > tWCH_max &&  $realtime > 0)
         `ERROR_CUBE_HC03_BK0(("tWCH max violation, duration: %t, spec: %f ns", tm_neg_wr - tm_pos_wr , tWCH_max));

end


//read


always @(posedge g_cas_rd_i)
begin
        cmd_string = "RD";
       
        
       `INFO_CUBE_HC03_BK0(("==> READ"));
        
        if(bank_active ==0)
          `ERROR_CUBE_HC03_BK0(("Bank is not activative, READ cmd can't be accepted"));
          
        tm_read    = $realtime;
        tm_pos_rd  = $realtime;
        
        
        if(tm_pos_rd - tm_neg_wr  <  tWTR &&  $realtime > 0)
         `ERROR_CUBE_HC03_BK0(("tWTR violation, duration: %t, spec: %f ns",tm_pos_rd - tm_neg_wr  , tWTR));
         
        if(tm_pos_rd - tm_active  <  tRCD &&  $realtime > 0)
         `ERROR_CUBE_HC03_BK0(("tRCD violation for RD, duration: %t, spec: %f ns",tm_pos_rd - tm_active  , tRCD));
         
     
          
end



always @(posedge read_in)
begin
        if(bank_active !=0)
        begin
           col_addr   = col_addr_in; 
        
           mem_read({ row_addr, col_addr}, data_out_buff);
           
          `INFO_CUBE_HC03_BK0(("READ  , row addr : 'h%h, col addr : 'h%h, DATA: 'h%h", row_addr, col_addr,data_out_buff));
        
        end
        
           
        dout_enable<= #tAA  1;
        data_out   <= #tAA  data_out_buff;
     
        dout_enable<= #(tAA +tCCD)  0;
         
        g_rdrdy_n_o <=  #tAA 0;
        g_rdrdy_n_o <=  #(tAA+tprdrdy_min) 1;  
        
     
end

always @(negedge g_cas_rd_i)
begin
      
        tm_neg_rd = $realtime ;
        
       
        if(tm_neg_rd - tm_pos_rd < tRCH_min &&  $realtime > 0)
        `ERROR_CUBE_HC03_BK0(("tRCH_min violation, duration: %t, spec: %f ns", tm_neg_rd - tm_pos_rd , tRCH_min));
        
        if(tm_neg_rd - tm_pos_rd >  tRCH_max &&  $realtime > 0)
        `ERROR_CUBE_HC03_BK0(("tRCH_max violation, duration: %t, spec: %f ns", tm_neg_rd - tm_pos_rd , tRCH_max));

end


// Write to Memory
task mem_write;
	input [MEM_BITS-1:0]   addr_in;
	input [DATA_BITS-1:0]  write_dq_in;
	begin
    
    memory[addr_in] = write_dq_in; 
    
    
	//`INFO_CUBE_HC03_BK0(("write : addr:%h, data:%h, write data:%h", addr_in, write_dq_in,memory[addr_in] ));
        
    end
endtask

// Read from Memory
task mem_read;
  	input [MEM_BITS-1:0]   addr_in;
	output [DATA_BITS-1:0]  read_data_out;
	
	begin
	read_data_out =  memory[addr_in];
 	end
endtask





// pragma protect end

endmodule



