// top.v

// top.v


`timescale 1 ps / 1 ps
module top_hw (
                input  wire         refclk_clk,                //     refclk.clk
                input  wire         reconfig_xcvr_clk,         //     refclk.clk
                input  wire         hip_serial_rx_in0,         //           .rx_in0
                input  wire         hip_serial_rx_in1,         //           .rx_in1
                input  wire         hip_serial_rx_in2,         //           .rx_in2
                input  wire         hip_serial_rx_in3,         //           .rx_in3
                input  wire         hip_serial_rx_in4,         //           .rx_in0
                input  wire         hip_serial_rx_in5,         //           .rx_in1
                input  wire         hip_serial_rx_in6,         //           .rx_in2
                input  wire         hip_serial_rx_in7,         //           .rx_in3
                output wire         hip_serial_tx_out0,        //           .tx_out0
                output wire         hip_serial_tx_out1,        //           .tx_out1
                output wire         hip_serial_tx_out3,        //           .tx_out3
                output wire         hip_serial_tx_out2,        // hip_serial.tx_out2
                output wire         hip_serial_tx_out4,        //           .tx_out0
                output wire         hip_serial_tx_out5,        //           .tx_out1
                output wire         hip_serial_tx_out6,        //           .tx_out3
                output wire         hip_serial_tx_out7,        // hip_serial.tx_out2
                input  wire         local_rstn,
                output  wire        hsma_clk_out_p2,
                output  reg [3:0]   lane_active_led,
                output  reg         L0_led,
                output  reg         alive_led,
                output  reg         comp_led,
                output  reg         gen2_led,
                input  wire         perstn             //  pcie_rstn.npor
        );

wire [31:0]  test_in;          //           .test_in
wire         fbout_reconfigclk;
wire [52:0]  tl_cfg_tl_cfg_sts;
wire [31:0] tl_cfg_tl_cfg_ctl;            //            tl_cfg.tl_cfg_ctl
wire [3:0]  tl_cfg_tl_cfg_add;            //                  .tl_cfg_add
wire        status_hip_rx_par_err;        //        status_hip.rx_par_err
wire [3:0]  status_hip_int_status;        //                  .int_status
wire        status_hip_derr_cor_ext_rcv;  //                  .derr_cor_ext_rcv
wire        status_hip_dlup_exit;         //                  .dlup_exit
wire [11:0] status_hip_ko_cpl_spc_data;   //                  .ko_cpl_spc_data
wire        status_hip_l2_exit;           //                  .l2_exit
wire        status_hip_ev1us;             //                  .ev1us
wire        status_hip_derr_rpl;          //                  .derr_rpl
wire [3:0]  status_hip_lane_act;          //                  .lane_act
wire        status_hip_ev128ns;           //                  .ev128ns
//wire [1:0]  status_hip_currentspeed;      //                  .currentspeed
wire        status_hip_hotrst_exit;       //                  .hotrst_exit
wire        status_hip_derr_cor_ext_rpl;  //                  .derr_cor_ext_rpl
wire [7:0]  status_hip_ko_cpl_spc_header;//                  .ko_cpl_spc_header
wire        pld_clk_clk;
wire        no_connect;
reg     [ 24: 0] alive_cnt;
wire             any_rstn;
reg              any_rstn_r /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=R102"  */;
reg              any_rstn_rr /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=R102"  */;
wire             gen2_speed;
wire [5:0]       ltssm;

assign any_rstn = local_rstn;
assign hsma_clk_out_p2 = reconfig_xcvr_clk;
assign gen2_speed = tl_cfg_tl_cfg_sts[32:31] == 2'b10;

assign test_in[0]    =  1'b0; // Simulation mode
assign test_in[1]    =  1'b0; // Reserved
assign test_in[2]    =  1'b0; // Reserved
assign test_in[3]    =  1'b0; // FPGA Mode
assign test_in[4]    =  1'b0; // Reserved
assign test_in[5]    =  1'b1; // Disable compliance mode
assign test_in[6]    =  1'b0; // Disable compliance mode
assign test_in[7]    =  1'b1; // Disable low power state
assign test_in[11:8] =  4'b0011;
assign test_in[12]      =  1'b0;
assign test_in[15:13]   =  3'b100;
assign test_in[31:16] =  16'h0;


  //reset Synchronizer
  always @(posedge reconfig_xcvr_clk or negedge any_rstn)
    begin
      if (any_rstn == 0)
        begin
          any_rstn_r <= 0;
          any_rstn_rr <= 0;
        end
      else
        begin
          any_rstn_r <= 1;
          any_rstn_rr <= any_rstn_r;
        end
    end



  //LED logic
  always @(posedge pld_clk_clk or negedge any_rstn_rr)
    begin
      if (any_rstn_rr == 0)
        begin
          alive_cnt <= 0;
          alive_led <= 0;
          comp_led <= 0;
          L0_led <= 0;
          gen2_led <= 0;
          lane_active_led[3:0] <= 0;
        end
      else
        begin
          alive_cnt <= alive_cnt +1;
          alive_led <= alive_cnt[24];
          comp_led <= ~(ltssm[4 : 0] == 5'b00011);
          L0_led <= ~(ltssm[4 : 0] == 5'b01111);
          gen2_led <= ~gen2_speed;
          if (tl_cfg_tl_cfg_sts[35])
            lane_active_led <= ~(4'b0001);
          else if (tl_cfg_tl_cfg_sts[36])
            lane_active_led <= ~(4'b0011);
          else if (tl_cfg_tl_cfg_sts[37])
            lane_active_led <= ~(4'b1111);
          else if (tl_cfg_tl_cfg_sts[38])
            lane_active_led <= alive_cnt[24] ? ~(4'b1111) : ~(4'b0111);
        end
    end

   top top (
             .dut_refclk_clk               (refclk_clk               ),//     refclk.clk
             .clk_clk                      (refclk_clk        ),
             .dut_hip_ctrl_test_in         (test_in         ),//           .test_in//TODO Check testin
             .dut_hip_serial_rx_in0        (hip_serial_rx_in0        ),//           .rx_in0
             .dut_hip_serial_rx_in1        (hip_serial_rx_in1        ),//           .rx_in1
             .dut_hip_serial_rx_in2        (hip_serial_rx_in2        ),//           .rx_in2
             .dut_hip_serial_rx_in3        (hip_serial_rx_in3        ),//           .rx_in3
             .dut_hip_serial_rx_in4        (hip_serial_rx_in4        ),//           .rx_in0
             .dut_hip_serial_rx_in5        (hip_serial_rx_in5        ),//           .rx_in1
             .dut_hip_serial_rx_in6        (hip_serial_rx_in6        ),//           .rx_in2
             .dut_hip_serial_rx_in7        (hip_serial_rx_in7        ),//           .rx_in3
             .dut_hip_serial_tx_out0       (hip_serial_tx_out0       ), //           .tx_out0
             .dut_hip_serial_tx_out1       (hip_serial_tx_out1       ), //           .tx_out1
             .dut_hip_serial_tx_out3       (hip_serial_tx_out3       ), //           .tx_out3
             .dut_hip_serial_tx_out2       (hip_serial_tx_out2       ), // hip_serial.tx_out2
             .dut_hip_serial_tx_out4       (hip_serial_tx_out4       ), //           .tx_out0
             .dut_hip_serial_tx_out5       (hip_serial_tx_out5       ), //           .tx_out1
             .dut_hip_serial_tx_out6       (hip_serial_tx_out6       ), //           .tx_out3
             .dut_hip_serial_tx_out7       (hip_serial_tx_out7       ), // hip_serial.tx_out2
             .pld_clk_clk                  (pld_clk_clk),
             .tl_cfg_tl_cfg_sts            (tl_cfg_tl_cfg_sts),
             .tl_cfg_tl_cfg_ctl            (tl_cfg_tl_cfg_ctl           ),
             .tl_cfg_tl_cfg_add            (tl_cfg_tl_cfg_add           ),
             .status_hip_int_status        (status_hip_int_status       ),
             .status_hip_derr_cor_ext_rcv  (status_hip_derr_cor_ext_rcv ),
             .status_hip_dlup_exit         (status_hip_dlup_exit        ),
             .status_hip_ko_cpl_spc_data   (status_hip_ko_cpl_spc_data  ),
             .status_hip_l2_exit           (status_hip_l2_exit          ),
             .status_hip_ev1us             (status_hip_ev1us            ),
             .status_hip_derr_rpl          (status_hip_derr_rpl         ),
             .status_hip_ltssmstate        (ltssm       ),
             .status_hip_lane_act          (status_hip_lane_act         ),
             .status_hip_ev128ns           (status_hip_ev128ns          ),
            // .status_hip_currentspeed      (status_hip_currentspeed     ),
             .status_hip_hotrst_exit       (status_hip_hotrst_exit      ),
             .status_hip_derr_cor_ext_rpl  (status_hip_derr_cor_ext_rpl ),
             .status_hip_ko_cpl_spc_header (status_hip_ko_cpl_spc_header),
             .dut_npor_npor                (any_rstn_rr),                            //         pcie_rstn.npor
             .reset_reset_n                ((perstn==1'b0)?1'b0:(local_rstn==1'b0)?1'b0:1'b1), // reconfig_xcvr_rst.reconfig_xcvr_rst
             .dut_npor_pin_perst           (perstn)
     );




endmodule

