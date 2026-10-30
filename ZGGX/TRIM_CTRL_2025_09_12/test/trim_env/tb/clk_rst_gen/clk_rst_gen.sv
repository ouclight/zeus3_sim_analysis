//=============================================================================
// copyright
//=============================================================================
// Project  :  
// File Name: 
// Author   : Name   : $name
//            Email  : $email
//            Dept   : $dept
// Version  : $version
//=============================================================================
// Description:clk and rst generator
//=============================================================================

`ifndef CLK_RST_GEN_SV
`define CLK_RST_GEN_SV

class clk_rst_base;
    string m_name;

    function string get_name();
        return m_name;
    endfunction

    function new(string clk_name);
        m_name = clk_name;
    endfunction

endclass

class clk_rst_gen extends clk_rst_base;
    real m_freq;
    real m_periods;
    real m_rst_time;
    virtual interface clk_rst_if m_vif;

    virtual function clk_config(real freq=20000.0,real rst_time=200.0, virtual interface clk_rst_if vif);
        m_freq     = freq;//KHz
        m_rst_time = rst_time;//ns
        m_vif      = vif;
    endfunction
   
    function new(string clk_name);
        super.new(clk_name);
    endfunction

    virtual task gen();
        m_periods = 1000000.0/(m_freq*1.0);
        //$display("Period is %0fns",m_periods);
        m_vif.clk   = 0;
        fork
            begin
                //$display("@%0tns,Rst_n release start!",$realtime/1000);
                m_vif.rst_n = 0;
                #(m_rst_time * 1.0ns) m_vif.rst_n = 1;
                //$display("@%0tns,Rst_n release done!",$realtime/1000);
            end
            while(1)begin
                #(m_periods*1.0/2*1.0ns) m_vif.clk  = ~m_vif.clk;
            end
        join
    endtask
endclass

`endif
