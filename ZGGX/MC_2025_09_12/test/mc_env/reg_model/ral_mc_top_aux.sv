`ifndef RAL_mc_top_aux
`define RAL_mc_top_aux

`define UVM_REG_ADDR_WIDTH 32
`include "ral_mc_1short2_top_aux.sv"

class ral_sys_mc_top_aux extends uvm_reg_block;

        rand ral_block_mc_1short2_top_aux_top MC_TOP_AUX_ins;

    function new(string name = "mc_top_aux");
        super.new(name);
    endfunction: new

    function void build();
        this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);

            this.MC_TOP_AUX_ins = ral_block_mc_1short2_top_aux_top::type_id::create("MC_TOP_AUX_ins",,get_full_name());
            this.MC_TOP_AUX_ins.configure(this, "");
            this.MC_TOP_AUX_ins.build();
            this.default_map.add_submap(this.MC_TOP_AUX_ins.default_map, `UVM_REG_ADDR_WIDTH'h0);
            this.MC_TOP_AUX_ins.add_hdl_path("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2");

    endfunction : build

    `uvm_object_utils(ral_sys_mc_top_aux)
endclass : ral_sys_mc_top_aux

`endif
