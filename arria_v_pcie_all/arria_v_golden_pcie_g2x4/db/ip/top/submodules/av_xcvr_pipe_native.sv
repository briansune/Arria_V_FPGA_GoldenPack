// (C) 2001-2017 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


`timescale 1ps/1ps

//************************************************************************************************************************
//
// Arria V Native PIPE Channel - soft PIPE mode
//
//************************************************************************************************************************

module av_xcvr_pipe_native #(
        parameter               device_family = "Arria V", 
        parameter               lanes = 1,                                                      //legal value: 1+
        parameter               starting_channel_number = 0,                    //Automatically set to 0. So do we still need it?
        parameter               protocol_version = "Gen 1",                             //legal value: "Gen 1", "Gen 2"
        parameter               deser_factor = 8,                                               //legal values: 8, 16
// base_data_rate parameter needed?
        parameter               pll_refclk_freq = "100 MHz",                            //legal value = "100 MHz", "125 MHz"
        parameter               pipe_low_latency_syncronous_mode = 0,   //legal value: 0, 1
        parameter               pipe_run_length_violation_checking = 160, //legal value:[160:5:5], max (6'b0) is the default value
        parameter               pipe_elec_idle_infer_enable = "false",          //legal value: true, false
        parameter               hip_enable = "false",
        parameter               hip_hard_reset = "disable",
        // Exposing the Pre-emphasis and VOD static values
        parameter               pipe12_rpre_emph_a_val = 6'd12, 
        parameter               pipe12_rpre_emph_b_val = 6'd0,
        parameter               pipe12_rpre_emph_c_val = 6'd19,
        parameter               pipe12_rpre_emph_d_val = 6'd13,
        parameter               pipe12_rpre_emph_e_val = 6'd21,
        parameter               pipe12_rvod_sel_a_val  = 6'd42,
        parameter               pipe12_rvod_sel_b_val  = 6'd30,
        parameter               pipe12_rvod_sel_c_val  = 6'd43,
        parameter               pipe12_rvod_sel_d_val  = 6'd43,
        parameter               pipe12_rvod_sel_e_val  = 6'd9,
        parameter               reserved_channel       = "false", // Indicates if a reserved channel is required. Only allowed for placement similar to HIP x8  
        parameter               master_ch_number       = -1       // MASTER_CH override
        
) (
        //input from reset controller
        input  wire                                     pll_powerdown,                          // for tx pll from pld
        input  wire                                     tx_analogreset,                         // for tx pma from pld
        input  wire  [lanes-1 :0]                       tx_digitalreset,                        // for tx pcs from pld
        input  wire  [lanes-1 :0]                       rx_analogreset,                         // for rx pma from pld
        input  wire  [lanes-1 :0]                       rx_digitalreset,                        // for rx pcs from pld

        //input clocks from user
        input  wire                                     pll_ref_clk,                            // reference clock for PLL
        input  wire                                     fixedclk,                               // used in receiver detect (txdetrx) block in Tx PMA

        //PIPE interface ports (avalon streaming ports)
        output wire                                     pipe_pclk,
        input  wire [lanes*deser_factor -1:0]           pipe_txdata,
        input  wire [(lanes*deser_factor)/8 -1:0]       pipe_txdatak,

        input  wire [lanes -1:0]                        pipe_txcompliance,
        input  wire [lanes -1:0]                        pipe_txelecidle,
        input  wire [lanes -1:0]                        pipe_rxpolarity,
        output wire [lanes*deser_factor -1:0]           pipe_rxdata,
        output wire [(lanes*deser_factor)/8 -1:0]       pipe_rxdatak,
        output wire [lanes -1:0]                        pipe_rxvalid,
        output wire [lanes -1:0]                        pipe_rxelecidle,
        output wire [lanes*3 -1:0]                      pipe_rxstatus,

        input  wire     [lanes -1:0]                    pipe_txdetectrx_loopback,
        input  wire     [lanes -1:0]                    pipe_txswing,
        input  wire     [lanes*3 -1:0]                  pipe_txmargin,
        input  wire     [lanes -1:0]                    pipe_txdeemph,
        input  wire     [lanes -1:0]                    pipe_rate,                              // each channel has its own dedicated pipe_rate signal
        input  wire     [lanes*2 -1:0]                  pipe_powerdown,
        output wire     [lanes -1:0]                    pipe_phystatus,
        input  wire     [lanes*3 -1:0]                  rx_eidleinfersel,

        //non-PIPE ports
        //MM ports
        input  wire [lanes -1:0]                        rx_set_locktodata,              // directly connected to rx_pma.ltd
        input  wire [lanes -1:0]                        rx_set_locktoref,                       // goes through pcs and then to rx_pma.ltr
        input  wire [lanes -1:0]                        tx_invpolarity,
        output wire [(lanes*deser_factor)/8 -1:0]       rx_errdetect,
        output wire [(lanes*deser_factor)/8 -1:0]       rx_disperr,
        output wire [(lanes*deser_factor)/8 -1:0]       rx_patterndetect,
        output wire [(lanes*deser_factor)/8 -1:0]       rx_syncstatus,
        output wire [lanes -1:0]                        rx_phase_comp_fifo_error,
        output wire [lanes -1:0]                        tx_phase_comp_fifo_error,
        output wire [lanes -1:0]                        rx_is_lockedtoref,                      // directly from rx_pma
        output wire [lanes -1:0]                        rx_is_lockedtodata,             // from rx_pma to pcs then to port
        output wire [lanes -1:0]                        rx_signaldetect,
        output wire     [lanes -1:0]                    rx_rlv,
        output wire [lanes*5  -1:0]                     rx_bitslipboundaryselectout,
        output wire                                     pll_locked,
        input  tri0 [lanes -1:0]                        rx_seriallpbken,

        // Calibration busy signals
        output  wire [lanes-1:0]                        tx_cal_busy,
        output  wire [lanes-1:0]                        rx_cal_busy,
        //non-MM ports
        input  wire [lanes -1:0]                        rx_serial_data,
        output wire [lanes -1:0]                        tx_serial_data,

        //Reconfig interface
        // Gen 1/Gen 2.
    // Non-HIP x8  - 8 channels                 + 1 PLL  (1 Tx PLL)
    // Non-HIP x4  - 4 channels                 + 1 PLL  (1 Tx PLL)
    // Non-HIP x1  - 1 channel                  + 1 PLL  (1 Tx PLL)

        input   wire  [altera_xcvr_functions::get_custom_reconfig_to_width  ("Arria V","Duplex", (reserved_channel == "true" ? lanes+1 : lanes), 1, (reserved_channel == "true" ? lanes+1 : lanes),"","xN")-1:0] reconfig_to_xcvr,
        output  wire  [altera_xcvr_functions::get_custom_reconfig_from_width ("Arria V","Duplex", (reserved_channel == "true" ? lanes+1 : lanes), 1, (reserved_channel == "true" ? lanes+1 : lanes),"","xN")-1:0] reconfig_from_xcvr
        );

        import altera_xcvr_functions::*;
        //****************************************************************************************************
        // Derive localparams for PCS and PMA
        //****************************************************************************************************
        //********************************************
        // Common local params
        //********************************************
        // protocol mode

        localparam                      PROT_MODE = (protocol_version == "Gen 1") ? "pipe_g1" :
                                                    (protocol_version == "Gen 2") ? "pipe_g2" : "<invalid>";

        // HIP mode
        localparam                      HIP_MODE  = "dis_hip" ;

        // Total Lanes
        localparam                      TOTAL_LANES = (reserved_channel == "true") ? lanes+1 : lanes;


        // Master channel in bonding mode - none of this should matter, as the AV fitter can override the master channel settings
        //2. x8 without hip        -> channel 0
        //3. x4 with/without hip   -> channel 1
        //4. x2 with/without hip   -> channel 1
        //5. others (should be x1) -> channel 0

        localparam BONDING_MASTER_CH = (master_ch_number != -1) ? master_ch_number :
                                       (lanes == 8)? 0 :
                                       (lanes == 4)? 1 :
                                       (lanes == 2)? 1 :
                                       (lanes == 1)? 0 :    -1;

        localparam PMA_BONDING_MASTER = (master_ch_number != -1) ? int2str(master_ch_number) :
                                        (lanes == 8) ? "0" :
                                        (lanes == 4) ? "1" :
                                        (lanes == 2) ? "1" :
                                        (lanes == 1) ? "0" : "-1";

        // BONDING_MASTER_CH is master only  
        localparam BONDING_MASTER_ONLY = (reserved_channel == "true") ? "4" : "-1";


        //********************************************
        // PMA local params
        //********************************************
        // PCIe always in 10b
        localparam                      PMA_DW   = "ten_bit";
        localparam                      PMA_MODE = 10;

        // PMA data rate
        localparam                      PMA_DATA_RATE = (protocol_version == "Gen 1") ? "2500000000 bps" :
                                                                                 (protocol_version == "Gen 2") ? "5000000000 bps" :
                                                                                                                                        "<invalid>";

        // PMA Auto Negotiation
        localparam                      PMA_AUTO_NEGOTIATION = (protocol_version == "Gen 1") ? "false" :
                                                                                                (protocol_version == "Gen 2") ? "true" :
                                                                                                                                                "<invalid>";

        //********************************************
        // PCS local params
        //********************************************

        // Rx byte deserializer
        localparam                      PCS8G_RX_BYTE_DESERIALIZER = ((deser_factor == 16) ? "en_bds_by_2" : "dis_bds");

        // Rx Rate Match FIFO low latency synchronous mode
        localparam                      RATE_MATCH = (pipe_low_latency_syncronous_mode)? "pipe_rm_0ppm" : "pipe_rm";

        // Rx electrical idle inference
        // This feature has both param and port associated with it
        localparam                      ELEC_IDLE_INFER    = (pipe_elec_idle_infer_enable == "true")? "en_eidle_iei" : "dis_eidle_iei";

        // Per ICD, enable elec idle entry by signal detection only when inference is enabled and for Gen1. The elec idle inference logic in PCS will
        // look at both the idle data channel and the deassertion of SD from PMA to assert rx_elecidle. In Gen 2, SD from PMA is not reliable.
        localparam                      ELEC_IDLE_ENTRY_SD = (pipe_elec_idle_infer_enable == "true" && protocol_version == "Gen 1")? "en_eidle_sd" : "dis_eidle_sd";

        // Phase Comp FIFO mode
        localparam                      PCS8G_PC_FIFO = "low_latency"; // bauyeung might need to pass as parameter?

        // PIPE Interface Enable
        localparam                      PCS8G_RX_PIPE_IF_ENABLE = "en_pipe_rx";

        //RLV param
        //RLV is always enabled for ten_bit (en_runlength_sw), default to 6'b0 which is the max value (160)
        //otherwise run_length/5. possible setting: [160:5:5]
        localparam                      division  = (PMA_DW=="ten_bit")? 5 :
                                                                        (PMA_DW=="eight_bit")? 4 : 0;

        localparam                      RUN_LENGTH  = (pipe_run_length_violation_checking==0)? "invalid" :
                                                                            ((PMA_DW=="ten_bit")||(PMA_DW=="eight_bit"))? "en_runlength_sw" : "invalid";

        localparam                      RUNLENGTH_MAX   = 160;
        localparam                      RUNLENGTH_DIV   = pipe_run_length_violation_checking/division;
        localparam [5:0]        RUNLENGTH_VALUE = (pipe_run_length_violation_checking==RUNLENGTH_MAX)? 6'b0:RUNLENGTH_DIV[5:0];

    // Tx byte serializer
    // Enable PCS8G Tx Byte SERDES for:
    //    1. 16-bit interface
    localparam PCS8G_TX_BYTE_SERIALIZER =   ((deser_factor == 16) ? "en_bs_by_2" : 
					       "dis_bs");                                  
        // Tx Compliance Controlled Disparity
        localparam                      PCS8G_TX_COMPL_CONTR_DISP = "en_txcompliance_pipe2p0"; //en_txcompliance_pipe2p0 | dis_txcompliance

        // Gen1-2 PIPE Byte Deserializer Enable
        localparam                      PIPE12_BYTE_DESERIALIZER_EN = (deser_factor == 16)? "en_bds_by_2" : "dis_bds";


        //Setting available for PCIE
        //Setting for disparity error reported code with RXStatus
        //RIND_ERROR_REPORTING = 1 and RINVALID_CODE_ERR_ONLY = 1 to decode disparity error with code 3b111
        localparam                      IND_ERROR_REPORTING     = "dis_ind_error_reporting"; //Valid values: DIS_IND_ERROR_REPORTING|EN_IND_ERROR_REPORTING
        localparam                      INVALID_CODE_FLAG_ONLY = "dis_invalid_code_only"; //Valid values: DIS_INVALID_CODE_ONLY|EN_INVALID_CODE_ONLY

        //********************************************
        // PCS-PLD Interface local param
        //********************************************
        // Hard reset controller is not used in this wrapper (no HIP)
        localparam  HRDRSTCTRL_EN_CFGUSR = "hrst_dis_cfgusr";
        localparam  HRDRSTCTRL_EN_CFG    = "hrst_dis_cfg";

        //********************************************
        // Other local params
        //********************************************
        localparam                      WORD_SIZE     = 8;
        localparam                      SER_WORDS    = deser_factor/WORD_SIZE;

        // Gen 1/Gen 2.
     // Non-HIP x8                - 8 channels               + 1 PLL  (1 Tx PLL)
     // Non-HIP x4                - 4 channels               + 1 PLL  (1 Tx PLL)
     // Non-HIP x1                - 1 channel                + 1 PLL  (1 Tx PLL)
    
        localparam                      NUM_TX_PLLS   = 1; //For Gen2 x8, 1 Tx PLL is used to bond using xN line.
        localparam                      W_BUNDLE_TO_XCVR   = W_S5_RECONFIG_BUNDLE_TO_XCVR;
        localparam                      W_BUNDLE_FROM_XCVR = W_S5_RECONFIG_BUNDLE_FROM_XCVR;

        // *****************************************************************  
        // Using different pma_done counter values for simulation and synthesis 
        `ifdef ALTERA_RESERVED_QIS
          localparam  PMA_DONE_CNTR = 18'd175000;
        `else
          localparam  PMA_DONE_CNTR = 18'd80;
        `endif
        // *****************************************************************
        //******************************************************************
        // RBC checks
        //******************************************************************
        initial /* synthesis enable_verilog_initial_construct */
        begin
                if (BONDING_MASTER_CH == -1)
                        $display("Error: Parameter 'lanes' of instance '%m' has illegal value '%d' assigned to it.  Valid parameter values are 1,2,4,8.", lanes);

                if (RUN_LENGTH == "invalid")
                        $display("Error: Parameter 'pipe_run_length_violation_checking' of instance '%m' has illegal value '%d' assigned to it.  Valid parameter value is: [160:5:5].", pipe_run_length_violation_checking);

        end
        //******************************************************************
        // Wire declarations
        //******************************************************************
        wire [NUM_TX_PLLS -1 : 0]                               pll_out;
        wire                                                    w_rst_to_tx_pll;
        wire [TOTAL_LANES  -1:0]                                tx_clkout_to_pld;

        // Wires that are connected from PLD to PCS (non-HIP designs)
        // Not yet adjusted for HIP x8 type of placement with master-only channel. lanes wide.
        tri0 [lanes*44     -1:0]                                txdatain_from_pld;
        wire [lanes*2      -1:0]                                pld8gpowerdown;
        wire [lanes*3      -1:0]                                pld8gtxmargin;
        wire [lanes*3      -1:0]                                pldeidleinfersel;
        wire [lanes        -1:0]                                pld8gtxdetectrxloopback;
        wire [lanes        -1:0]                                pld8gtxelecidle;
        wire [lanes        -1:0]                                pld8gtxdeemph;
        wire [lanes        -1:0]                                pld8gtxswing;
        wire [lanes        -1:0]                                pldrate;
        wire [lanes        -1:0]                                pldtxinvpolarity;
        wire [lanes        -1:0]                                pldltr;
        wire [lanes        -1:0]                                pldrxanalogreset;
        wire [lanes        -1:0]                                pldtxdigitalreset;
        wire [lanes        -1:0]                                pldrxdigitalreset;

        // Outputs to PLD adjusted for HIP x8 type of placement
        //In placements similar to HIP x8, total_lanes=9.To avoid Quartus warnings, declare the wires
        //that connect to the output of PCS to be total_lanes wide.
        wire [TOTAL_LANES*3-1:0]                        pld8grxstatus;
        wire [TOTAL_LANES*64 -1:0]                      rxdata_to_pld; 
        wire [TOTAL_LANES    -1:0]                      pld8gphystatus;
        wire [TOTAL_LANES    -1:0]                      pld8grxvalid;
        wire [TOTAL_LANES    -1:0]                      pld8grxpolarity;
        wire [TOTAL_LANES    -1:0]                      pld8grxelecidle;
        wire [TOTAL_LANES    -1:0]                      rx_pcfifoempty_to_pld;
        wire [TOTAL_LANES    -1:0]                      rx_pcfifofull_to_pld;
        wire [TOTAL_LANES    -1:0]                      tx_phfifounderflow_to_pld;
        wire [TOTAL_LANES    -1:0]                      tx_phfifooverflow_to_pld;
        wire [TOTAL_LANES    -1:0]                      rx_rlv_to_pld;
        wire [TOTAL_LANES*5  -1:0]                      rx_bitslipboundaryselectout_to_pld;
        wire [TOTAL_LANES    -1:0]                      w_rx_signaldetect;
        wire [TOTAL_LANES    -1:0]                      w_rx_signaldetect_hip;

        // Intermediate wires for non-HIP configuration. These bits are part of the databus to PCS.
        wire [(lanes*SER_WORDS) -1:0]   w_txcompliance_per_word;
        wire [(lanes*SER_WORDS) -1:0]   w_txelecidle_per_word;

        // PLL wires
        wire                                                    pll_fb_wire;
        wire                                                    w_pll_hclk;

        // PLD inputs to PCS/PMA adjusted for HIP x8 configuration
        // with reserved channel
        reg [TOTAL_LANES    -1:0]                       w_rx_analogreset;
        reg [TOTAL_LANES*44 -1:0]               w_pldtxdatain;
        reg [TOTAL_LANES    -1:0]                       w_tx_invpolarity;
        reg [TOTAL_LANES    -1:0]                       w_tx_digitalreset;
        reg [TOTAL_LANES    -1:0]                       w_rx_digitalreset;

        reg [TOTAL_LANES    -1:0]                       w_rx_set_locktoref;
        reg [TOTAL_LANES    -1:0]                       w_pld8gtxelecidle;
        reg [TOTAL_LANES    -1:0]                       w_pld8gtxdetectrxloopback;
        reg [TOTAL_LANES    -1:0]                       w_pld8gtxdeemph;
        reg [TOTAL_LANES    -1:0]                       w_pld8gtxswing;
        reg [TOTAL_LANES    -1:0]                       w_pld8grxpolarity;
        reg [TOTAL_LANES    -1:0]                       w_pldrate;
        reg [TOTAL_LANES*3  -1:0]                       w_pld8gtxmargin;
        reg [TOTAL_LANES*3  -1:0]                       w_pldeidleinfersel;
        reg [TOTAL_LANES*2  -1:0]                       w_pld8gpowerdown;
        // PLD/Pin -> PMA
        wire [TOTAL_LANES  -1:0]                        w_pinrxdatain;
        wire [TOTAL_LANES  -1:0]                        w_pldseriallpbken;
        wire [TOTAL_LANES  -1:0]                        w_pldrxltd;
        // PMA -> PLD/Pin
        wire [TOTAL_LANES  -1:0]                        w_tx_dataout;
        wire [TOTAL_LANES  -1:0]                w_rx_is_lockedtoref;
        wire [TOTAL_LANES  -1:0]                w_rx_is_lockedtodata;


        // This is the clock that is driving pldrxclk and coreclk inputs of the sv_8g_pcs block. 
        // For non-HIP design -- txclkout from the master channel
        // (sv_8g_pcs) must drive into the core (pipe_pclk) and also must
        // loop back into pldrxclk and coreclk inputs of the sv_8g_pcs

        wire  core_rx_clock_into_pcs   = tx_clkout_to_pld[BONDING_MASTER_CH];

        //****************************************************************************************************************
        //PIPE <-> EMSIP adapter for HIP designs and PIPE <-> PLD signals to PCS for non-HIP designs
        //****************************************************************************************************************

       av_xcvr_data_adapter #(
          .lanes           (lanes),
          .ser_base_factor (WORD_SIZE),             //8 for PCIe
          .ser_words       (SER_WORDS),             //1 or 2 
	        .skip_word       ((protocol_version == "Gen 3") ? 1: 2)                      //8G PCS supports up to deser factor of 16
       ) av_xcvr_data_adapter_inst ( 
          .tx_parallel_data      (pipe_txdata),
	        .tx_datak              (pipe_txdatak),
	        .tx_forcedisp          (w_txcompliance_per_word), //Bit 9 in the 11-bit bundle is txcompliance for PIPE. 
	        .tx_dispval            (w_txelecidle_per_word),   //Bit 10 in the 11-bit bundle is txelecidle for PIPE
	        .tx_datain_from_pld    (txdatain_from_pld),
         // The only time lanes!= TOTAL_LANES is in the case of HIP x8 type of placement. RTL simulations are agnostic to QSFs; so number of channels will be still 8 and only in post fit simulations, we observe 9 channels after the QSF kicks in. 
         // This is to avoid any sim warnings
          `ifdef ALTERA_RESERVED_QIS 
          .rx_dataout_to_pld     ((lanes != TOTAL_LANES) ? {rxdata_to_pld[575:320],rxdata_to_pld[255:0]} : rxdata_to_pld), //for x8 designs with reserved, ignore the rxdata on reserved.  
          `else 
          .rx_dataout_to_pld     (rxdata_to_pld),
          `endif
	        .rx_parallel_data      (pipe_rxdata),
	        .rx_datak              (pipe_rxdatak),
	        .rx_errdetect          (rx_errdetect),
	        .rx_syncstatus         (rx_syncstatus),
	        .rx_disperr            (rx_disperr),
	        .rx_patterndetect      (rx_patterndetect),
	        .rx_rmfifodatainserted (),                 //Not used for PIPE
	        .rx_rmfifodatadeleted  (),                 //Not used for PIPE
	        .rx_runningdisp        (),                 //Not used for PIPE 
	        .rx_a1a2sizeout        ()                  //Not used for PIPE 
       );

       // Also , assign tx_compliance and tx_elecidle per word for the data adapter.
       // These inputs are 1-bit per lane. Bit 9 and 10 in the 11-bit bundle of data into PCS 
       // mean tx_forcedisp and tx_dispval for other protocols. For PIPE, these bits mean 
       // tx_compliance and tx_elecidle respectively. tx_forcedisp and tx_dispval are defined per 
       // lane and per word. So, in order for the data adapter to interleave the bits correctly per lane,
       //extend tx_compliance and tx_elecidle per lane for all the words in that lane.
       genvar num_ch;
       genvar num_word;
       generate
       for (num_ch=0; num_ch < lanes; num_ch = num_ch + 1) begin:channel
         for (num_word=0; num_word < SER_WORDS; num_word=num_word+1) begin:word
           assign w_txcompliance_per_word [SER_WORDS*num_ch+num_word] = pipe_txcompliance[num_ch];		 
           assign w_txelecidle_per_word   [SER_WORDS*num_ch+num_word] = pipe_txelecidle  [num_ch];		 
         end  
       end  
       endgenerate

       assign pldrate                 = pipe_rate;
       assign pld8gpowerdown          = pipe_powerdown;
       assign pld8gtxdetectrxloopback = pipe_txdetectrx_loopback;
       assign pld8gtxmargin           = pipe_txmargin;
       assign pldeidleinfersel        = rx_eidleinfersel;
       assign pld8gtxdeemph           = pipe_txdeemph;
       assign pld8gtxswing            = pipe_txswing;
       assign pld8grxpolarity         = pipe_rxpolarity;
       assign pld8gtxelecidle         = pipe_txelecidle;

       assign pldtxinvpolarity        = tx_invpolarity;
       assign pldltr                  = rx_set_locktoref;

       assign pldrxanalogreset        = rx_analogreset;
       assign pldtxdigitalreset       = tx_digitalreset;
       assign pldrxdigitalreset       = rx_digitalreset;

generate 
  if (lanes == TOTAL_LANES) // for designs with no reserved 
  begin 
       assign w_rx_analogreset                 = pldrxanalogreset;
       assign w_tx_digitalreset                = pldtxdigitalreset;
       assign w_rx_digitalreset                = pldrxdigitalreset;
       assign w_tx_invpolarity                 = pldtxinvpolarity;
       assign w_rx_set_locktoref               = pldltr;
       assign w_pld8gtxelecidle                = pld8gtxelecidle;
       assign w_pld8gtxdetectrxloopback        = pld8gtxdetectrxloopback;
       assign w_pld8gtxdeemph                  = pld8gtxdeemph;
       assign w_pld8gtxswing                   = pld8gtxswing;
       assign w_pld8grxpolarity                = pld8grxpolarity;
       assign w_pldrate                        = pldrate;
       assign w_pld8gtxmargin                  = pld8gtxmargin;
       assign w_pldeidleinfersel               = pldeidleinfersel;
       assign w_pld8gpowerdown                 = pld8gpowerdown;
       assign w_pldtxdatain                    = txdatain_from_pld;
       // PLD -> PMA inputs
       assign w_pinrxdatain                    = rx_serial_data;
       assign w_pldseriallpbken                = rx_seriallpbken;
       assign w_pldrxltd                       = rx_set_locktodata;
       // PMA -> PLD outputs
       assign tx_serial_data                   = w_tx_dataout;
       assign rx_is_lockedtoref                = w_rx_is_lockedtoref;
       assign rx_is_lockedtodata               = w_rx_is_lockedtodata;
       assign rx_signaldetect                  = w_rx_signaldetect;
       // Outputs
       assign pipe_phystatus                   = pld8gphystatus;
       assign pipe_rxstatus                    = pld8grxstatus;
       assign pipe_rxvalid                     = pld8grxvalid;
       assign pipe_rxelecidle                  = pld8grxelecidle;
       assign pipe_pclk                        = tx_clkout_to_pld[BONDING_MASTER_CH]; // just use ch0 as pclk when not using HIP
       assign rx_phase_comp_fifo_error	       = rx_pcfifoempty_to_pld | rx_pcfifofull_to_pld;
       assign tx_phase_comp_fifo_error	       = tx_phfifooverflow_to_pld | tx_phfifounderflow_to_pld;
       assign rx_rlv                           = rx_rlv_to_pld;
       assign rx_bitslipboundaryselectout      = rx_bitslipboundaryselectout_to_pld;
  end
  else // for x8 HIP compatible placement or any x8 designs with reserved ch 
  begin 
      assign w_rx_analogreset[8:5]            = pldrxanalogreset [7:4];
      assign w_rx_analogreset[4]              = 1'b0;
      assign w_rx_analogreset[3:0]            = pldrxanalogreset [3:0];

      assign w_tx_digitalreset                = {pldtxdigitalreset[7:4],pldtxdigitalreset[0],pldtxdigitalreset[3:0]};
      assign w_rx_digitalreset                = {pldrxdigitalreset[7:4],pldrxdigitalreset[0],pldrxdigitalreset[3:0]};
      assign w_tx_invpolarity                 = {pldtxinvpolarity       [7:4],   1'b0,pldtxinvpolarity        [3:0]};
      assign w_rx_set_locktoref               = {pldltr                 [7:4],   1'b0,pldltr                  [3:0]};
      assign w_pld8gtxelecidle                = {pld8gtxelecidle        [7:4],   1'b0,pld8gtxelecidle         [3:0]};
      assign w_pld8gtxdetectrxloopback        = {pld8gtxdetectrxloopback[7:4],   1'b0,pld8gtxdetectrxloopback [3:0]};
      assign w_pld8gtxdeemph                  = {pld8gtxdeemph          [7:4],   1'b0,pld8gtxdeemph           [3:0]};
      assign w_pld8gtxswing                   = {pld8gtxswing           [7:4],   1'b0,pld8gtxswing            [3:0]};
      assign w_pld8grxpolarity                = {pld8grxpolarity        [7:4],   1'b0,pld8grxpolarity         [3:0]};
      assign w_pldrate                        = {pldrate          [7:4],   pldrate[0],pldrate             [3:0]};
      assign w_pld8gtxmargin                  = {pld8gtxmargin    [8*3-1:4*3],   3'b0,pld8gtxmargin       [4*3-1:0]};
      assign w_pldeidleinfersel               = {pldeidleinfersel [8*3-1:4*3],   3'b0,pldeidleinfersel    [4*3-1:0]};
      assign w_pld8gpowerdown                 = {pld8gpowerdown   [8*2-1:4*2],   2'b0,pld8gpowerdown      [4*2-1:0]};
      assign w_pldtxdatain                    = {txdatain_from_pld[8*44-1:4*44],44'b0,txdatain_from_pld  [4*44-1:0]};
      // PLD -> PMA inputs
      assign w_pinrxdatain                    = {rx_serial_data[7:4],1'b0,rx_serial_data[3:0]};
      assign w_pldseriallpbken                = {rx_seriallpbken[7:4],1'b0,rx_seriallpbken[3:0]};
      assign w_pldrxltd                       = {rx_set_locktodata[7:4],1'b0,rx_set_locktodata[3:0]};
      // PMA -> PLD outputs: interleave channel 4
      assign tx_serial_data                   = {w_tx_dataout[8:5],w_tx_dataout[3:0]};
      assign rx_is_lockedtoref                = {w_rx_is_lockedtoref[8:5],w_rx_is_lockedtoref[3:0]};
      assign rx_is_lockedtodata               = {w_rx_is_lockedtodata[8:5],w_rx_is_lockedtodata[3:0]};
      assign rx_signaldetect                  = {w_rx_signaldetect[8:5],w_rx_signaldetect[3:0]};
      
      assign pipe_phystatus                   = {pld8gphystatus[8:5],pld8gphystatus[3:0]};
      assign pipe_rxstatus                    = {pld8grxstatus[26:15],pld8grxstatus[11:0]} ;
      assign pipe_rxvalid                     = {pld8grxvalid[8:5],pld8grxvalid[3:0]};
      assign pipe_rxelecidle                  = {pld8grxelecidle[8:5],pld8grxelecidle[3:0]};
      assign pipe_pclk                        = tx_clkout_to_pld[BONDING_MASTER_CH]; // just use ch0 as pclk when not using HIP
      assign rx_phase_comp_fifo_error	        = {(rx_pcfifoempty_to_pld[8:5] | rx_pcfifofull_to_pld[8:5]),(rx_pcfifoempty_to_pld[3:0] | rx_pcfifofull_to_pld[3:0])};
      assign tx_phase_comp_fifo_error	        = {(tx_phfifooverflow_to_pld[8:5] | tx_phfifounderflow_to_pld[8:5]), (tx_phfifooverflow_to_pld[3:0] | tx_phfifounderflow_to_pld[3:0])};
      assign rx_rlv                           = {rx_rlv_to_pld[8:5],rx_rlv_to_pld[3:0]};
      assign rx_bitslipboundaryselectout      = {rx_bitslipboundaryselectout_to_pld[44:25],rx_bitslipboundaryselectout_to_pld[19:0]};

  end
endgenerate 
        //*****************************************************************************************************************
        // Instantiate Tx PLL
        //*****************************************************************************************************************
        //Tx PLL
        // Connect either the active-high pll_powerdown from core to PLL rst for all cases except the HIP with Hard reset controller. If Channel PLL is used, the reset is internally inverted by the PLL.
        // Connect the active-low rxpmarstb input for the CMU channel from the HIP in the hard reset controller mode. It is inverted here because the PLL expects an active-high polarity on this signal.
        // Both the above signals get connected to rx_pma_rstb port of the CMU or the channel PLL (whether it is a CMU channel or a regular Rx channel respectively)
        assign w_rst_to_tx_pll                  = pll_powerdown;

    //*********************************************************
    // Tx PLL Comp Feedback ports for the Tx PLLs from the CGB
    //*********************************************************
    // Make the connection only for Gen3 x8 with Tx PLL Comp Fb. Tie-off to 0 for other configurations. 
    //Tie-off the ports to '0' for other configurations. 
//    assign w_pll_tx_pcie_fb_clk    = {NUM_TX_PLLS{1'b0}};
//    assign w_pll_tx_pll_fb_sw      = {NUM_TX_PLLS{1'b0}};
      

        // Same for pll locked. Explicitely interleave the CMU channel. This is done below where sv_xcvr_emsip_adapter is instantiated.

// needs investigation - check parameters and settings
        av_xcvr_plls #(
                .plls                           (NUM_TX_PLLS                                            ), //1 Tx PLL for x1,x4,x8 Gen1/Gen2
                .reference_clock_frequency      (pll_refclk_freq                                        ),
                .output_clock_frequency         ((protocol_version == "Gen 1") ? "1250 Mhz":
                                                 (protocol_version == "Gen 2") ? "2500 MHz":"<invalid>" ),
                .refclks                        (1                                                      ),
                .enable_avmm                    (0                                                      ),   //TODO temporary
                .enable_hclk                    ((hip_enable== "true") ? 1 : 0                          )
        )
        av_xcvr_tx_pll_inst
        (
                .refclk                                 (pll_ref_clk        ),
                .rst                                    (w_rst_to_tx_pll    ),
                .fbclk                                  (pll_fb_wire        ),
                .fboutclk                               (pll_fb_wire        ),
                .outclk                                 (pll_out            ),
                .hclk                                   (w_pll_hclk         ),
                .locked                                 (pll_locked         ),
                // avalon MM native reconfiguration interfaces
                .reconfig_to_xcvr    (reconfig_to_xcvr  [(TOTAL_LANES)*W_BUNDLE_TO_XCVR+:NUM_TX_PLLS*W_BUNDLE_TO_XCVR]     ),
                .reconfig_from_xcvr  (reconfig_from_xcvr[(TOTAL_LANES)*W_BUNDLE_FROM_XCVR+:NUM_TX_PLLS*W_BUNDLE_FROM_XCVR] )
        );

        //*****************************************************************************************************************
        // Instantiate av_xcvr_native
        //*****************************************************************************************************************
        av_xcvr_native #(
                //*********************************************
                // PMA parameters
                //*********************************************
                .device_family                  (device_family), 
                .rx_enable                      (1),                                    // (1,0) Enable or disable reciever PMA
                .tx_enable                      (1),                                    // (1,0) Enable or disable transmitter PMA
                .bonded_lanes                   (TOTAL_LANES),                  // Number of bonded lanes
                .bonding_master_ch              (BONDING_MASTER_CH),     // Indicates which channel is master
                .pma_bonding_master             (PMA_BONDING_MASTER),   // Indicates which PMA channel is master
                .bonding_master_only            (BONDING_MASTER_ONLY),  // Indicates bonding_master_channel is MASTER_ONLY
                .channel_number                 (starting_channel_number),
                .pma_prot_mode                  (PROT_MODE),                     // (basic,cpri,cpri_rx_tx,disabled_prot_mode,gige,
                                                                                                                //  pipe_g1,pipe_g2,pipe_g3,srio_2p1,test,xaui)
                .pma_mode                       (PMA_MODE),                     // (8,10,16,20,32,40,64,80) Serialization factor
                .pma_data_rate                  (PMA_DATA_RATE),                // Serial data rate in bits-per-second
                .cdr_reference_clock_frequency  (pll_refclk_freq),
                .auto_negotiation               (PMA_AUTO_NEGOTIATION),    // ("true","false") PCIe Auto-Negotiation (Gen1,2,3)
                .sd_on                          (1),                                // (0,1,2...16) Signal Detect Threshold. 0->DATA_PULSE_4, 1->DATA_PULSE_6,....,16->FORCE_SD_ON
                .pdb_sd                         ("false"),
                .deser_enable_bit_slip          ("true"),
                //*********************************************
                // PCS parameters
                //*********************************************

                .enable_8g_rx                   ("true"),
                .enable_8g_tx                   ("true"),
                .enable_dyn_reconfig            ("false"),
                .enable_gen12_pipe              ("true"),


                //*********************************************
                // Parameters for arriav_hssi_8g_rx_pcs
                //*********************************************
                //.pcs8g_rx_auto_deassert_pc_rst_cnt_data (5'h14),
                //      .pcs8g_rx_auto_error_replacement      ("<auto_single>"),                                // dis_err_replace|en_err_replace. RBC = en_err_replace
                //.pcs8g_rx_auto_pc_en_cnt_data                 (7'h34),
                //      .pcs8g_rx_auto_speed_nego               ("<auto_single>"),                              // dis_asn|en_asn_g2_freq_scal
                .pcs8g_rx_bit_reversal                                  ("dis_bit_reversal"),                                   // dis_bit_reversal|en_bit_reversal //RBC = dis_bit_reversal
                .pcs8g_rx_byte_deserializer                             (PCS8G_RX_BYTE_DESERIALIZER),   // dis_bds|en_bds_by_2|en_bds_by_4|en_bds_by_2_det
                .pcs8g_rx_cdr_ctrl                                      ("en_cdr_ctrl_w_cid"),                          // dis_cdr_ctrl|en_cdr_ctrl|en_cdr_ctrl_w_cid
                .pcs8g_rx_cdr_ctrl_rxvalid_mask                         ("en_rxvalid_mask"),                            // dis_rxvalid_mask|en_rxvalid_mask

                // The following 3 attributes enable detection of elec idle due to one or more of the following 3 reasons:
                // Reception of EIOS, Elec Idle Inference, Deassertion of Signal Detect from PMA
                .pcs8g_rx_eidle_entry_eios                              ("en_eidle_eios"),                                      // dis_eidle_eios|en_eidle_eios
                .pcs8g_rx_eidle_entry_iei                               (ELEC_IDLE_INFER),                              // dis_eidle_iei|en_eidle_iei
                .pcs8g_rx_eidle_entry_sd                                (ELEC_IDLE_ENTRY_SD),                   // dis_eidle_sd|en_eidle_sd
                //      .pcs8g_rx_eightb_tenb_decoder           ("<auto_single>"),                              // dis_8b10b|en_8b10b_ibm|en_8b10b_sgx. RBC = en_8b10b_ibm
                //      .pcs8g_rx_eightbtenb_decoder_output_sel ("<auto_single>"),                              // data_8b10b_decoder|data_xaui_sm.     RBC = data_8b10b_decoder
                //      .pcs8g_rx_err_flags_sel                         ("<auto_single>"),                              // err_flags_wa|err_flags_8b10b.        RBC = err_flags_wa
                //      .pcs8g_rx_fixed_pat_det                         ("<auto_single>"),                              // dis_fixed_patdet|en_fixed_patdet. RBC = dis_fixed_pat_det
                // ICD RBC mentions temporary rule..

                //      .pcs8g_rx_fixed_pat_num                         (4'b1111),
                //      .pcs8g_rx_force_signal_detect           ("<auto_single>"),                              // en_force_signal_detect|dis_force_signal_detect. RBC = en_force_signal_detect
                .pcs8g_rx_hip_mode                                      (HIP_MODE),                                             // dis_hip|en_hip

                //      .pcs8g_rx_ibm_invalid_code              ("<auto_single>"),                              // dis_ibm_invalid_code|en_ibm_invalid_code. RBC = dis_ibm_invalid_code
                .pcs8g_rx_invalid_code_flag_only        		("dis_invalid_code_only"),                              // dis_invalid_code_only|en_invalid_code_only. RBC = dis_invalid_code_only

                .pcs8g_rx_mask_cnt                                      (10'd800),                                              // default = 10'h3FF
                //      .pcs8g_rx_pad_or_edb_error_replace      ("<auto_single>"),                              // replace_edb|replace_pad|replace_edb_dynamic. RBC=replace_edb_dynamic.
                //      .pcs8g_rx_pcs_bypass                            ("<auto_single>"),                              // dis_pcs_bypass|en_pcs_bypass. RBC = dis_pcs_bypass
                .pcs8g_rx_phase_compensation_fifo                       (PCS8G_PC_FIFO),                                // low_latency|normal_latency|register_fifo|pld_ctrl_low_latency|pld_ctrl_normal_latency

                .pcs8g_rx_pipe_if_enable                                ("en_pipe_rx"),                                         // dis_pipe_rx|en_pipe_rx
                .pcs8g_rx_pma_done_count                                (PMA_DONE_CNTR),
                .pcs8g_rx_pma_dw                                        (PMA_DW),                                               // eight_bit|ten_bit|sixteen_bit|twenty_bit
                //      .pcs8g_rx_polarity_inversion            ("<auto_single>"),                                      // dis_pol_inv|en_pol_inv. RBC = dis_pol_inv
                //      .pcs8g_rx_polinv_8b10b_dec              ("<auto_single>"),                              // dis_polinv_8b10b_dec|en_polinv_8b10b_dec. RBC = en_polinv_8b10b_dec

                .pcs8g_rx_prot_mode                                     (PROT_MODE),                                    // pipe_g1|pipe_g2|pipe_g3|
                                                                                                                                                                // cpri|cpri_rx_tx|gige|xaui|srio_2p1|test|basic|disabled_prot_mode
                .pcs8g_rx_rate_match                                    (RATE_MATCH),                                   // dis_rm|xaui_rm|gige_rm|pipe_rm|pipe_rm_0ppm|sw_basic_rm|
                                                                                                                                                                // srio_v2p1_rm|srio_v2p1_rm_0ppm|dw_basic_rm
                //      .pcs8g_rx_re_bo_on_wa                   ("<auto_single>"),                              // dis_re_bo_on_wa|en_re_bo_on_wa. RBC = dis_re_bo_on_wa

                .pcs8g_rx_runlength_check                               (RUN_LENGTH),                                   // dis_runlength|en_runlength_sw|en_runlength_dw
                .pcs8g_rx_runlength_val                                 (RUNLENGTH_VALUE),

                //      .pcs8g_rx_rx_clk1                                       ("<auto_single>"),                              // rcvd_clk_clk1|tx_pma_clock_clk1|rcvd_clk_agg_clk1|
                                                                                                                                                                // rcvd_clk_agg_top_or_bottom_clk1. RBC = rcvd_clk_clk1.

                //      .pcs8g_rx_rx_clk2                                       ("<auto_single>"),                              // rcvd_clk_clk2|tx_pma_clock_clk2|refclk_dig2_clk2.
                                                                                                                                                                // RBC = tx_pma_clock_clk2
                //      .pcs8g_rx_rx_clk_free_running           ("<auto_single>"),                              // dis_rx_clk_free_run|en_rx_clk_free_run
                                                                                                                                                                // RBC = en_rx_clk_free_run

                //      .pcs8g_rx_rx_pcs_urst                           ("<auto_single>"),                                      // dis_rx_pcs_urst|en_rx_pcs_urst
                                                                                                                                                                // RBC = en_rx_pcs_urst
                //      .pcs8g_rx_rx_rcvd_clk                                   ("<auto_single>"),                              // rcvd_clk_rcvd_clk|tx_pma_clock_rcvd_clk
                                                                                                                                                                // RBC = rcvd_clk_rcvd_clk if parallel loopbk is not enabled.
                .pcs8g_rx_rx_rd_clk                                     ("pld_rx_clk"),                                             // non-hip mode
                .pcs8g_rx_rx_wr_clk                                     ("rx_clk2_div_1_2_4"),                                      // non-hip mode
                //      .pcs8g_rx_symbol_swap                                   ("<auto_single>"),                              // dis_symbol_swap|en_symbol_swap. RBC = dis_symbol_swap
                //      .pcs8g_rx_test_bus_sel                          ("<auto_single>"),                              // prbs_bist_testbus|tx_testbus|tx_ctrl_plane_testbus|wa_testbus|
                                                                                                                                                                        // deskew_testbus|rm_testbus|rx_ctrl_testbus|pcie_ctrl_testbus|
                                                                                                                                                                        // rx_ctrl_plane_testbus|agg_testbus. RBC = tx_testbus
                //      .pcs8g_rx_test_mode                             ("<auto_single>"),                              // dont_care_test|prbs|bist. RBC = dont_care_test
                //      .pcs8g_rx_tx_rx_parallel_loopback       ("<auto_single>"),                              // dis_plpbk|en_plpbk. RBC = dis_plpbk. Enable it for debug.

                .pcs8g_rx_wa_boundary_lock_ctrl                         ("sync_sm"),                                            // bit_slip|sync_sm|deterministic_latency|auto_align_pld_ctrl
                //      .pcs8g_rx_wa_clk_slip_spacing           ("<auto_single>"),                                      // min_clk_slip_spacing|user_programmable_clk_slip_spacing. RBC=min_clk_slip_spacing
                //      .pcs8g_rx_wa_clk_slip_spacing_data      (10'b10000),                                            // default
                //      .pcs8g_rx_wa_det_latency_sync_status_beh ("<auto_single>"),                             // assert_sync_status_imm|assert_sync_status_non_imm|dont_care_assert_sync
                                        // RBC
                                        // = dont_care_assert_sync

                //      .pcs8g_rx_wa_disp_err_flag                      ("<auto_single>"),                              // dis_disp_err_flag|en_disp_err_flag. RBC = "en_disp_err_flag"
                //      .pcs8g_rx_wa_kchar                              ("<auto_single>"),                              // dis_kchar|en_kchar. RBC = dis_kchar
                .pcs8g_rx_wa_pd                                         ("wa_pd_fixed_10_k28p5"),                       // RBC = wa_pd_fixed_10_k28p5
                .pcs8g_rx_wa_pd_data                                    (40'hBC),
                //      .pcs8g_rx_wa_pd_polarity                        ("<auto_single>"),                              // dis_pd_both_pol|en_pd_both_pol|dont_care_both_pol. RBC = dont_care_both_pol
                .pcs8g_rx_wa_pld_controlled                             ("dis_pld_ctrl"),                                       // dis_pld_ctrl|pld_ctrl_sw|rising_edge_sensitive_dw|level_sensitive_dw. RBC=dis_pld_ctrl
                .pcs8g_rx_wa_sync_sm_ctrl                               ("pipe_sync_sm"),
                .pcs8g_rx_wait_cnt                                      (8'b00111111),
                //.pcs8g_rx_wait_for_phfifo_cnt_data            (6'd32),
                .pcs8g_rx_sup_mode                                      ("user_mode"),

                //*********************************************
                // parameters for arriav_hssi_8g_tx_pcs
                //*********************************************
                //      .pcs8g_tx_auto_speed_nego_gen2          ("<auto_single>"),                      //dis_asn_g2|en_asn_g2_freq_scal
                .pcs8g_tx_bit_reversal                                  ("dis_bit_reversal"),                   // dis_bit_reversal|en_bit_reversal
                //      .pcs8g_tx_bypass_pipeline_reg                   ("<auto_single>"),                      // dis_bypass_pipeline|en_bypass_pipeline. RBC = dis_bypass_pipeline
                .pcs8g_tx_byte_serializer                               (PCS8G_TX_BYTE_SERIALIZER),     // dis_bs|en_bs_by_2|en_bs_by_4

                //      .pcs8g_tx_dynamic_clk_switch                    = "<auto_single>",                      // dis_dyn_clk_switch|en_dyn_clk_switch .
                                                                                                                                                                        // RBC = en_dyn_clk_switch if tx_prot_mode=pipe_g3
                .pcs8g_tx_eightb_tenb_disp_ctrl                         ("en_disp_ctrl"),                                       // dis_disp_ctrl|en_disp_ctrl|en_ib_disp_ctrl
                .pcs8g_tx_eightb_tenb_encoder                           ("en_8b10b_ibm"),                       // dis_8b10b|en_8b10b_ibm|en_8b10b_sgx
                //      .pcs8g_tx_force_echar                                   ("<auto_single>"),                      // dis_force_echar|en_force_echar. RBC = dis
                //      .pcs8g_tx_force_kchar                                   ("<auto_single>"),                      // dis_force_kchar|en_force_kchar. RBC = dis
                .pcs8g_tx_hip_mode                                      (HIP_MODE),                                     // dis_hip|en_hip
                .pcs8g_tx_pcs_bypass                                    ("dis_pcs_bypass"),                     // dis_pcs_bypass|en_pcs_bypass
                .pcs8g_tx_phase_compensation_fifo                       (PCS8G_PC_FIFO),                        // low_latency|normal_latency|register_fifo|pld_ctrl_low_latency|pld_ctrl_normal_latency
                .pcs8g_tx_phfifo_write_clk_sel                          ("pld_tx_clk"),                                 // pld_tx_clk|tx_clk
                .pcs8g_tx_pma_dw                                        (PMA_DW),                                       // eight_bit|ten_bit|sixteen_bit|twenty_bit
                .pcs8g_tx_polarity_inversion                            ("dis_polinv"),                                 // dis_polinv|enable_polinv
                .pcs8g_tx_prbs_gen                                      ("dis_prbs"),
                .pcs8g_tx_prot_mode                                     (PROT_MODE),                            // pipe_g1|pipe_g2|pipe_g3|cpri|cpri_rx_tx|gige|xaui|srio_2p1|test|basic|disabled_prot_mode
                //      .pcs8g_tx_refclk_b_clk_sel                              ("<auto_single>"),                      // tx_pma_clock|refclk_dig. RBC = tx_pma_clk in user mode.
                //      .pcs8g_tx_revloop_back_rm                       ("<auto_single>")                               // dis_rev_loopback_rx_rm|en_rev_loopback_rx_rm. RBC = en_rev_loopback_rm always for pipe. Clarify with ICD
                .pcs8g_tx_symbol_swap                                   ("dis_symbol_swap"),                    // dis_symbol_swap|en_symbol_swap
                .pcs8g_tx_test_mode                                     ("dont_care_test"),                     // dont_care_test|prbs|bist
                .pcs8g_tx_tx_bitslip                                    ("dis_tx_bitslip"),                             // dis_tx_bitslip|en_tx_bitslip
                .pcs8g_tx_tx_compliance_controlled_disparity            (PCS8G_TX_COMPL_CONTR_DISP),       // dis_txcompliance|en_txcompliance_pipe2p0|en_txcompliance_pipe3p0
                //      .pcs8g_tx_txclk_freerun                                 ("<auto_single>"),                      // dis_freerun_tx|en_freerun_tx. RBC = en_freerun_tx
                //      .pcs8g_tx_txpcs_urst                                    ("<auto_single>"),                      // dis_txpcs_urst|en_txpcs_urst. RBC = en_txpcs_urst
                .pcs8g_tx_sup_mode                                      ("user_mode"),

                //*********************************************
                // parameters for arriav_hssi_pipe_gen1_2
                //*********************************************
                .pipe12_elec_idle_delay_val                             (3'b011),
                .pipe12_elecidle_delay                                  ("elec_idle_delay"),            // elec_idle_delay
                //      .pipe12_error_replace_pad                               ("<auto_single>"),              // replace_edb|replace_pad. RBC = replace_edb
                .pipe12_hip_mode                                        (HIP_MODE),                     // dis_hip|en_hip
                .pipe12_ind_error_reporting                             ("dis_ind_error_reporting"),    // dis_ind_error_reporting|en_ind_error_reporting
                .pipe12_phy_status_delay                                ("phystatus_delay"),            // phystatus_delay
                .pipe12_phystatus_delay_val                             (3'b0),
                //      .pipe12_phystatus_rst_toggle                    ("<auto_single>"),      // dis_phystatus_rst_toggle|en_phystatus_rst_toggle. RBC = dis_phystatus_rst_toggle
                .pipe12_pipe_byte_de_serializer_en                      (PIPE12_BYTE_DESERIALIZER_EN),            // dis_bds|en_bds_by_2|dont_care_bds
                .pipe12_prot_mode                                       (PROT_MODE),    // pipe_g1|pipe_g2|pipe_g3|cpri|cpri_rx_tx|gige|xaui|srio_2p1|test|basic|disabled_prot_mode
                .pipe12_rpre_emph_a_val                                 (pipe12_rpre_emph_a_val),
                .pipe12_rpre_emph_b_val                                 (pipe12_rpre_emph_b_val),
                .pipe12_rpre_emph_c_val                                 (pipe12_rpre_emph_c_val),
                .pipe12_rpre_emph_d_val                                 (pipe12_rpre_emph_d_val),
                .pipe12_rpre_emph_e_val                                 (pipe12_rpre_emph_e_val),
                .pipe12_rpre_emph_settings                              (6'b0),
                .pipe12_rvod_sel_a_val                                  (pipe12_rvod_sel_a_val),
                .pipe12_rvod_sel_b_val                                  (pipe12_rvod_sel_b_val),
                .pipe12_rvod_sel_c_val                                  (pipe12_rvod_sel_c_val),
                .pipe12_rvod_sel_d_val                                  (pipe12_rvod_sel_d_val),
                .pipe12_rvod_sel_e_val                                  (pipe12_rvod_sel_e_val),
                .pipe12_rvod_sel_settings                               (6'b0),
                .pipe12_rx_pipe_enable                                  ("en_pipe_rx"),         // dis_pipe_rx|en_pipe_rx
                .pipe12_rxdetect_bypass                                 ("dis_rxdetect_bypass"), // dis_rxdetect_bypass|en_rxdetect_bypass
                .pipe12_tx_pipe_enable                                  ("en_pipe_tx"),         // dis_pipe_tx|en_pipe_tx
                .pipe12_txswing                                         ("en_txswing"),        // dis_txswing|en_txswing



                //*******************************************************
                // parameters for arriav_hssi_common_pcs_pma_interface
                //*******************************************************

                .com_pcs_pma_if_auto_speed_ena          ((protocol_version == "Gen 2") ? "en_auto_speed_ena" : "dis_auto_speed_ena"),        // dis_auto_speed_ena|en_auto_speed_ena. RBC = en_auto_speed_ena for pipe_g2 and pipe_g3 modes
                //      .com_pcs_pma_if_force_freqdet                   ("<auto_single>"),              // force_freqdet_dis|force1_freqdet_en|force0_freqdet_en. RBC=force_freqdet_dis
                .com_pcs_pma_if_func_mode                               ("eightg_only_pld"),
                // disable|pma_direct|hrdrstctrl_cmu|eightg_only_pld|eightg_only_hip|
                //      .com_pcs_pma_if_pcie_gen3_cap                   ("<auto_single>"),        // pcie_gen3_cap|non_pcie_gen3_cap //TODO for Gen3
                // teng_only|eightgtx_and_tengrx|eightgrx_and_tengtx
                .com_pcs_pma_if_pipe_if_g3pcs                           ("pipe_if_8gpcs"),              // pipe_if_8gpcs
                //      .com_pcs_pma_if_ppm_cnt_rst                     ("<auto_single>"),      // ppm_cnt_rst_dis|ppm_cnt_rst_en
                .com_pcs_pma_if_ppm_deassert_early                      ("deassert_early_dis"),      // deassert_early_dis|deassert_early_en
                .com_pcs_pma_if_ppm_gen1_2_cnt                          ("cnt_32k"),      // cnt_32k|cnt_64k
                .com_pcs_pma_if_ppm_post_eidle_delay                    ("cnt_200_cycles"),     // cnt_200_cycles|cnt_400_cycles
                .com_pcs_pma_if_ppmsel                                  ("ppmsel_300"),                 // ppmsel_default|ppmsel_1000|ppmsel_500|ppmsel_300|ppmsel_250|ppmsel_200|ppmsel_125|ppmsel_100|ppmsel_62p5|ppm_other


                .com_pcs_pma_if_prot_mode                               (PROT_MODE),       // disabled_prot_mode|pipe_g1|pipe_g2|other_protocols
                .com_pcs_pma_if_selectpcs                               ("eight_g_pcs"), // eight_g_pcs
                .com_pcs_pma_if_sup_mode                                ("user_mode"),

                //*******************************************************
                // parameters for arriav_hssi_common_pld_pcs_interface
                //*******************************************************
                .com_pld_pcs_if_hip_enable                      ("hip_disable"),         // hip_disable|hip_enable
                .com_pld_pcs_if_pld_side_data_source            ("pld"),                        // hip|pld
                .com_pld_pcs_if_hrdrstctrl_en_cfg               (HRDRSTCTRL_EN_CFG),       // hrst_dis_cfg|hrst_en_cfg
                .com_pld_pcs_if_hrdrstctrl_en_cfgusr            (HRDRSTCTRL_EN_CFGUSR), // hrst_dis_cfgusr|hrst_en_cfgusr
                .com_pld_pcs_if_pld_side_reserved_source0       ("pld_res0"),           // pld_res0|hip_res0
                .com_pld_pcs_if_pld_side_reserved_source1       ("pld_res1"),           // pld_res1|hip_res1
                .com_pld_pcs_if_pld_side_reserved_source10      ("pld_res10"),          // pld_res10|hip_res10
                .com_pld_pcs_if_pld_side_reserved_source11      ("pld_res11"),          // pld_res11|hip_res11
                .com_pld_pcs_if_pld_side_reserved_source2       ("pld_res2"),           // pld_res2|hip_res2
                .com_pld_pcs_if_pld_side_reserved_source3       ("pld_res3"),           // pld_res3|hip_res3
                .com_pld_pcs_if_pld_side_reserved_source4       ("pld_res4"),           // pld_res4|hip_res4
                .com_pld_pcs_if_pld_side_reserved_source5       ("pld_res5"),           // pld_res5|hip_res5
                .com_pld_pcs_if_pld_side_reserved_source6       ("pld_res6"),           // pld_res6|hip_res6
                .com_pld_pcs_if_pld_side_reserved_source7       ("pld_res7"),           // pld_res7|hip_res7
                .com_pld_pcs_if_pld_side_reserved_source8       ("pld_res8"),           // pld_res8|hip_res8
                .com_pld_pcs_if_pld_side_reserved_source9       ("pld_res9"),           // pld_res9|hip_res9
                .com_pld_pcs_if_testbus_sel                     ("eight_g_pcs"),        // eight_g_pcs|pma_if.
                .com_pld_pcs_if_usrmode_sel4rst                 ("usermode"),   // usermode|last_frz

                //*******************************************************
                // parameters for arriav_hssi_rx_pcs_pma_interface
                //*******************************************************
                .rx_pcs_pma_if_prot_mode                        ("other_protocols"),    // cpri_8g|other_protocols
                .rx_pcs_pma_if_selectpcs                        ("eight_g_pcs"),                // eight_g_pcs|default
                //*******************************************************
                // parameters for arriav_hssi_rx_pld_pcs_interface
                //*******************************************************
                .rx_pld_pcs_if_pld_side_data_source             ("pld"),

                //*******************************************************
                // parameters for arriav_hssi_tx_pcs_pma_interface
                //*******************************************************
                .tx_pcs_pma_if_selectpcs                        ("eight_g_pcs") ,               // eight_g_pcs|default

                //*******************************************************
                // parameters for arriav_hssi_tx_pld_pcs_interface
                //*******************************************************
                .tx_pld_pcs_if_pld_side_data_source             ("pld")                                 // hip|pld
                //      .tx_pld_pcs_if_is_8g_0ppm       ("false") // false|true
        )
        inst_av_xcvr_native
        (
                // *************************** PMA ports ********************************
                .seriallpbken                                           (w_pldseriallpbken),            // 1 = enable serial loopback
                .rx_crurstn                                             (~w_rx_analogreset),            // CDR analog reset (active low)
                .rx_datain                                              (w_pinrxdatain),                // RX serial data input
                .rx_cdr_ref_clk                                         ({TOTAL_LANES{pll_ref_clk}}),   // Reference clock for CDR
                .rx_ltd                                                 (w_pldrxltd),                   // Force lock-to-data stream
                                // MM port for now
                .rx_is_lockedtodata                                     (w_rx_is_lockedtodata),         // Indicates lock to incoming data rate
                                // Output from PMA to PLD
                .rx_is_lockedtoref                                      (w_rx_is_lockedtoref),          // Indicates lock to reference clock
                                // Output from PMA to PLD
                .tx_rxdetclk                                            (fixedclk),                     // Clock for detection of downstream receiver (125MHz ?)
                .tx_dataout                                             (w_tx_dataout),                 // TX serial data output
                .tx_rstn                                                (~tx_analogreset), //1-bit
                .tx_ser_clk                                             ({TOTAL_LANES{pll_out}}),       // High-speed serial clock from PLL
                .tx_cal_busy                                            (tx_cal_busy),
                .rx_cal_busy                                            (rx_cal_busy),
                // *************************** PCS ports ********************************
//                .tx_pcsrstn                                     (~tx_analogreset),
                .in_agg_align_status                            (/*unused*/),
                .in_agg_align_status_sync_0                     (/*unused*/),
                .in_agg_align_status_sync_0_top_or_bot          (/*unused*/),
                .in_agg_align_status_top_or_bot                 (/*unused*/),
                .in_agg_cg_comp_rd_d_all                        (/*unused*/),
                .in_agg_cg_comp_rd_d_all_top_or_bot             (/*unused*/),
                .in_agg_cg_comp_wr_all                          (/*unused*/),
                .in_agg_cg_comp_wr_all_top_or_bot               (/*unused*/),
                .in_agg_del_cond_met_0                          (/*unused*/),
                .in_agg_del_cond_met_0_top_or_bot               (/*unused*/),
                .in_agg_en_dskw_qd                              (/*unused*/),
                .in_agg_en_dskw_qd_top_or_bot                   (/*unused*/),
                .in_agg_en_dskw_rd_ptrs                         (/*unused*/),
                .in_agg_en_dskw_rd_ptrs_top_or_bot              (/*unused*/),
                .in_agg_fifo_ovr_0                              (/*unused*/),
                .in_agg_fifo_ovr_0_top_or_bot                   (/*unused*/),
                .in_agg_fifo_rd_in_comp_0                       (/*unused*/),
                .in_agg_fifo_rd_in_comp_0_top_or_bot            (/*unused*/),
                .in_agg_fifo_rst_rd_qd                          (/*unused*/),
                .in_agg_fifo_rst_rd_qd_top_or_bot               (/*unused*/),
                .in_agg_insert_incomplete_0                     (/*unused*/),
                .in_agg_insert_incomplete_0_top_or_bot          (/*unused*/),
                .in_agg_latency_comp_0                          (/*unused*/),
                .in_agg_latency_comp_0_top_or_bot               (/*unused*/),
                .in_agg_rcvd_clk_agg                            (/*unused*/),
                .in_agg_rcvd_clk_agg_top_or_bot                 (/*unused*/),
                .in_agg_rx_control_rs                           (/*unused*/),
                .in_agg_rx_control_rs_top_or_bot                (/*unused*/),
                .in_agg_rx_data_rs                              (/*unused*/),
                .in_agg_rx_data_rs_top_or_bot                   (/*unused*/),
                .in_agg_test_so_to_pld_in                       (/*unused*/),
                .in_agg_testbus                                 (/*unused*/),
                .in_agg_tx_ctl_ts                               (/*unused*/),
                .in_agg_tx_ctl_ts_top_or_bot                    (/*unused*/),
                .in_agg_tx_data_ts                              (/*unused*/),
                .in_agg_tx_data_ts_top_or_bot                   (/*unused*/),
                .in_emsip_com_in                                (/*unused*/),
                .in_emsip_rx_special_in                         (/*unused*/),
                .in_emsip_tx_in                                 (/*unused*/),
                .in_emsip_tx_special_in                         (/*unused*/),
                .in_pld_8g_a1a2_size                            ({TOTAL_LANES{1'b0}}),  //Unused
                .in_pld_8g_bitloc_rev_en                        ({TOTAL_LANES{1'b0}}),  //Unused
                .in_pld_8g_bitslip                              ({TOTAL_LANES{1'b0}}),  //Unused
                .in_pld_8g_byte_rev_en                          ({TOTAL_LANES{1'b0}}),  //Unused
                .in_pld_8g_bytordpld                            ({TOTAL_LANES{1'b0}}),  //Unused
                .in_pld_8g_cmpfifourst_n                        ({TOTAL_LANES{1'b1}}),  //Unused
                .in_pld_8g_encdt                                ({TOTAL_LANES{1'b0}}),  //Unused
                .in_pld_8g_phfifourst_rx_n                      ({TOTAL_LANES{1'b1}}),  //Unused
                .in_pld_8g_phfifourst_tx_n                      ({TOTAL_LANES{1'b1}}),  //Unused
                .in_pld_8g_pld_rx_clk                           ({TOTAL_LANES{core_rx_clock_into_pcs}}), //loopback tx_clkout_to_pld
                .in_pld_8g_pld_tx_clk                           ({TOTAL_LANES{core_rx_clock_into_pcs}}), //loopback tx_clkout_to_pld
                .in_pld_8g_polinv_rx                            ({TOTAL_LANES{1'b0}}),  //PIPE listens to pipe_rxpolarity (see rxpolarity port to PCS)
                .in_pld_8g_polinv_tx                            (w_tx_invpolarity),             //from input port and adjusted for HIP x8 reserved channel
                .in_pld_8g_powerdown                            (w_pld8gpowerdown),             //from pipe_powerdown and adjusted for HIP x8 reserved channel
                .in_pld_8g_prbs_cid_en                          (/*unused*/),
                .in_pld_8g_rddisable_tx                         ({TOTAL_LANES{1'b0}}),  //Unused
                .in_pld_8g_rdenable_rmf                         ({TOTAL_LANES{1'b0}}),  //Unused
                .in_pld_8g_rdenable_rx                          (/*unused*/),
                .in_pld_8g_refclk_dig                           (/*unused*/),
                .in_pld_8g_refclk_dig2                          (/*unused*/),
                .in_pld_8g_rev_loopbk                           ({TOTAL_LANES{1'b0}}),   //PIPE if decodes txdetectrxloopback and powerdown to

                                        //determine rev loopbk to PCS. This input is not used for PIPE.
                .in_pld_8g_rxpolarity                           (w_pld8grxpolarity),            //From pipe_rxpolarity and adjusted for HIP x8 reserved channel
                .in_pld_8g_rxurstpcs_n                          (~w_rx_digitalreset),           //Rx digital reset from Reset Cntrlr adjusted for HIP x8 reserved channel
                                        //Invert every bit of this bus

                .in_pld_8g_tx_boundary_sel                      (/*unused*/),                            //bitslipboundaryselect is not used
                .in_pld_8g_tx_data_valid                        ({TOTAL_LANES{4'b0000}}),                //Gen3 signal //TODO for Gen3
                .in_pld_8g_txdeemph                             (w_pld8gtxdeemph),
                .in_pld_8g_txdetectrxloopback                   (w_pld8gtxdetectrxloopback),
                .in_pld_8g_txelecidle                           (w_pld8gtxelecidle),
                .in_pld_8g_txmargin                             (w_pld8gtxmargin),
                .in_pld_8g_txswing                              (w_pld8gtxswing),
                .in_pld_8g_txurstpcs_n                          (~w_tx_digitalreset),                   //Tx digital reset from Reset Cntrlr adjusted for HIP x8 dunny channel
                                        //Invert every bit of this bus

                .in_pld_8g_wrdisable_rx                         ({TOTAL_LANES{1'b0}}),
                .in_pld_8g_wrenable_rmf                         ({TOTAL_LANES{1'b0}}),
                .in_pld_8g_wrenable_tx                          ({TOTAL_LANES{1'b0}}),  //Tied-off to 0 in 2.0.
                .in_pld_agg_refclk_dig                          (/*unused*/),
                .in_pld_eidleinfersel                           (w_pldeidleinfersel),           //From rx_eidleinfersel and adjusted for HIP x8 reserved channel
                .in_pld_ltr                                     (w_rx_set_locktoref),           //From MM port to PCS and then to PMA ltr
                .in_pld_partial_reconfig_in                     ({TOTAL_LANES{1'b1}}),
                .in_pld_pcs_pma_if_refclk_dig                   (/*unused*/),
                .in_pld_rate                                    (w_pldrate),                            //From pipe_rate and adjusted for HIP x8 reserved channel
                .in_pld_reserved_in                             (/*unused*/),
                .in_pld_rx_clk_slip_in                          ({TOTAL_LANES{1'b0}}),
                .in_pld_rxpma_rstb_in                           (~w_rx_analogreset),            //Rx analog reset from Reset Cntrlr adjusted for HIP x8 reserved channel
                                        //Invert every bit of this bus

                .in_pld_scan_mode_n                             ({TOTAL_LANES{1'b1}}),  //Disable scan mode
                .in_pld_scan_shift_n                            ({TOTAL_LANES{1'b1}}),
                .in_pld_sync_sm_en                              ({TOTAL_LANES{1'b1}}),          // This signal enables the sync state machine in the Word aligner. Should always be enabled for PIPE.
                .in_pld_tx_data                                 (w_pldtxdatain),                        //From pipe_txdata,txdatak, txcompliance, txelecidle and adjusted
                                        //for HIP x8 reserved channel

                .in_pma_hclk                                    ({TOTAL_LANES{w_pll_hclk}}),
                .in_pma_reserved_in                             (/*unused*/),
                .in_pma_rx_freq_tx_cmu_pll_lock_in              (w_rx_is_lockedtoref),
                .out_agg_align_det_sync                         (/*unused*/),
                .out_agg_align_status_sync                      (/*unused*/),
                .out_agg_cg_comp_rd_d_out                       (/*unused*/),
                .out_agg_cg_comp_wr_out                         (/*unused*/),
                .out_agg_dec_ctl                                (/*unused*/),
                .out_agg_dec_data                               (/*unused*/),
                .out_agg_dec_data_valid                         (/*unused*/),
                .out_agg_del_cond_met_out                       (/*unused*/),
                .out_agg_fifo_ovr_out                           (/*unused*/),
                .out_agg_fifo_rd_out_comp                       (/*unused*/),
                .out_agg_insert_incomplete_out                  (/*unused*/),
                .out_agg_latency_comp_out                       (/*unused*/),
                .out_agg_rd_align                               (/*unused*/),
                .out_agg_rd_enable_sync                         (/*unused*/),
                .out_agg_refclk_dig                             (/*unused*/),
                .out_agg_running_disp                           (/*unused*/),
                .out_agg_rxpcs_rst                              (/*unused*/),
                .out_agg_scan_mode_n                            (/*unused*/),
                .out_agg_scan_shift_n                           (/*unused*/),
                .out_agg_sync_status                            (/*unused*/),
                .out_agg_tx_ctl_tc                              (/*unused*/),
                .out_agg_tx_data_tc                             (/*unused*/),
                .out_agg_txpcs_rst                              (/*unused*/),
                .out_emsip_com_clk_out                          (/*unused*/),
                .out_emsip_com_out                              (/*unused*/),
                .out_emsip_rx_out                               (/*unused*/),
                .out_emsip_rx_special_out                       (/*unused*/),
                .out_emsip_tx_clk_out                           (/*unused*/),
                .out_emsip_tx_special_out                       (/*unused*/),
                .out_pld_8g_a1a2_k1k2_flag                      (/*unused*/),
                .out_pld_8g_align_status                        (/*unused*/),
                .out_pld_8g_bistdone                            (/*unused*/),
                .out_pld_8g_bisterr                             (/*unused*/),
                .out_pld_8g_byteord_flag                        (/*unused*/),
                .out_pld_8g_empty_rmf                           (/*unused*/),
                .out_pld_8g_empty_rx                            (rx_pcfifoempty_to_pld),
                .out_pld_8g_empty_tx                            (tx_phfifounderflow_to_pld),
                .out_pld_8g_full_rmf                            (/*unused*/),
                .out_pld_8g_full_rx                             (rx_pcfifofull_to_pld),
                .out_pld_8g_full_tx                             (tx_phfifooverflow_to_pld),
                .out_pld_8g_phystatus                           (pld8gphystatus),               //Goes to pipe_phystatus output for non-HIP designs
                .out_pld_8g_rlv_lt                              (rx_rlv_to_pld),
                .out_pld_8g_rx_clk_out                          (/*unused*/),                   //Unconnected in 2.0.
                .out_pld_8g_rx_data_valid                       (/*unused*/),                   //Gen3 signal
                .out_pld_8g_rxelecidle                          (pld8grxelecidle),              //Goes to pipe_rxelecidle output for non-HIP designs
                .out_pld_8g_rxstatus                            (pld8grxstatus),                //Goes to pipe_rxstatus output for non-HIP designs
                .out_pld_8g_rxvalid                             (pld8grxvalid),                 //Goes to pipe_rxvalid output for non-HIP designs
                .out_pld_8g_signal_detect_out                   (w_rx_signaldetect),    //Output MM port.
                .out_pld_8g_tx_clk_out                          (tx_clkout_to_pld),             //loopback to pld_tx_clk and pld_rx_clk
                .out_pld_8g_wa_boundary                         (rx_bitslipboundaryselectout_to_pld),   //Output MM port.
                .out_pld_clklow                                 (/*unused*/),                   //Unconnected in 2.0
                .out_pld_fref                                   (/*unused*/),                   //Unconnected in 2.0
                .out_pld_reserved_out                           (/*unused*/),
                .out_pld_rx_data                                (rxdata_to_pld),                //Goes to pipe_rxdata, pipe_rxdatak, rx_* output ports for non-HIP designs
                .out_pld_test_data                              (/*unused*/),
                .out_pma_current_coeff                          (/*unused*/),                   //Unconnected in 2.0. //TODO
                .out_pma_nfrzdrv                                (/*unused*/),
                .out_pma_partial_reconfig                       (/*unused*/),
                .out_pma_reserved_out                           (/*unused*/),
                .out_pma_rx_clk_out                             (/*unused*/),                   //Unconnected in 2.0. //TODO
                .out_pma_tx_clk_out                             (/*unused*/),                   //Unconnected in 2.0. //TODO

                //PINS IN XCVR_NATIVE BUT NOT FOUND HERE - DECLARED AS UNUSED PORTS
                .rx_clkdivrx                                    (/*unused*/),
                .out_pcs_signal_ok                              (/*unused*/),
                .reconfig_to_xcvr                               (reconfig_to_xcvr    [TOTAL_LANES*W_BUNDLE_TO_XCVR-1   :0]),
                .reconfig_from_xcvr                             (reconfig_from_xcvr  [TOTAL_LANES*W_BUNDLE_FROM_XCVR-1 :0])


        );

endmodule
