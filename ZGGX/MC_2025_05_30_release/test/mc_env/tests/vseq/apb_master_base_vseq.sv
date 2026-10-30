`ifndef APB_MASTER_BASE_SEQUENCE_SV
`define APB_MASTER_BASE_SEQUENCE_SV
/////////////////////////
//apb_master_wr_vseq
//apb_master_rd_vseq 
/////////////////////////
class apb_master_wr_vseq extends svt_apb_master_base_sequence;

    rand bit [31:0] address;
    rand bit [31:0] data;
    rand bit [3:0]  pstrb;
  /** Parameter that controls the number of transactions that will be generated */
  rand int unsigned sequence_length = 1;

  /** Constrain the sequence length to a reasonable value */
  constraint reasonable_sequence_length {
    sequence_length <= 100;
  }

  /** UVM Object Utility macro */
  `uvm_object_utils(apb_master_wr_vseq)

  /** Class Constructor */
  function new(string name="apb_master_wr_vseq");
    super.new(name);
  endfunction

  virtual task body();
    svt_apb_master_transaction write_tran, read_tran;
    bit status;
    `uvm_info("body", "Entered ...", UVM_MEDIUM)

    super.body();

        `uvm_info("body", "uvm_create1 ...", UVM_MEDIUM)

      /** Set up the write transaction */
      `uvm_create(write_tran)
      write_tran.cfg       = cfg;
      write_tran.xact_type = svt_apb_transaction::WRITE;
      write_tran.address   = address;
      write_tran.data      = data; 
      write_tran.pstrb     = pstrb; 
      write_tran.num_wait_cycles = 3;
        `uvm_info("body", "uvm_create2 ...", UVM_MEDIUM)

      /** Send the write transaction */
      `uvm_send(write_tran)
      
        `uvm_info("body", "write_tran ...", UVM_MEDIUM)

      /** Wait for the write transaction to complete */
      get_response(rsp);

      `uvm_info("body", "APB WRITE transaction completed", UVM_MEDIUM);

    `uvm_info("body", "Exiting...", UVM_MEDIUM)
  endtask: body

endclass: apb_master_wr_vseq


class apb_master_rd_vseq extends svt_apb_master_base_sequence;

    rand bit [31:0] address;
    rand bit [31:0] data;
    rand bit [3:0]  pstrb;
  /** Parameter that controls the number of transactions that will be generated */
  rand int unsigned sequence_length = 1;

  /** Constrain the sequence length to a reasonable value */
  constraint reasonable_sequence_length {
    sequence_length <= 100;
  }

  /** UVM Object Utility macro */
  `uvm_object_utils(apb_master_rd_vseq)

  /** Class Constructor */
  function new(string name="apb_master_rd_vseq");
    super.new(name);
  endfunction

  virtual task body();
    svt_apb_master_transaction read_tran;
    bit status;
    `uvm_info("body", "Entered ...", UVM_MEDIUM)

    super.body();

      /** Set up the read transaction */
      `uvm_create(read_tran)
      read_tran.cfg       = cfg;
      read_tran.xact_type = svt_apb_transaction::READ;
      read_tran.address   = address; //32'h0000_0100 | ('h100 * i);
      read_tran.pstrb     = pstrb; 

      /** Send the read transaction */
      `uvm_send(read_tran)

      /** Wait for the read transaction to complete */
      get_response(rsp);
      data = read_tran.data;
      `uvm_info("body", "APB READ transaction completed", UVM_MEDIUM);

    `uvm_info("body", "Exiting...", UVM_MEDIUM)
  endtask: body

endclass: apb_master_rd_vseq

`endif // APB_MASTER_SEQUENCE_SV
