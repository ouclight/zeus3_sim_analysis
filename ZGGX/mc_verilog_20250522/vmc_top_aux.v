module vmc_top_aux #(
    parameter   ARRAY_ROW_ADDR_WIDTH  = 13,
    parameter   ARRAY_COL_ADDR_WIDTH  = 8,
    parameter   CHECKBIT_WIDTH        = 10,
    parameter   ARRAY_DATA_WIDTH      = 256,
    parameter   WL_NUM                = 7360,
    parameter   FRAME_WIDTH           = ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH+3+1
)(
    input                                            vmc_wl_en           ,
    input       [ARRAY_ROW_ADDR_WIDTH*64-1:0]        remap_wl_addr       ,//32
    input                                            vmc_bl_en           ,
    input       [ARRAY_COL_ADDR_WIDTH*20-1:0]        remap_csl_addr      ,//{part9,part8,part7,...,part3,part2,part1,part0},part0,lsb
    
    input                                            frame_vld           ,
    output                                           frame_rdy           ,
    input       [FRAME_WIDTH-1:0]                    frame_data          ,

    output                                           frame_vmc_vld        ,
    input                                            frame_vmc_rdy        ,
    output      [FRAME_WIDTH-1:0]                    frame_vmc_data       
);   

wire [ARRAY_ROW_ADDR_WIDTH-1:0]                      frame_row            ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                      frame_col            ;
wire                                                 frame_sof            ;
wire                                                 frame_eof            ;
wire                                                 frame_rw             ;
wire                                                 frame_wstrb          ;
wire [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]           frame_wdata          ;
reg  [ARRAY_COL_ADDR_WIDTH*2-1:0]                    remap_bl_addr_tmp    ;
wire [ARRAY_ROW_ADDR_WIDTH-1:0]                      frame_vmc_row        ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                      frame_vmc_col        ;
wire [ARRAY_ROW_ADDR_WIDTH-1:0]                      vmc_wl               ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                      vmc_bl               ;


wire [12:0]                                          csl_scan_row_part0_end_addr    ;
wire [12:0]                                          csl_scan_row_part1_start_addr  ;
wire [12:0]                                          csl_scan_row_part1_end_addr    ;
wire [12:0]                                          csl_scan_row_part2_start_addr  ;
wire [12:0]                                          csl_scan_row_part2_end_addr    ;
wire [12:0]                                          csl_scan_row_part3_start_addr  ;
wire [12:0]                                          csl_scan_row_part3_end_addr    ;
wire [12:0]                                          csl_scan_row_part4_start_addr  ;
wire [12:0]                                          csl_scan_row_part4_end_addr    ;
wire [12:0]                                          csl_scan_row_part5_start_addr  ;
wire [12:0]                                          csl_scan_row_part5_end_addr    ;
wire [12:0]                                          csl_scan_row_part6_start_addr  ;
wire [12:0]                                          csl_scan_row_part6_end_addr    ;
wire [12:0]                                          csl_scan_row_part7_start_addr  ;
wire [12:0]                                          csl_scan_row_part7_end_addr    ;
wire [12:0]                                          csl_scan_row_part8_start_addr  ;
wire [12:0]                                          csl_scan_row_part8_end_addr    ;

//wire [12:0]                                          csl_scan_row_part4_start_addr  ;
//wire [12:0]                                          csl_scan_row_part4_end_addr    ;

assign frame_col    = frame_data[ARRAY_COL_ADDR_WIDTH-1:0];
assign frame_row    = frame_data[ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH-1:ARRAY_COL_ADDR_WIDTH];
assign frame_wdata  = frame_data[FRAME_WIDTH-5 -: (ARRAY_DATA_WIDTH+CHECKBIT_WIDTH)];
assign frame_sof    = frame_data[FRAME_WIDTH-3];
assign frame_eof    = frame_data[FRAME_WIDTH-4];
assign frame_rw     = frame_data[FRAME_WIDTH-2];
assign frame_wstrb  = frame_data[FRAME_WIDTH-1];


