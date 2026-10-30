`ifndef APB_MASTER_SEQUENCE_LIB_SV
`define APB_MASTER_SEQUENCE_LIB_SV 


class apb_master_wr_sequence extends svt_apb_master_base_sequence;

    bit [`APB_ADDR_WIDTH-1:0] address;
    bit [`APB_DATA_WIDTH-1:0] data;
    bit [`APB_STRB_WIDTH-1:0] pstrb;

    rand int unsigned sequence_length=1;

    constraint reasonable_sequence_length{
        sequence_length <= 100;
    }

    `uvm_object_utils(apb_master_wr_sequence);

    function new(string name="apb_master_wr_sequence");
        super.new(name);
    endfunction

    virtual task body();
        svt_apb_master_transaction write_tran;
        bit status;
        `uvm_info("body","Entered...",UVM_LOW);

        super.body();

        `uvm_create(write_tran);
        write_tran.cfg = cfg;
        write_tran.xact_type = svt_apb_transaction::WRITE;
        write_tran.address = address;
        write_tran.data = data;
        write_tran.pstrb = pstrb;
        write_tran.num_wait_cycles = 3;

        `uvm_send(write_tran);

        get_response(rsp);

        `uvm_info("body","APB Write trans completed",UVM_LOW);

    endtask : body 

endclass : apb_master_wr_sequence

class apb_master_rd_sequence extends svt_apb_master_base_sequence;

    bit [`APB_ADDR_WIDTH-1:0] address;
    bit [`APB_DATA_WIDTH-1:0] data;
    bit [`APB_STRB_WIDTH-1:0] pstrb;

    rand int unsigned sequence_length=1;

    constraint reasonable_sequence_length{
        sequence_length <= 100;
    }

    `uvm_object_utils(apb_master_rd_sequence);

    function new(string name="apb_master_rd_sequence");
        super.new(name);
    endfunction

    virtual task body();
        svt_apb_master_transaction read_tran;
        bit status;
        `uvm_info("body","Entered...",UVM_LOW);

        super.body();

        `uvm_create(read_tran);
        read_tran.cfg = cfg;
        read_tran.xact_type = svt_apb_transaction::READ;
        read_tran.address = address;
        read_tran.pstrb = pstrb;

        `uvm_send(read_tran);

        get_response(rsp);
        data = read_tran.data;

        `uvm_info("body","APB Read trans completed",UVM_LOW);

    endtask : body 

endclass : apb_master_rd_sequence

`endif
