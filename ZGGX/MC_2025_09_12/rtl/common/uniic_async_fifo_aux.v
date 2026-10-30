module uniic_async_fifo_aux #(
    parameter  DATA_WIDTH = 272,
    parameter  DEPTH = 6
) (
    // Write domain
    input  wire                       wclk,
    input  wire                       w_rst_n,   // async active-low reset for write domain
    input  wire                       w_en,      // write request (1 cycle pulse or level)
    input  wire [DATA_WIDTH-1:0]      w_data,
    output wire                       w_full,

    // Read domain
    input  wire                       rclk,
    input  wire                       r_rst_n,   // async active-low reset for read domain
    input  wire                       r_en,      // read request (1 cycle pulse or level)
    output wire [DATA_WIDTH-1:0]      r_data,
    output wire                       r_empty
);
    // ---------------------------------------------------------------------------
    // Parameter-derived widths
    // ADDR_WIDTH indexes memory [0..DEPTH-1]
    // PTR_WIDTH is ADDR_WIDTH+1 to safely compute occupancy in power-of-two space
    // ---------------------------------------------------------------------------
    localparam integer ADDR_WIDTH = (DEPTH <= 2) ? 1 : $clog2(DEPTH);
    localparam integer PTR_WIDTH  = ADDR_WIDTH + 1;

    // ---------------------------------------------------------------------------
    // Simulation-time parameter checks (safe in sim; ignored in synthesis with guard)
    // ---------------------------------------------------------------------------
    // synthesis translate_off
    initial begin
        if (DEPTH < 2) begin
            $fatal(1, "async_fifo: DEPTH (%0d) must be >= 2", DEPTH);
        end
        if ((1 << PTR_WIDTH) < (2*DEPTH)) begin
            $fatal(1, "async_fifo: PTR_WIDTH too small: 2^PTR_WIDTH (%0d) < 2*DEPTH (%0d)", (1<<PTR_WIDTH), 2*DEPTH);
        end
        if (DATA_WIDTH <= 0) begin
            $fatal(1, "async_fifo: DATA_WIDTH must be > 0");
        end
    end
    // synthesis translate_on

    // ---------------------------------------------------------------------------
    // Memory array (single-ported per clock domain semantics: write on wclk, read on rclk)
    // ---------------------------------------------------------------------------
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // ---------------------------------------------------------------------------
    // Write domain state
    // - waddr: memory address modulo DEPTH
    // - wptr_bin: virtual binary pointer (power-of-two space, width PTR_WIDTH)
    // - wptr_gray: Gray-coded pointer derived from wptr_bin
    // ---------------------------------------------------------------------------
    reg [ADDR_WIDTH-1:0] waddr;
    reg [PTR_WIDTH-1:0]  wptr_bin;
    reg [PTR_WIDTH-1:0]  wptr_gray;

    // ---------------------------------------------------------------------------
    // Read domain state
    // ---------------------------------------------------------------------------
    reg [ADDR_WIDTH-1:0] raddr;
    reg [PTR_WIDTH-1:0]  rptr_bin;
    reg [PTR_WIDTH-1:0]  rptr_gray;

    // ---------------------------------------------------------------------------
    // Cross-domain synchronizers for Gray pointers
    // ---------------------------------------------------------------------------
    wire [PTR_WIDTH-1:0] rptr_gray_wclk_sync2;
    wire [PTR_WIDTH-1:0] wptr_gray_rclk_sync2;

    // ---------------------------------------------------------------------------
    // Utility functions: binary <-> Gray conversion
    // ---------------------------------------------------------------------------
    function automatic [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    function automatic [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        reg [PTR_WIDTH-1:0] bin;
        begin
            bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                bin[i] = bin[i+1] ^ gray[i];
            end
            gray2bin = bin;
        end
    endfunction

    // ---------------------------------------------------------------------------
    // Compute synchronized opposite-domain binary pointers for occupancy math
    // ---------------------------------------------------------------------------
    wire [PTR_WIDTH-1:0] rptr_bin_wclk = gray2bin(rptr_gray_wclk_sync2);
    wire [PTR_WIDTH-1:0] wptr_bin_rclk = gray2bin(wptr_gray_rclk_sync2);

    // ---------------------------------------------------------------------------
    // Occupancy in each domain: handle pointer wraparound correctly
    // ---------------------------------------------------------------------------
    wire [PTR_WIDTH-1:0] used_wclk;
    // Handle pointer wraparound: if wptr < rptr, it means wraparound occurred
    assign used_wclk = (wptr_bin >= rptr_bin_wclk) ? 
                       (wptr_bin - rptr_bin_wclk) : 
                       ((1 << PTR_WIDTH) - rptr_bin_wclk + wptr_bin);
    // w_full indicates FIFO has DEPTH or more data (for monitoring, not write protection)
    assign w_full  = (used_wclk >= DEPTH);

    // Robust empty detection in read domain: Gray equality
    assign r_empty = (rptr_gray == wptr_gray_rclk_sync2);

    // ---------------------------------------------------------------------------
    // Write-side logic (no write protection)
    // ---------------------------------------------------------------------------
    wire do_write = w_en; // Always allow write when w_en is high
    integer II;//hyl

    always @(posedge wclk or negedge w_rst_n) begin
        if (!w_rst_n) begin
            waddr     <= {ADDR_WIDTH{1'b0}};
            wptr_bin  <= {PTR_WIDTH{1'b0}};
            wptr_gray <= {PTR_WIDTH{1'b0}};
            for(II=0;II<DEPTH;II=II+1)begin   ////hyl
                mem[II] <= {DATA_WIDTH{1'b0}}; ////hyl
            end                                ////hyl
        end else begin
            if (do_write) begin
                // write data to memory at current address
                mem[waddr] <= w_data;
                // update memory address modulo DEPTH (not necessarily power-of-two)
                if (waddr == DEPTH-1) begin
                    waddr <= {ADDR_WIDTH{1'b0}};
                end else begin
                    waddr <= waddr + {{(ADDR_WIDTH-1){1'b0}}, 1'b1};
                end
                // advance virtual pointer in power-of-two space
                wptr_bin  <= wptr_bin + {{(PTR_WIDTH-1){1'b0}}, 1'b1};
                wptr_gray <= bin2gray(wptr_bin + {{(PTR_WIDTH-1){1'b0}}, 1'b1});
            end
        end
    end

    // Synchronize read Gray pointer into write clock domain
    DW_sync 
        #(
         .width         (PTR_WIDTH              ),
         .f_sync_type   (2                      ),
         .tst_mode      (0                      ),
         .verif_en      (1                      )
         )
    DW_sync_u1
        ( 
        .clk_d          (wclk                   ),
        .rst_d_n        (w_rst_n                ),
        .init_d_n       (1'b1                   ),
        .data_s         (rptr_gray              ),
        .test           (1'b0                   ),
        .data_d         (rptr_gray_wclk_sync2   )
        );

    // ---------------------------------------------------------------------------
    // Read-side logic (simple and clean)
    // ---------------------------------------------------------------------------
    wire do_read = r_en & ~r_empty;

    assign  r_data = mem[raddr];

    always @(posedge rclk or negedge r_rst_n) begin
        if (!r_rst_n) begin
            raddr     <= {ADDR_WIDTH{1'b0}};
            rptr_bin  <= {PTR_WIDTH{1'b0}};
            rptr_gray <= {PTR_WIDTH{1'b0}};
        end else begin
            // Only advance pointers when reading
            if (do_read) begin
                // update memory address modulo DEPTH
                if (raddr == DEPTH-1) begin
                    raddr <= {ADDR_WIDTH{1'b0}};
                end else begin
                    raddr <= raddr + {{(ADDR_WIDTH-1){1'b0}}, 1'b1};
                end
                // advance virtual pointer in power-of-two space
                rptr_bin  <= rptr_bin + {{(PTR_WIDTH-1){1'b0}}, 1'b1};
                rptr_gray <= bin2gray(rptr_bin + {{(PTR_WIDTH-1){1'b0}}, 1'b1});
            end
        end
    end

    // Synchronize write Gray pointer into read clock domain
    DW_sync 
        #(
         .width         (PTR_WIDTH              ),
         .f_sync_type   (2                      ),
         .tst_mode      (0                      ),
         .verif_en      (1                      )
         )
    DW_sync_u2
        ( 
        .clk_d          (rclk                   ),
        .rst_d_n        (r_rst_n                ),
        .init_d_n       (1'b1                   ),
        .data_s         (wptr_gray              ),
        .test           (1'b0                   ),
        .data_d         (wptr_gray_rclk_sync2   )
        );

endmodule 
