module tb;

reg     clk  ;
reg     rst_n;
reg     frm_start;

initial begin
    clk  = 0;
    frm_start  = 0;
    rst_n = 0;
    #15
    rst_n = 1;
end

always #10 clk = ~clk;

//==========================================================================
// DUT instance
//==========================================================================
parameter   DATA_WIDTH = 8;

wire                            i_vld ;
wire                            i_rdy ;
wire    [DATA_WIDTH*16-1:0]     i_data;
wire                            o_vld ;
wire                            o_rdy ;
wire    [(DATA_WIDTH+4)*16-1:0] o_data;

matrix_cal_top 
#(.DATA_WIDTH       (DATA_WIDTH       ))
u_matrix_cal_top (.clk         (clk   ),
                  .rst_n       (rst_n ),
                  .src_row_vld (i_vld ),
                  .src_row_rdy (i_rdy ),
                  .src_row_data(i_data),
                                                      
                  .tmp_col_vld (o_vld ),
                  .tmp_col_rdy (o_rdy ),
                  .tmp_col_data(o_data));

//==========================================================================
// vld BFM for data input
//==========================================================================
integer  min_vld     = 1 ;
integer  max_vld     = 10;
integer  min_non_vld = 0;
integer  max_non_vld = 0;

wire     data_output_done_vld_bfm;

BFM_VLD  #(.filename("../data/blk_8x8_orig_data.txt"),
           .d_width ( 16*DATA_WIDTH          ))
bfm_vld(.clk             (clk                     ),
        .rst_n           (rst_n                   ),
        .vld             (i_vld              ),
        .rdy             (i_rdy              ),
        .data_o          (i_data             ),
        .min_vld         (min_vld                 ),
        .max_vld         (max_vld                 ),
        .min_non_vld     (min_non_vld             ),
        .max_non_vld     (max_non_vld             ),
        .data_output_done(data_output_done_vld_bfm));
      

//==========================================================================
// rdy BFM for data output
//==========================================================================
integer  min_rdy     = 1 ;
integer  max_rdy     = 10;
integer  min_non_rdy = 3 ;
integer  max_non_rdy = 11;

BFM_RDY #(.module_name("bfm_rdy")) 
bfm_rdy(.clk        (clk        ),
        .rst_n      (rst_n      ),
        .vld        (o_vld ),
        .rdy        (o_rdy ),
        .min_rdy    (min_rdy    ),
        .max_rdy    (max_rdy    ),
        .min_non_rdy(min_non_rdy),
        .max_non_rdy(max_non_rdy));


////==========================================================================
//// CHECKER 
////==========================================================================
wire     data_check_done;

