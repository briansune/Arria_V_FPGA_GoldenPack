`timescale 1 ps / 1 ps
// test
//
module altpcie_av_hip_ast_hip_status_bridge (
                input              to_hip_ev128ns,           //                  .ev128ns
                input              to_hip_rx_par_err,        //                  .rx_par_err
                input [3:0]        to_hip_lane_act,          //                  .lane_act
                input              to_hip_cfg_par_err,       //                  .cfg_par_err
                input              to_hip_derr_cor_ext_rcv,  //                  .derr_cor_ext_rcv
                input              to_hip_dlup_exit,         //                  .dlup_exit
                input              to_hip_hotrst_exit,       //                  .hotrst_exit
               // input [1:0]        to_hip_currentspeed,      //                  .currentspeed
                input [1:0]        to_hip_tx_par_err,        //                  .tx_par_err
                input              to_hip_ev1us,             //                  .ev1us
                input              to_hip_l2_exit,           //                  .l2_exit
                input [4:0]        to_hip_ltssmstate,        //                  .ltssmstate
                input [3:0]        to_hip_int_status,        //                  .int_status
                input              to_hip_derr_rpl,          //                  .derr_rpl
                input [7:0]        to_hip_ko_cpl_spc_header, //                  .ko_cpl_spc_header
                input [11:0]       to_hip_ko_cpl_spc_data,   //                  .ko_cpl_spc_data
                input              to_hip_derr_cor_ext_rpl,  //                  .derr_cor_ext_rpl

                output wire        to_apps_ev128ns,           //                  .ev128ns
                output wire [3:0]  to_apps_lane_act,          //                  .lane_act
                output wire        to_apps_derr_cor_ext_rcv,  //                  .derr_cor_ext_rcv
                output wire        to_apps_dlup_exit,         //                  .dlup_exit
                output wire        to_apps_hotrst_exit,       //                  .hotrst_exit
              //  output wire [1:0]  to_apps_currentspeed,      //                  .currentspeed
                output wire        to_apps_ev1us,             //                  .ev1us
                output wire        to_apps_l2_exit,           //                  .l2_exit
                output wire [4:0]  to_apps_ltssmstate,        //                  .ltssmstate
                output wire [3:0]  to_apps_int_status,        //                  .int_status
                output wire        to_apps_derr_rpl,          //                  .derr_rpl
                output wire [7:0]  to_apps_ko_cpl_spc_header, //                  .ko_cpl_spc_header
                output wire [11:0] to_apps_ko_cpl_spc_data,   //                  .ko_cpl_spc_data
                output wire        to_apps_derr_cor_ext_rpl,  //                  .derr_cor_ext_rpl

                output wire        export_ev128ns,           //                  .ev128ns
                output wire [3:0]  export_lane_act,          //                  .lane_act
                output wire        export_derr_cor_ext_rcv,  //                  .derr_cor_ext_rcv
                output wire        export_dlup_exit,         //                  .dlup_exit
                output wire        export_hotrst_exit,       //                  .hotrst_exit
              //  output wire [1:0]  export_currentspeed,      //                  .currentspeed
                output wire        export_ev1us,             //                  .ev1us
                output wire        export_l2_exit,           //                  .l2_exit
                output wire [4:0]  export_ltssmstate,        //                  .ltssmstate
                output wire [3:0]  export_int_status,        //                  .int_status
                output wire        export_derr_rpl,          //                  .derr_rpl
                output wire [7:0]  export_ko_cpl_spc_header, //                  .ko_cpl_spc_header
                output wire [11:0] export_ko_cpl_spc_data,   //                  .ko_cpl_spc_data
                output wire        export_derr_cor_ext_rpl,  //                  .derr_cor_ext_rpl

                output [4:0]        to_hip_hpg_ctrler     ,
                input  [3:0]        to_hip_tl_cfg_add     ,
                input  [31:0]       to_hip_tl_cfg_ctl     ,
                input  [52:0]       to_hip_tl_cfg_sts     ,
                input               to_hip_tl_cfg_ctl_wr  ,
                input               to_hip_tl_cfg_sts_wr  ,
                output wire [6:0]   to_hip_cpl_err        ,
                output wire         to_hip_cpl_pending    ,

                input  [4:0]        to_apps_hpg_ctrler     ,
                output wire [3:0]   to_apps_tl_cfg_add     ,
                output wire [31:0]  to_apps_tl_cfg_ctl     ,
                output wire [52:0]  to_apps_tl_cfg_sts     ,
                output wire         to_apps_tl_cfg_ctl_wr  ,
                output wire         to_apps_tl_cfg_sts_wr  ,
                input  [6:0]        to_apps_cpl_err        ,
                input               to_apps_cpl_pending    ,

                output wire [3:0]   export_tl_cfg_add      ,
                output wire [31:0]  export_tl_cfg_ctl      ,
                output wire [52:0]  export_tl_cfg_sts      ,
                output wire         export_tl_cfg_ctl_wr   ,
                output wire         export_tl_cfg_sts_wr   ,

                input pld_clk,
                output wire export_pld_clk
        );

assign export_pld_clk = pld_clk;

assign  to_apps_ev128ns           = to_hip_ev128ns;
assign  to_apps_lane_act          = to_hip_lane_act;
assign  to_apps_derr_cor_ext_rcv  = to_hip_derr_cor_ext_rcv;
assign  to_apps_dlup_exit         = to_hip_dlup_exit;
assign  to_apps_hotrst_exit       = to_hip_hotrst_exit;
//assign  to_apps_currentspeed      = to_hip_currentspeed;
assign  to_apps_ev1us             = to_hip_ev1us;
assign  to_apps_l2_exit           = to_hip_l2_exit;
assign  to_apps_ltssmstate        = to_hip_ltssmstate;
assign  to_apps_int_status        = to_hip_int_status;
assign  to_apps_derr_rpl          = to_hip_derr_rpl;
assign  to_apps_ko_cpl_spc_header = to_hip_ko_cpl_spc_header;
assign  to_apps_ko_cpl_spc_data   = to_hip_ko_cpl_spc_data;
assign  to_apps_derr_cor_ext_rpl  = to_hip_derr_cor_ext_rpl;

assign  export_ev128ns           = to_hip_ev128ns;
assign  export_lane_act          = to_hip_lane_act;
assign  export_derr_cor_ext_rcv  = to_hip_derr_cor_ext_rcv;
assign  export_dlup_exit         = to_hip_dlup_exit;
assign  export_hotrst_exit       = to_hip_hotrst_exit;
//assign  export_currentspeed      = to_hip_currentspeed;
assign  export_ev1us             = to_hip_ev1us;
assign  export_l2_exit           = to_hip_l2_exit;
assign  export_ltssmstate        = to_hip_ltssmstate;
assign  export_int_status        = to_hip_int_status;
assign  export_derr_rpl          = to_hip_derr_rpl;
assign  export_ko_cpl_spc_header = to_hip_ko_cpl_spc_header;
assign  export_ko_cpl_spc_data   = to_hip_ko_cpl_spc_data;
assign  export_derr_cor_ext_rpl  = to_hip_derr_cor_ext_rpl;

assign   to_apps_tl_cfg_add     = to_hip_tl_cfg_add       ;
assign   to_apps_tl_cfg_ctl     = to_hip_tl_cfg_ctl       ;
assign   to_apps_tl_cfg_sts     = to_hip_tl_cfg_sts       ;
assign   to_apps_tl_cfg_ctl_wr  = to_hip_tl_cfg_ctl_wr    ;
assign   to_apps_tl_cfg_sts_wr  = to_hip_tl_cfg_sts_wr    ;
assign   to_hip_hpg_ctrler      = to_apps_hpg_ctrler      ;
assign   to_hip_cpl_err         = to_apps_cpl_err         ;
assign   to_hip_cpl_pending     = to_apps_cpl_pending     ;

assign   export_tl_cfg_add      = to_hip_tl_cfg_add;
assign   export_tl_cfg_ctl      = to_hip_tl_cfg_ctl;
assign   export_tl_cfg_sts      = to_hip_tl_cfg_sts;
assign   export_tl_cfg_ctl_wr   = to_hip_tl_cfg_ctl_wr;
assign   export_tl_cfg_sts_wr   = to_hip_tl_cfg_sts_wr;


endmodule