wl_vmc_top_aux #(
    .AR_DST_ID_WIDTH(ARRAY_ROW_ADDR_WIDTH)                   
)wl_vmc_U0 (

            .i_org_id      (frame_row          ) ,
            .o_remap_id    (vmc_wl             ) ,
            .s_vmc_en      (vmc_wl_en          ) ,
            .remap_addr    (remap_wl_addr      ) ,
            .o_vmc_mon_all (                   )
);

assign csl_scan_row_part0_end_addr   = WL_NUM/10-13'h1 ;//13'h2df
assign csl_scan_row_part1_start_addr = csl_scan_row_part0_end_addr   + 13'h1    ;
assign csl_scan_row_part1_end_addr   = csl_scan_row_part1_start_addr + 13'h2df ;
assign csl_scan_row_part2_start_addr = csl_scan_row_part1_end_addr   + 13'h1    ;
assign csl_scan_row_part2_end_addr   = csl_scan_row_part2_start_addr + 13'h2df  ;
assign csl_scan_row_part3_start_addr = csl_scan_row_part2_end_addr   + 13'h1    ;
assign csl_scan_row_part3_end_addr   = csl_scan_row_part3_start_addr + 13'h2df  ;
assign csl_scan_row_part4_start_addr = csl_scan_row_part3_end_addr   + 13'h1    ;
assign csl_scan_row_part4_end_addr   = csl_scan_row_part4_start_addr + 13'h2df  ;
assign csl_scan_row_part5_start_addr = csl_scan_row_part4_end_addr   + 13'h1    ;
assign csl_scan_row_part5_end_addr   = csl_scan_row_part5_start_addr + 13'h2df  ;
assign csl_scan_row_part6_start_addr = csl_scan_row_part5_end_addr   + 13'h1    ;
assign csl_scan_row_part6_end_addr   = csl_scan_row_part6_start_addr + 13'h2df  ;
assign csl_scan_row_part7_start_addr = csl_scan_row_part6_end_addr   + 13'h1    ;
assign csl_scan_row_part7_end_addr   = csl_scan_row_part7_start_addr + 13'h2df  ;
assign csl_scan_row_part8_start_addr = csl_scan_row_part7_end_addr   + 13'h1    ;
assign csl_scan_row_part8_end_addr   = csl_scan_row_part8_start_addr + 13'h2df  ;



/////////////assign csl_scan_row_part0_end_addr   = 13'd29 ;
/////////////assign csl_scan_row_part1_start_addr = csl_scan_row_part0_end_addr   + 13'h1    ;//test
/////////////assign csl_scan_row_part1_end_addr   = csl_scan_row_part1_start_addr + 13'd29  ;//test
/////////////assign csl_scan_row_part2_start_addr = csl_scan_row_part1_end_addr   + 13'h1    ;//test
/////////////assign csl_scan_row_part2_end_addr   = csl_scan_row_part2_start_addr + 13'd29  ;//test
/////////////assign csl_scan_row_part3_start_addr = csl_scan_row_part2_end_addr   + 13'h1    ;//test
/////////////assign csl_scan_row_part3_end_addr   = csl_scan_row_part3_start_addr + 13'd29  ;//test
/////////////assign csl_scan_row_part4_start_addr = csl_scan_row_part3_end_addr   + 13'h1    ;//test
/////////////assign csl_scan_row_part4_end_addr   = csl_scan_row_part4_start_addr + 13'd29  ;//test
/////////////assign csl_scan_row_part5_start_addr = csl_scan_row_part4_end_addr   + 13'h1    ;//test
/////////////assign csl_scan_row_part5_end_addr   = csl_scan_row_part5_start_addr + 13'd29  ;//test
/////////////assign csl_scan_row_part6_start_addr = csl_scan_row_part5_end_addr   + 13'h1    ;//test
/////////////assign csl_scan_row_part6_end_addr   = csl_scan_row_part6_start_addr + 13'd29  ;//test
/////////////assign csl_scan_row_part7_start_addr = csl_scan_row_part6_end_addr   + 13'h1    ;//test
/////////////assign csl_scan_row_part7_end_addr   = csl_scan_row_part7_start_addr + 13'd29  ;//test
/////////////assign csl_scan_row_part8_start_addr = csl_scan_row_part7_end_addr   + 13'h1    ;//test
/////////////assign csl_scan_row_part8_end_addr   = csl_scan_row_part8_start_addr + 13'd29  ;//test