wire    [16*(DATA_WIDTH+4)-1:0]    p_data_check;
wire    [16*(DATA_WIDTH+4)-1:0]    q_data_check;

 assign    p_data_check ={{3{u_matrix_cal_top.p_data[(DATA_WIDTH+1)*16-1]}},u_matrix_cal_top.p_data[(DATA_WIDTH+1)*16-1:(DATA_WIDTH+1)*15],
                          {3{u_matrix_cal_top.p_data[(DATA_WIDTH+1)*15-1]}},u_matrix_cal_top.p_data[(DATA_WIDTH+1)*15-1:(DATA_WIDTH+1)*14],
                          {3{u_matrix_cal_top.p_data[(DATA_WIDTH+1)*14-1]}},u_matrix_cal_top.p_data[(DATA_WIDTH+1)*14-1:(DATA_WIDTH+1)*13],
                          {3{u_matrix_cal_top.p_data[(DATA_WIDTH+1)*13-1]}},u_matrix_cal_top.p_data[(DATA_WIDTH+1)*13-1:(DATA_WIDTH+1)*12],
                          {3{u_matrix_cal_top.p_data[(DATA_WIDTH+1)*12-1]}},u_matrix_cal_top.p_data[(DATA_WIDTH+1)*12-1:(DATA_WIDTH+1)*11],
                          {3{u_matrix_cal_top.p_data[(DATA_WIDTH+1)*11-1]}},u_matrix_cal_top.p_data[(DATA_WIDTH+1)*11-1:(DATA_WIDTH+1)*10],
                          {3{u_matrix_cal_top.p_data[(DATA_WIDTH+1)*10-1]}},u_matrix_cal_top.p_data[(DATA_WIDTH+1)*10-1:(DATA_WIDTH+1)* 9],
                          {3{u_matrix_cal_top.p_data[(DATA_WIDTH+1)* 9-1]}},u_matrix_cal_top.p_data[(DATA_WIDTH+1)* 9-1:(DATA_WIDTH+1)* 8],
                          {3{u_matrix_cal_top.p_data[(DATA_WIDTH+1)* 8-1]}},u_matrix_cal_top.p_data[(DATA_WIDTH+1)* 8-1:(DATA_WIDTH+1)* 7],
                          {3{u_matrix_cal_top.p_data[(DATA_WIDTH+1)* 7-1]}},u_matrix_cal_top.p_data[(DATA_WIDTH+1)* 7-1:(DATA_WIDTH+1)* 6],
                          {3{u_matrix_cal_top.p_data[(DATA_WIDTH+1)* 6-1]}},u_matrix_cal_top.p_data[(DATA_WIDTH+1)* 6-1:(DATA_WIDTH+1)* 5],
                          {3{u_matrix_cal_top.p_data[(DATA_WIDTH+1)* 5-1]}},u_matrix_cal_top.p_data[(DATA_WIDTH+1)* 5-1:(DATA_WIDTH+1)* 4],
                          {3{u_matrix_cal_top.p_data[(DATA_WIDTH+1)* 4-1]}},u_matrix_cal_top.p_data[(DATA_WIDTH+1)* 4-1:(DATA_WIDTH+1)* 3],
                          {3{u_matrix_cal_top.p_data[(DATA_WIDTH+1)* 3-1]}},u_matrix_cal_top.p_data[(DATA_WIDTH+1)* 3-1:(DATA_WIDTH+1)* 2],
                          {3{u_matrix_cal_top.p_data[(DATA_WIDTH+1)* 2-1]}},u_matrix_cal_top.p_data[(DATA_WIDTH+1)* 2-1:(DATA_WIDTH+1)* 1],
                          {3{u_matrix_cal_top.p_data[(DATA_WIDTH+1)* 1-1]}},u_matrix_cal_top.p_data[(DATA_WIDTH+1)* 1-1:(DATA_WIDTH+1)* 0]};