always @(*)begin
    if(vmc_wl<=csl_scan_row_part0_end_addr)
        remap_bl_addr_tmp = remap_csl_addr[ARRAY_COL_ADDR_WIDTH*2-1:0] ;
    else if(vmc_wl<=csl_scan_row_part1_end_addr)
        remap_bl_addr_tmp = remap_csl_addr[ARRAY_COL_ADDR_WIDTH*4-1:ARRAY_COL_ADDR_WIDTH*2] ;
    else if(vmc_wl<=csl_scan_row_part2_end_addr)
        remap_bl_addr_tmp = remap_csl_addr[ARRAY_COL_ADDR_WIDTH*6-1:ARRAY_COL_ADDR_WIDTH*4] ;
    else if(vmc_wl<=csl_scan_row_part3_end_addr)
        remap_bl_addr_tmp = remap_csl_addr[ARRAY_COL_ADDR_WIDTH*8-1:ARRAY_COL_ADDR_WIDTH*6] ;
    else if(vmc_wl<=csl_scan_row_part4_end_addr)
        remap_bl_addr_tmp = remap_csl_addr[ARRAY_COL_ADDR_WIDTH*10-1:ARRAY_COL_ADDR_WIDTH*8] ;
    else if(vmc_wl<=csl_scan_row_part5_end_addr)
        remap_bl_addr_tmp = remap_csl_addr[ARRAY_COL_ADDR_WIDTH*12-1:ARRAY_COL_ADDR_WIDTH*10] ;
    else if(vmc_wl<=csl_scan_row_part6_end_addr)
        remap_bl_addr_tmp = remap_csl_addr[ARRAY_COL_ADDR_WIDTH*14-1:ARRAY_COL_ADDR_WIDTH*12] ;
    else if(vmc_wl<=csl_scan_row_part7_end_addr)
        remap_bl_addr_tmp = remap_csl_addr[ARRAY_COL_ADDR_WIDTH*16-1:ARRAY_COL_ADDR_WIDTH*14] ;
    else if(vmc_wl<=csl_scan_row_part8_end_addr)
        remap_bl_addr_tmp = remap_csl_addr[ARRAY_COL_ADDR_WIDTH*18-1:ARRAY_COL_ADDR_WIDTH*16] ;
    else 
        remap_bl_addr_tmp = remap_csl_addr[ARRAY_COL_ADDR_WIDTH*20-1:ARRAY_COL_ADDR_WIDTH*18];
    end

bl_vmc_top_aux #(
    .AR_DST_ID_WIDTH(ARRAY_COL_ADDR_WIDTH)                   
)bl_vmc_U0 (

            .i_org_id      (frame_col[6:0]     ) ,
            .o_remap_id    (vmc_bl             ) ,
            .s_vmc_en      (vmc_bl_en          ) ,
            .remap_addr    (remap_bl_addr_tmp  ) ,
            .o_vmc_mon_all (                   )
);

assign frame_vmc_row = vmc_wl_en ? vmc_wl : frame_row       ;
assign frame_vmc_col = vmc_bl_en ? vmc_bl : frame_col       ;

assign frame_vmc_vld = frame_vld ;
assign frame_rdy     = frame_vmc_rdy ;
assign frame_vmc_data = {frame_wstrb,frame_rw,frame_sof,frame_eof,frame_wdata,frame_vmc_row,frame_vmc_col};

endmodule