assign    q_data_check = {{2{u_matrix_cal_top.q_data[(DATA_WIDTH+2)*16-1]}},u_matrix_cal_top.q_data[(DATA_WIDTH+2)*16-1:(DATA_WIDTH+2)*15],
                          {2{u_matrix_cal_top.q_data[(DATA_WIDTH+2)*15-1]}},u_matrix_cal_top.q_data[(DATA_WIDTH+2)*15-1:(DATA_WIDTH+2)*14],
                          {2{u_matrix_cal_top.q_data[(DATA_WIDTH+2)*14-1]}},u_matrix_cal_top.q_data[(DATA_WIDTH+2)*14-1:(DATA_WIDTH+2)*13],
                          {2{u_matrix_cal_top.q_data[(DATA_WIDTH+2)*13-1]}},u_matrix_cal_top.q_data[(DATA_WIDTH+2)*13-1:(DATA_WIDTH+2)*12],
                          {2{u_matrix_cal_top.q_data[(DATA_WIDTH+2)*12-1]}},u_matrix_cal_top.q_data[(DATA_WIDTH+2)*12-1:(DATA_WIDTH+2)*11],
                          {2{u_matrix_cal_top.q_data[(DATA_WIDTH+2)*11-1]}},u_matrix_cal_top.q_data[(DATA_WIDTH+2)*11-1:(DATA_WIDTH+2)*10],
                          {2{u_matrix_cal_top.q_data[(DATA_WIDTH+2)*10-1]}},u_matrix_cal_top.q_data[(DATA_WIDTH+2)*10-1:(DATA_WIDTH+2)* 9],
                          {2{u_matrix_cal_top.q_data[(DATA_WIDTH+2)* 9-1]}},u_matrix_cal_top.q_data[(DATA_WIDTH+2)* 9-1:(DATA_WIDTH+2)* 8],
                          {2{u_matrix_cal_top.q_data[(DATA_WIDTH+2)* 8-1]}},u_matrix_cal_top.q_data[(DATA_WIDTH+2)* 8-1:(DATA_WIDTH+2)* 7],
                          {2{u_matrix_cal_top.q_data[(DATA_WIDTH+2)* 7-1]}},u_matrix_cal_top.q_data[(DATA_WIDTH+2)* 7-1:(DATA_WIDTH+2)* 6],
                          {2{u_matrix_cal_top.q_data[(DATA_WIDTH+2)* 6-1]}},u_matrix_cal_top.q_data[(DATA_WIDTH+2)* 6-1:(DATA_WIDTH+2)* 5],
                          {2{u_matrix_cal_top.q_data[(DATA_WIDTH+2)* 5-1]}},u_matrix_cal_top.q_data[(DATA_WIDTH+2)* 5-1:(DATA_WIDTH+2)* 4],
                          {2{u_matrix_cal_top.q_data[(DATA_WIDTH+2)* 4-1]}},u_matrix_cal_top.q_data[(DATA_WIDTH+2)* 4-1:(DATA_WIDTH+2)* 3],
                          {2{u_matrix_cal_top.q_data[(DATA_WIDTH+2)* 3-1]}},u_matrix_cal_top.q_data[(DATA_WIDTH+2)* 3-1:(DATA_WIDTH+2)* 2],
                          {2{u_matrix_cal_top.q_data[(DATA_WIDTH+2)* 2-1]}},u_matrix_cal_top.q_data[(DATA_WIDTH+2)* 2-1:(DATA_WIDTH+2)* 1],
                          {2{u_matrix_cal_top.q_data[(DATA_WIDTH+2)* 1-1]}},u_matrix_cal_top.q_data[(DATA_WIDTH+2)* 1-1:(DATA_WIDTH+2)* 0]};

CHECKER#(.filename("../data/p_data.txt"),
         .d_width (  16*(DATA_WIDTH+4)         ))
checker_p_data(
    .clk            (clk                                                            ),
    .rst_n          (rst_n                                                          ),
    .input_en       (u_matrix_cal_top.p_vld && u_matrix_cal_top.p_rdy               ),
    .data_i         (p_data_check                                                   ),
    .data_check_done());

CHECKER#(.filename("../data/q_data.txt"),
         .d_width (  16*(DATA_WIDTH+4)         ))
checker_q_data(
    .clk            (clk                                                            ),
    .rst_n          (rst_n                                                          ),
    .input_en       (u_matrix_cal_top.q_vld && u_matrix_cal_top.q_rdy               ),
    .data_i         (q_data_check                                                   ),
    .data_check_done());

CHECKER#(.filename("../data/tmp_row_data.txt"),
         .d_width (  16*(DATA_WIDTH+4)         ))
checker_tmp_row_data(
    .clk            (clk                                                            ),
    .rst_n          (rst_n                                                          ),
    .input_en       (u_matrix_cal_top.tmp_row_vld && u_matrix_cal_top.tmp_row_rdy   ),
    .data_i         (u_matrix_cal_top.tmp_row_data                                  ),
    .data_check_done());

CHECKER#(.filename("../data/tmp_col_data.txt"),
         .d_width (  16*(DATA_WIDTH+4)         ))
checker_tmp_col_data(
    .clk            (clk                                                            ),
    .rst_n          (rst_n                                                          ),
    .input_en       (u_matrix_cal_top.tmp_col_vld && u_matrix_cal_top.tmp_col_rdy   ),
    .data_i         (u_matrix_cal_top.tmp_col_data                                  ),
    .data_check_done(data_check_done));


//finish the simulation 
always@(posedge data_check_done)
    # 500
    if(data_check_done == 1'b1)
        $finish;
    

endmodule

