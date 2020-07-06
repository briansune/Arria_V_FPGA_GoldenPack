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


// ================================================================================
//
// Altera Avalon Data Pattern Checker 
//
// A Avalon-ST parallel data pattern checker that is controlled by an
// Avalon-MM slave.  The input supports bit widths of 32,40,50,64,66,80 and 128 bits
// 
// ================================================================================
`timescale 1 ns / 1 ns

(* altera_attribute = "-name IP_TOOL_NAME altera_avalon_data_pattern_checker; -name IP_TOOL_VERSION 13.0" *)

module altera_avalon_data_pattern_checker
#(  
    // ------------------------------------------------
    // Parameters
    // ------------------------------------------------
    parameter ST_DATA_W             = 40, 
    parameter NUM_CYCLES_FOR_LOCK   = 40,
    parameter ST_TO_MM_SYNC_DEPTH   = 2,
    parameter MM_TO_ST_SYNC_DEPTH   = 2,
    parameter BYPASS_ENABLED        = 1'b0,
    parameter AVALON_ENABLED        = 1'b1,
    parameter FREQ_CNTER_ENABLED    = 1'b0
)
(
    input reset,
    
    // Avalon-MM slave
    input               avs_clk,
    input      [2 : 0]  avs_address,
    input               avs_write,
    input               avs_read,
    input      [3 : 0]  avs_byteenable,
    input      [31: 0]  avs_writedata,
    output reg [31: 0]  avs_readdata,

    // Avalon-ST sink
    input                   asi_clk,
    input [ST_DATA_W-1 : 0] asi_data,
    input                   asi_valid,
    output                  asi_ready,
    
    //Avalon-ST souce
    output                      aso_clk,
    output     [ST_DATA_W-1 :0] aso_data,  
    output                      aso_valid,
    input                       aso_ready
);

    // ------------------------------------------------
    // Local Paramters
    // ------------------------------------------------
    localparam NUM_PATTERNS = 9;
    localparam SYMBOLS_PER_BEAT = 4;
    localparam BITS_PER_SYMBOL = ST_DATA_W / SYMBOLS_PER_BEAT;
    localparam COUNTER_WIDTH = 64;

    localparam ENABLE_ADDR          = 0;
    localparam PATTERN_SET_ADDR     = 1;
    localparam COUNTER_CONTROL_ADDR = 2;
    localparam BITS_COUNTER_L_ADDR  = 3;  
    localparam BITS_COUNTER_H_ADDR  = 4;
    localparam ERROR_COUNTER_L_ADDR = 5;
    localparam ERROR_COUNTER_H_ADDR = 6;
    localparam CLOCK_SENSOR_ADDR    = 7;

    localparam ENABLE_BIT              = 0;
    localparam BYPASS_BIT              = 2;
    localparam SNAP_COUNTER_BIT        = 0;
    localparam RESET_COUNTER_BIT       = 1;
    localparam RESET_CLOCK_RUNNING_BIT = 0;

    localparam SEL_PRBS_7    = 'b1;
    localparam SEL_PRBS_15   = 'b10;
    localparam SEL_PRBS_23   = 'b100;
    localparam SEL_PRBS_31   = 'b1000;
    localparam SEL_HIGH_FREQ = 'b10000;
    localparam SEL_LOW_FREQ  = 'b100000;
    localparam SEL_CRPAT     = 'b1000000;
    localparam SEL_CJTPAT    = 'b10000000;
    localparam SEL_CUSTOM    = 'b100000000;

    localparam ST_IDLE                 = 'b0;
    localparam ST_GET_LOCK             = 'b1;
    localparam ST_COUNT                = 'h2;

    // ------------------------------------------------
    // Internal Signals
    // ------------------------------------------------
    wire [ST_DATA_W-1:0]            asi_data_filtered;
    reg [8:0]                       pattern_select /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=D101" */;
    reg                             enable_register;
    reg                             bypass_enabled_register;
   
    wire                            locked;
    wire                            enable_register_sync; // sync to asi_clk
    wire                            enabled_sync;         // sync to avs_clk
    wire                            locked_sync;          // sync to avs_clk
    wire                            aso_ready_sync;
    wire                            asi_valid_sync;
    reg [1:0]                       state;
    // TODO - how large should this register be?
    // should be log 2 of NUM_CYCLES_FOR_LOCK
    reg [7:0]                       consecutive_counter;
    wire [COUNTER_WIDTH-1:0]        bits_counter;
    reg  [COUNTER_WIDTH-1:0]        error_counter;
    wire [COUNTER_WIDTH-1:0]        bits_snapped_counter;
    wire [COUNTER_WIDTH-1:0]        error_snapped_counter;
    wire                            snap;
    wire                            counter_valid;
    wire                            reset_counter;
    reg                             reset_counter_reg;
    wire                            reset_counter_now;

    reg                             clock_sensor /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=D101" */;
    wire                            reset_clock_sensor;
    reg                             reset_clock_sensor_reg;
    wire                            reset_clock_sensor_now;

    wire                            ones_counter_sclr;
    wire                            ones_counter_input_valid;
    wire                            ones_counter_output_valid;
    wire [7 : 0]                    ones_counter_output_data; // expanded for the ones_counter to count upto 128-bit
    wire [ST_DATA_W-1 : 0]          error_vector;

    reg                             asi_valid_delayed;
    reg                             asi_ready_delayed;
    reg  [ST_DATA_W-1 : 0]          expected_data;
    wire [ST_DATA_W-1 : 0]          prbs_in;
    reg	 [ST_DATA_W-1 : 0]          buffered_data;

    wire                            update_prbs_expt_data;
    wire                            update_hflf_expt_data;
    wire                            reset_sync;

    // ------------------------------------------------
    // Avalon-MM Slave
    // ------------------------------------------------
    always @(posedge avs_clk or posedge reset) begin
      if (reset) begin
        avs_readdata <= 'b0;
        pattern_select <= 'b1;
        enable_register <= 'b0;
      end else begin
        if (avs_read) begin
            avs_readdata <= 'b0;
            case (avs_address)
                ENABLE_ADDR: begin
                  if (avs_byteenable[0]) begin
                      avs_readdata[0] <= enabled_sync;
                      avs_readdata[1] <= locked_sync & enable_register;
                      avs_readdata[2] <= BYPASS_ENABLED ? 1'b1 : 1'b0;
                      avs_readdata[3] <= AVALON_ENABLED ? 1'b1 : 1'b0;
                      avs_readdata[4] <= AVALON_ENABLED ? aso_ready_sync : 1'b0;
                      avs_readdata[5] <= AVALON_ENABLED ? asi_valid_sync : 1'b0;
                      avs_readdata[6] <= FREQ_CNTER_ENABLED ? 1'b1 : 1'b0;
                  end
                end
                PATTERN_SET_ADDR: begin
                  if (avs_byteenable[0]) begin
                      avs_readdata[7:0] <= pattern_select[7:0];
                  end
                  if (avs_byteenable[1]) begin
                      avs_readdata[8] <= pattern_select[8];
                  end
                end
                COUNTER_CONTROL_ADDR: begin
                  if (avs_byteenable[1]) begin
                      avs_readdata[8] <= counter_valid;
                  end
                end
                BITS_COUNTER_L_ADDR: begin
                  if (avs_byteenable[0]) begin
                      avs_readdata[7:0] <= bits_snapped_counter[7:0];
                  end
                  if (avs_byteenable[1]) begin
                      avs_readdata[15:8] <= bits_snapped_counter[15:8];
                  end
                  if (avs_byteenable[2]) begin
                      avs_readdata[23:16] <= bits_snapped_counter[23:16];
                  end
                  if (avs_byteenable[3]) begin
                      avs_readdata[31:24] <= bits_snapped_counter[31:24];
                  end
                end
                BITS_COUNTER_H_ADDR: begin
                  if (avs_byteenable[0]) begin
                      avs_readdata[7:0] <= bits_snapped_counter[39:32];
                  end
                  if (avs_byteenable[1]) begin
                      avs_readdata[15:8] <= bits_snapped_counter[47:40];
                  end
                  if (avs_byteenable[2]) begin
                      avs_readdata[23:16] <= bits_snapped_counter[55:48];
                  end
                  if (avs_byteenable[3]) begin
                      avs_readdata[31:24] <= bits_snapped_counter[63:56];
                  end
                end
                ERROR_COUNTER_L_ADDR: begin
                  if (avs_byteenable[0]) begin
                      avs_readdata[7:0] <= error_snapped_counter[7:0];
                  end
                  if (avs_byteenable[1]) begin
                      avs_readdata[15:8] <= error_snapped_counter[15:8];
                  end
                  if (avs_byteenable[2]) begin
                      avs_readdata[23:16] <= error_snapped_counter[23:16];
                  end
                  if (avs_byteenable[3]) begin
                      avs_readdata[31:24] <= error_snapped_counter[31:24];
                  end
                end
                ERROR_COUNTER_H_ADDR: begin
                  if (avs_byteenable[0]) begin
                      avs_readdata[7:0] <= error_snapped_counter[39:32];
                  end
                  if (avs_byteenable[1]) begin
                      avs_readdata[15:8] <= error_snapped_counter[47:40];
                  end
                  if (avs_byteenable[2]) begin
                      avs_readdata[23:16] <= error_snapped_counter[55:48];
                  end
                  if (avs_byteenable[3]) begin
                      avs_readdata[31:24] <= error_snapped_counter[63:56];
                  end
                end
                CLOCK_SENSOR_ADDR: begin
                  if (avs_byteenable[0]) begin
                      avs_readdata[1] <= clock_sensor;
                  end
                end
                default: begin
                end
            endcase
        end // end read if block
        else if (avs_write) begin
            if (enable_register) begin
                // In the middle of a transfer, only the stopping generation
                // and counter operations are accepted.  Pattern switching is
                // ignored. 
                
                // counter operations are handled below as they are not
                // actually stored.
                if (avs_address == ENABLE_ADDR) begin
                    //if custom pattern is select, prevent the user from start
                    //the checker
                  if (avs_byteenable[0] && (pattern_select != SEL_CUSTOM)) begin
                      enable_register <= avs_writedata[ENABLE_BIT];
                  end
                end
            end else begin
                case (avs_address) 
                    ENABLE_ADDR: begin
                      if (avs_byteenable[0] && (pattern_select != SEL_CUSTOM)) begin
                          enable_register <= avs_writedata[ENABLE_BIT];
                      end
                    end
                    PATTERN_SET_ADDR: begin
                      if (avs_byteenable[0]) begin
                          pattern_select[7:0] <= avs_writedata[7:0];
                      end
                      if (avs_byteenable[1]) begin
                          pattern_select[8] <= avs_writedata[8];
                      end
                    end
                    default: begin
                        // All the counter registers are read only
                        // Counter reset and snap logic is handled below.
                    end
                endcase
            end
        end // end write if block
      end // end else
    end //end always block

    // ------------------------------------------------
    // Counter snapping logic with proper clock crossing
    // ------------------------------------------------
    assign snap = avs_write && (avs_address == COUNTER_CONTROL_ADDR) &&
                  avs_byteenable[0] && avs_writedata[SNAP_COUNTER_BIT];

    assign reset_counter = avs_write && (avs_address == COUNTER_CONTROL_ADDR) &&
                           avs_byteenable[0] && avs_writedata[RESET_COUNTER_BIT];

    snap_handshake_clock_crosser
    #(
        .DATA_WIDTH              (2*COUNTER_WIDTH),
        .DATA_TO_CTRL_SYNC_DEPTH (ST_TO_MM_SYNC_DEPTH),
        .CTRL_TO_DATA_SYNC_DEPTH (MM_TO_ST_SYNC_DEPTH)
     ) snapper (
        .reset    (reset),
        .clr      (reset_counter),
        .ctrl_clk (avs_clk),
        .data_clk (asi_clk),
        .snap     (snap), 
        .din      ({bits_counter, error_counter}),
        .dout     ({bits_snapped_counter, error_snapped_counter}),
        .valid    (counter_valid)
    );

    generate
        if ( (ST_TO_MM_SYNC_DEPTH==0) && (MM_TO_ST_SYNC_DEPTH==0) ) begin
            assign locked_sync = locked;
            assign enable_register_sync = enable_register;
            assign enabled_sync = enable_register_sync;
            assign aso_ready_sync = aso_ready;
            assign asi_valid_sync = asi_valid;
        end else begin
            altera_std_synchronizer #(
                .depth   (ST_TO_MM_SYNC_DEPTH)
            ) locked_synchronizer (
                .clk     (avs_clk),
                .reset_n (~reset),
                .din     (locked),
                .dout    (locked_sync)
            );
            
            altera_std_synchronizer #(
                .depth   (MM_TO_ST_SYNC_DEPTH)
            ) enable_register_synchronizer (
                .clk     (asi_clk),
                .reset_n (~reset),
                .din     (enable_register),
                .dout    (enable_register_sync)
            );
            
            altera_std_synchronizer #(
                .depth   (MM_TO_ST_SYNC_DEPTH)
            ) enabled_synchronizer (
                .clk     (avs_clk),
                .reset_n (~reset),
                .din     (enable_register_sync),
                .dout    (enabled_sync)
            );

            altera_std_synchronizer #(
                .depth   (MM_TO_ST_SYNC_DEPTH)
            ) ready_synchronizer (
                .clk     (avs_clk),
                .reset_n (~reset),
                .din     (aso_ready),
                .dout    (aso_ready_sync)
            );
            
            altera_std_synchronizer #(
                .depth   (MM_TO_ST_SYNC_DEPTH)
            ) valid_synchronizer (
                .clk     (avs_clk),
                .reset_n (~reset),
                .din     (asi_valid),
                .dout    (asi_valid_sync)
            );
        end
    endgenerate

    // ------------------------------------------------
    // Clock sensing logic
    // ------------------------------------------------
    assign reset_clock_sensor = avs_write && (avs_address == CLOCK_SENSOR_ADDR) &&
                                avs_byteenable[0] && avs_writedata[RESET_CLOCK_RUNNING_BIT];

    generate
        if ( (ST_TO_MM_SYNC_DEPTH==0) && (MM_TO_ST_SYNC_DEPTH==0) ) begin
            assign reset_clock_sensor_now = reset | reset_clock_sensor;
            assign reset_sync = reset;
        end else begin
            // Synchronize the reset_clock_sensor signal
            always @ (posedge avs_clk or posedge reset) begin
                if (reset) begin
                    reset_clock_sensor_reg <= 1'b0;
                end else begin
                    reset_clock_sensor_reg <= reset_clock_sensor;
                end
            end
        
            // reset_clock_sensor_reg is synchronous to avs_clk but is asynchronous to asi_clk
            altera_reset_controller
            #(
                .NUM_RESET_INPUTS        (2),
                .OUTPUT_RESET_SYNC_EDGES ("deassert"),
                .SYNC_DEPTH              (MM_TO_ST_SYNC_DEPTH)
            ) clock_sensor_reset_controller (
                .clk        (asi_clk),
                .reset_in0  (reset),
                .reset_in1  (reset_clock_sensor_reg),
                .reset_in2  (),
                .reset_in3  (),
                .reset_in4  (),
                .reset_in5  (),
                .reset_in6  (),
                .reset_in7  (),
                .reset_in8  (),
                .reset_in9  (),
                .reset_in10 (),
                .reset_in11 (),
                .reset_in12 (),
                .reset_in13 (),
                .reset_in14 (),
                .reset_in15 (),
                .reset_out  (reset_clock_sensor_now)
            );
           
            altera_reset_synchronizer
            #(
                .DEPTH              (MM_TO_ST_SYNC_DEPTH)
            ) asi_reset_controller (
                .clk        (asi_clk),
                .reset_in  (reset),
                .reset_out  (reset_sync)
            );

        end
    endgenerate

    always @ (posedge asi_clk or posedge reset_clock_sensor_now) begin
        if (reset_clock_sensor_now) begin
            clock_sensor <= 1'b0;
        end else begin
            clock_sensor <= 1'b1;
        end
    end

    /// ------------------------------------------------
    // Avalon-ST Source (By pass interface) 
    // ------------------------------------------------
    // Bypass signals when the interface exists
    generate
        if ( BYPASS_ENABLED ) begin
            if ( AVALON_ENABLED ) begin
                bypass_port #(
                    .DATA_W     (ST_DATA_W)
                ) bypass_port_1 (
                    .asi_clk    (asi_clk),
                    .asi_data   (asi_data),
                    .asi_valid  (asi_valid),
                    .asi_ready  (asi_ready),
    
                    .aso_clk    (aso_clk),
                    .aso_data   (aso_data),  
                    .aso_valid  (aso_valid),
                    .aso_ready  (aso_ready)
                ); 
            end else begin
                bypass_port #(
                    .DATA_W     (ST_DATA_W)
                ) bypass_port_2 (
                    .asi_clk    (asi_clk),
                    .asi_data   (asi_data),
                    .asi_valid  (),
                    .asi_ready  (),
    
                    .aso_clk    (aso_clk),
                    .aso_data   (aso_data),  
                    .aso_valid  (),
                    .aso_ready  ()
                );
                assign aso_valid = 1'b0;
                assign asi_ready = 1'b1;
            end
        end else begin
            assign asi_ready = AVALON_ENABLED ? enable_register_sync : 1'b1;
            assign aso_clk = 'b0;
            assign aso_data = 'b0;
            assign aso_valid = 'b0;
        end
    endgenerate

    // ------------------------------------------------
    // Avalon-ST Sink
    // ------------------------------------------------
    assign locked = (state == ST_COUNT);
    genvar i;
    generate 
        if ( AVALON_ENABLED ) begin
            assign asi_data_filtered = asi_data;
        end else begin
            for ( i = 0; i < ST_DATA_W; i = i +1 ) begin : data_flip
                assign asi_data_filtered[ST_DATA_W-1-i] = asi_data[i];
            end
        end
    endgenerate

    always @(posedge asi_clk or posedge reset_sync) begin
        if (reset_sync) begin
            asi_valid_delayed <= 'b0;
            asi_ready_delayed <= 'b0;
	    	buffered_data <= 'b0;
        end else begin
            //if conduit interface is used, set asi_valid_delayed to 1
            buffered_data <= asi_data_filtered;
            asi_valid_delayed <= AVALON_ENABLED ? asi_valid : 1'b1;
            asi_ready_delayed <= AVALON_ENABLED ? asi_ready : 1'b1;
        end
    end

    // Checker logic
    always @(posedge asi_clk or posedge reset_sync) begin
        if (reset_sync) begin
            state <= ST_IDLE;
            consecutive_counter <= 'b0;
        end else begin
            case (state)
                ST_IDLE: begin
                    consecutive_counter <= 'b0;
                    if (enable_register_sync == 1'b1) begin
                        state <= ST_GET_LOCK;
                    end
                end
                ST_GET_LOCK: begin
                    // consecutive counter is used to count correct cycles in this state
                    if (asi_valid_delayed) begin // this component is always ready in this state
						// all zeros is never a correct data, check here to prevent PRBS using it as seed
                        if (buffered_data == expected_data && ~(~|buffered_data))  begin
			                consecutive_counter <= consecutive_counter + 1'b1;
                            if (consecutive_counter >= NUM_CYCLES_FOR_LOCK-1) begin
                                consecutive_counter <= 'b0;
                                state <= ST_COUNT;
                            end
                        end else begin
                            // valid in data does not match.  reset counter.
                            consecutive_counter <= 'b0;
                        end
                    end
                end
                ST_COUNT: begin
                    // consecutive counter is used to count INcorrect cycles in this state
                    if (asi_valid_delayed) begin
                       if (buffered_data == expected_data) begin
                           // yay, we're correct!
                           consecutive_counter <= 'b0;
                       end else begin
                           // not correct
                           // increase consective counter, check for losing
                           // lock, increase error counter
                           consecutive_counter <= consecutive_counter + 1'b1;
                           if (consecutive_counter >= NUM_CYCLES_FOR_LOCK-1) begin
                               consecutive_counter <= 'b0;
                               state <= ST_GET_LOCK;
                           end
                       end // end if ST_DATA_W
                    end // end if asi_valid_delayed
                end
            endcase
            if (~enable_register_sync) begin
                state <= ST_IDLE;
                consecutive_counter <= 'b0;
            end
        end // end reset
    end // end always block
    
    generate
        if ( (ST_TO_MM_SYNC_DEPTH==0) && (MM_TO_ST_SYNC_DEPTH==0) ) begin
            assign reset_counter_now = reset | reset_counter;
        end else begin
            // Synchronize the reset_counter signal
            always @ (posedge avs_clk or posedge reset) begin
                if (reset) begin
                    reset_counter_reg <= 1'b0;
                end else begin
                    reset_counter_reg <= reset_counter;
                end
            end
        
            // reset_counter_reg is synchronous to avs_clk but is asynchronous to asi_clk
            altera_reset_controller
            #(
                .NUM_RESET_INPUTS        (2),
                .OUTPUT_RESET_SYNC_EDGES ("deassert"),
                .SYNC_DEPTH              (MM_TO_ST_SYNC_DEPTH)
            ) counter_reset_controller (
                .clk        (asi_clk),
                .reset_in0  (reset),
                .reset_in1  (reset_counter_reg),
                .reset_in2  (),
                .reset_in3  (),
                .reset_in4  (),
                .reset_in5  (),
                .reset_in6  (),
                .reset_in7  (),
                .reset_in8  (),
                .reset_in9  (),
                .reset_in10 (),
                .reset_in11 (),
                .reset_in12 (),
                .reset_in13 (),
                .reset_in14 (),
                .reset_in15 (),
                .reset_out  (reset_counter_now)
            );
        end
    endgenerate

    // the ones counter instatiation
    assign error_vector = buffered_data ^ expected_data;
    assign ones_counter_input_valid = (state == ST_COUNT) & asi_valid_delayed;
    // async asseration, synchronized desasseration

    ones_counter #(
        .ST_DATA_W (ST_DATA_W)
    ) my_ones_counter (
        .clk       (asi_clk),
        .reset     (reset_counter_now),
        .sclr      (),
        .in_data   (error_vector),
        .in_valid  (ones_counter_input_valid),
        .out_valid (ones_counter_output_valid),
        .out_data  (ones_counter_output_data)
    );

    // bits and error counting
    generate
        // 40-bit
        if (ST_DATA_W == 40) begin
            reg [63:3] bits_counter_reg;
            always @(posedge asi_clk or posedge reset_counter_now) begin
                if (reset_counter_now) begin
                    bits_counter_reg[63:3] <= 'b0;
                    error_counter <= 'b0;
                end else begin
                    if (ones_counter_output_valid) begin
                        bits_counter_reg[63:3] <= bits_counter_reg[63:3] + 'b101; // +40, this is to prevent inferred latch warning
                        error_counter <= error_counter + ones_counter_output_data;
                    end
                end
            end // end always
            assign bits_counter = {bits_counter_reg, 3'b0};
        // 32-bit
        end else if (ST_DATA_W == 32) begin
            reg [63:5] bits_counter_reg;
            always @(posedge asi_clk or posedge reset_counter_now) begin
                if (reset_counter_now) begin
                    bits_counter_reg[63:5] <= 'b0;
                    error_counter <= 'b0;
                end else begin
                    if (ones_counter_output_valid) begin
                        bits_counter_reg[63:5] <= bits_counter_reg[63:5] + 'b1; // +32, this is to prevent inferred latch warning 
                        error_counter <= error_counter + ones_counter_output_data;
                    end
                end
            end // end always
            assign bits_counter = {bits_counter_reg, 5'b0};
        end else if (ST_DATA_W == 64) begin
            reg [63:6] bits_counter_reg;
            always @(posedge asi_clk or posedge reset_counter_now) begin
                if (reset_counter_now) begin
                    bits_counter_reg[63:6] <= 'b0;
                    error_counter <= 'b0;
                end else begin
                    if (ones_counter_output_valid) begin
                        bits_counter_reg[63:6] <= bits_counter_reg[63:6] + 'b1; // +64, this is to prevent inferred latch warning 
                        error_counter <= error_counter + ones_counter_output_data;
                    end
                end
            end // end always		
            assign bits_counter = {bits_counter_reg, 6'b0};
		  end else if (ST_DATA_W == 66) begin
            reg [63:1] bits_counter_reg;
            always @(posedge asi_clk or posedge reset_counter_now) begin
                if (reset_counter_now) begin
                    bits_counter_reg[63:1] <= 'b0;
                    error_counter <= 'b0;
                end else begin
                    if (ones_counter_output_valid) begin
                        bits_counter_reg[63:1] <= bits_counter_reg[63:1] + 'b100_001; // +66, this is to prevent inferred latch warning 
                        error_counter <= error_counter + ones_counter_output_data;
                    end
                end
            end // end always
            assign bits_counter = {bits_counter_reg, 1'b0};
		  end else if (ST_DATA_W == 80) begin
            reg [63:4] bits_counter_reg;
            always @(posedge asi_clk or posedge reset_counter_now) begin
                if (reset_counter_now) begin
                    bits_counter_reg[63:4] <= 'b0;
                    error_counter <= 'b0;
                end else begin
                    if (ones_counter_output_valid) begin
                        bits_counter_reg[63:4] <= bits_counter_reg[63:4] + 'b101; // +80, this is to prevent inferred latch warning 
                        error_counter <= error_counter + ones_counter_output_data;
                    end
                end
            end // end always	
            assign bits_counter = {bits_counter_reg, 4'b0};
		end else if	(ST_DATA_W == 128) begin
            reg [63:7] bits_counter_reg;
            always @(posedge asi_clk or posedge reset_counter_now) begin 
                if (reset_counter_now) begin
                    bits_counter_reg[63:7] <= 'b0;
                    error_counter <= 'b0;
                end else begin
                    if (ones_counter_output_valid) begin
                        bits_counter_reg[63:7] <= bits_counter_reg[63:7] + 'b1; // +128, this is to prevent inferred latch warning 
                        error_counter <= error_counter + ones_counter_output_data;
                    end
                end
            end // end always 		
            assign bits_counter = {bits_counter_reg, 7'b0};
		end else if (ST_DATA_W == 50) begin
            reg [63:1] bits_counter_reg;
            always @(posedge asi_clk or posedge reset_counter_now) begin
                if (reset_counter_now) begin
                    bits_counter_reg[63:1] <= 'b0;
                    error_counter <= 'b0;
                end else begin
                    if (ones_counter_output_valid) begin
                        bits_counter_reg[63:1] <= bits_counter_reg[63:1] + 'b11_001; // +50, this is to prevent inferred latch warning 
                        error_counter <= error_counter + ones_counter_output_data;
                    end
                end
            end // end always		
            assign bits_counter = {bits_counter_reg, 1'b0};
		end
    endgenerate

    // nextdata 

    // if we are in the get lock phase, use the input data to calculate
    // the next PRBS
    // if we are in the counting phase
    // use the current expected data to calculate the next expected data
    // this can prevent error propagating to the next data
    assign prbs_in = (state == ST_GET_LOCK) ? buffered_data : expected_data;

    // In avalon mode, update the expected data when the ST interface is ready
    // In conduit mode, update when the checker is enabled
    assign update_prbs_expt_data = AVALON_ENABLED ? (asi_valid_delayed & asi_ready_delayed ) : enable_register;

    assign update_hflf_expt_data = update_prbs_expt_data & (state == ST_GET_LOCK) & (buffered_data != expected_data);

    generate
        if (ST_DATA_W == 32) begin
            always @(posedge asi_clk or posedge reset_sync) begin
                if (reset_sync) begin
                    expected_data <= 'b0;
                end else begin
                       // pattern_select does not need to be synchronized to asi_clk
                       // because the value does not change when the component is enabled
						case (pattern_select)
							SEL_HIGH_FREQ: begin
                        		if( update_hflf_expt_data ) begin
                                   if ( buffered_data == 32'hAAAA_AAAA | buffered_data == 32'h5555_5555) begin
										expected_data <= buffered_data;
                                   end else begin
										expected_data <= 'b0;
								   end
								end
							end
							SEL_LOW_FREQ: begin
							// calculate the expected data only when a new set of data came 
							// and we are not in the locked state	
				    			if( update_hflf_expt_data ) begin
                                    if( buffered_data == 32'hF0F0_F0F0 | buffered_data == 32'hE1E1_E1E1 | buffered_data == 32'hC3C3_C3C3 |
									    buffered_data == 32'h8787_8787 | buffered_data == 32'h0F0F_0F0F | buffered_data == 32'h1E1E_1E1E |
                                        buffered_data == 32'h3C3C_3C3C | buffered_data == 32'h7878_7878 ) begin
                                        expected_data <= buffered_data;
                                    end else begin
										expected_data <= 'b0;
									end
                                end
							end
							SEL_PRBS_7 : begin
                            // PRBS 2^7-1 (T[7,6]) (parallel 32-bit serializer)
                                if ( update_prbs_expt_data) begin
                                     expected_data[0]  <= prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[6] ;
                                     expected_data[1]  <= prbs_in[0] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6];
                                     expected_data[2]  <= prbs_in[0] ^ prbs_in[1] ^ prbs_in[4] ^ prbs_in[5] ;
                                     expected_data[3]  <= prbs_in[1] ^ prbs_in[2] ^ prbs_in[5] ^ prbs_in[6] ;
                                     expected_data[4]  <= prbs_in[0] ^ prbs_in[2] ^ prbs_in[3];
                                     expected_data[5]  <= prbs_in[1] ^ prbs_in[3] ^ prbs_in[4];
                                     expected_data[6]  <= prbs_in[2] ^ prbs_in[4] ^ prbs_in[5];
                                     expected_data[7]  <= prbs_in[3] ^ prbs_in[5] ^ prbs_in[6];
                                     expected_data[8]  <= prbs_in[0] ^ prbs_in[4] ;
                                     expected_data[9]  <= prbs_in[1] ^ prbs_in[5] ;
                                     expected_data[10] <= prbs_in[2] ^ prbs_in[6] ;
                                     expected_data[11] <= prbs_in[0] ^ prbs_in[3] ^ prbs_in[6] ;
                                     expected_data[12] <= prbs_in[0] ^ prbs_in[1] ^ prbs_in[4] ^ prbs_in[6] ;
                                     expected_data[13] <= prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[5] ^ prbs_in[6];
                                     expected_data[14] <= prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ;
                                     expected_data[15] <= prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ;
                                     expected_data[16] <= prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ;
                                     expected_data[17] <= prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ;
                                     expected_data[18] <= prbs_in[0] ^ prbs_in[4] ^ prbs_in[5] ;
                                     expected_data[19] <= prbs_in[1] ^ prbs_in[5] ^ prbs_in[6] ;
                                     expected_data[20] <= prbs_in[0] ^ prbs_in[2] ;
                                     expected_data[21] <= prbs_in[1] ^ prbs_in[3] ;
                                     expected_data[22] <= prbs_in[2] ^ prbs_in[4] ;
                                     expected_data[23] <= prbs_in[3] ^ prbs_in[5] ;
                                     expected_data[24] <= prbs_in[4] ^ prbs_in[6] ;
                                     expected_data[25] <= prbs_in[0] ^ prbs_in[5] ^ prbs_in[6];
                                     expected_data[26] <= prbs_in[0] ^ prbs_in[1] ;
                                     expected_data[27] <= prbs_in[1] ^ prbs_in[2] ;
                                     expected_data[28] <= prbs_in[2] ^ prbs_in[3] ;
                                     expected_data[29] <= prbs_in[3] ^ prbs_in[4] ;
                                     expected_data[30] <= prbs_in[4] ^ prbs_in[5] ;
                                     expected_data[31] <= prbs_in[5] ^ prbs_in[6] ;
                                end
                            end
							SEL_PRBS_15 : begin
                            // PRBS 2^15 (T[15, 14]) (parallel 32-bit serializer)
                                if ( update_prbs_expt_data ) begin
                                     expected_data[0]  <= prbs_in[10] ^ prbs_in[11] ^ prbs_in[12] ^ prbs_in[13] ;
                                     expected_data[1]  <= prbs_in[11] ^ prbs_in[12] ^ prbs_in[13] ^ prbs_in[14] ;
                                     expected_data[2]  <= prbs_in[0]  ^ prbs_in[12] ^ prbs_in[13] ;
                                     expected_data[3]  <= prbs_in[1]  ^ prbs_in[13] ^ prbs_in[14] ;
                                     expected_data[4]  <= prbs_in[0]  ^ prbs_in[2]  ;
                                     expected_data[5]  <= prbs_in[1]  ^ prbs_in[3]  ;
                                     expected_data[6]  <= prbs_in[2]  ^ prbs_in[4]  ;
                                     expected_data[7]  <= prbs_in[3]  ^ prbs_in[5]  ;
                                     expected_data[8]  <= prbs_in[4]  ^ prbs_in[6]  ;
                                     expected_data[9]  <= prbs_in[5]  ^ prbs_in[7]  ;
                                     expected_data[10] <= prbs_in[6]  ^ prbs_in[8]  ;
                                     expected_data[11] <= prbs_in[7]  ^ prbs_in[9]  ;
                                     expected_data[12] <= prbs_in[8]  ^ prbs_in[10] ;
                                     expected_data[13] <= prbs_in[9]  ^ prbs_in[11] ;
                                     expected_data[14] <= prbs_in[10] ^ prbs_in[12] ;
                                     expected_data[15] <= prbs_in[11] ^ prbs_in[13] ;
                                     expected_data[16] <= prbs_in[12] ^ prbs_in[14] ;
                                     expected_data[17] <= prbs_in[0]  ^ prbs_in[13] ^ prbs_in[14] ;
                                     expected_data[18] <= prbs_in[0]  ^ prbs_in[1]  ;
                                     expected_data[19] <= prbs_in[1]  ^ prbs_in[2]  ;
                                     expected_data[20] <= prbs_in[2]  ^ prbs_in[3]  ;
                                     expected_data[21] <= prbs_in[3]  ^ prbs_in[4]  ;
                                     expected_data[22] <= prbs_in[4]  ^ prbs_in[5]  ;
                                     expected_data[23] <= prbs_in[5]  ^ prbs_in[6]  ;
                                     expected_data[24] <= prbs_in[6]  ^ prbs_in[7]  ;
                                     expected_data[25] <= prbs_in[7]  ^ prbs_in[8]  ;
                                     expected_data[26] <= prbs_in[8]  ^ prbs_in[9]  ;
                                     expected_data[27] <= prbs_in[9]  ^ prbs_in[10] ;
                                     expected_data[28] <= prbs_in[10] ^ prbs_in[11] ;
                                     expected_data[29] <= prbs_in[11] ^ prbs_in[12] ;
                                     expected_data[30] <= prbs_in[12] ^ prbs_in[13] ;
                                     expected_data[31] <= prbs_in[13] ^ prbs_in[14] ;
                                end
                            end
							SEL_PRBS_23 : begin
                            // PRBS 2^23-1 (T[23,18]) (parallel 32-bit serializer)
                                  if ( update_prbs_expt_data ) begin
                                     expected_data[0]  <= prbs_in[4]  ^ prbs_in[14] ;
                                     expected_data[1]  <= prbs_in[5]  ^ prbs_in[15] ;
                                     expected_data[2]  <= prbs_in[6]  ^ prbs_in[16] ;
                                     expected_data[3]  <= prbs_in[7]  ^ prbs_in[17] ;
                                     expected_data[4]  <= prbs_in[8]  ^ prbs_in[18] ;
                                     expected_data[5]  <= prbs_in[9]  ^ prbs_in[19] ;
                                     expected_data[6]  <= prbs_in[10] ^ prbs_in[20] ;
                                     expected_data[7]  <= prbs_in[11] ^ prbs_in[21] ;
                                     expected_data[8]  <= prbs_in[12] ^ prbs_in[22] ;
                                     expected_data[9]  <= prbs_in[0]  ^ prbs_in[13] ^ prbs_in[18] ;
                                     expected_data[10] <= prbs_in[1]  ^ prbs_in[14] ^ prbs_in[19] ;
                                     expected_data[11] <= prbs_in[2]  ^ prbs_in[15] ^ prbs_in[20] ;
                                     expected_data[12] <= prbs_in[3]  ^ prbs_in[16] ^ prbs_in[21] ;
                                     expected_data[13] <= prbs_in[4]  ^ prbs_in[17] ^ prbs_in[22] ;
                                     expected_data[14] <= prbs_in[0]  ^ prbs_in[5]  ;
                                     expected_data[15] <= prbs_in[1]  ^ prbs_in[6]  ;
                                     expected_data[16] <= prbs_in[2]  ^ prbs_in[7]  ;
                                     expected_data[17] <= prbs_in[3]  ^ prbs_in[8]  ;
                                     expected_data[18] <= prbs_in[4]  ^ prbs_in[9]  ;
                                     expected_data[19] <= prbs_in[5]  ^ prbs_in[10] ;
                                     expected_data[20] <= prbs_in[6]  ^ prbs_in[11] ;
                                     expected_data[21] <= prbs_in[7]  ^ prbs_in[12] ;
                                     expected_data[22] <= prbs_in[8]  ^ prbs_in[13] ;
                                     expected_data[23] <= prbs_in[9]  ^ prbs_in[14] ;
                                     expected_data[24] <= prbs_in[10] ^ prbs_in[15] ;
                                     expected_data[25] <= prbs_in[11] ^ prbs_in[16] ;
                                     expected_data[26] <= prbs_in[12] ^ prbs_in[17] ;
                                     expected_data[27] <= prbs_in[13] ^ prbs_in[18] ;
                                     expected_data[28] <= prbs_in[14] ^ prbs_in[19] ;
                                     expected_data[29] <= prbs_in[15] ^ prbs_in[20] ;
                                     expected_data[30] <= prbs_in[16] ^ prbs_in[21] ;
                                     expected_data[31] <= prbs_in[17] ^ prbs_in[22] ;
                                 end
                            end
							SEL_PRBS_31 : begin
                            // PRBS 2^31-1 (T[31,28]) (parallel 32-bit serializer)
                                if ( update_prbs_expt_data) begin 
                                    expected_data[0]  <= prbs_in[24] ^ prbs_in[30] ;
                                     expected_data[1]  <= prbs_in[0]  ^ prbs_in[25] ^ prbs_in[28] ;
                                     expected_data[2]  <= prbs_in[1]  ^ prbs_in[26] ^ prbs_in[29] ;
                                     expected_data[3]  <= prbs_in[2]  ^ prbs_in[27] ^ prbs_in[30] ;
                                     expected_data[4]  <= prbs_in[0]  ^ prbs_in[3]  ;
                                     expected_data[5]  <= prbs_in[1]  ^ prbs_in[4]  ;
                                     expected_data[6]  <= prbs_in[2]  ^ prbs_in[5]  ;
                                     expected_data[7]  <= prbs_in[3]  ^ prbs_in[6]  ;
                                     expected_data[8]  <= prbs_in[4]  ^ prbs_in[7]  ;
                                     expected_data[9]  <= prbs_in[5]  ^ prbs_in[8]  ;
                                     expected_data[10] <= prbs_in[6]  ^ prbs_in[9]  ;
                                     expected_data[11] <= prbs_in[7]  ^ prbs_in[10] ;
                                     expected_data[12] <= prbs_in[8]  ^ prbs_in[11] ;
                                     expected_data[13] <= prbs_in[9]  ^ prbs_in[12] ;
                                     expected_data[14] <= prbs_in[10] ^ prbs_in[13] ;
                                     expected_data[15] <= prbs_in[11] ^ prbs_in[14] ;
                                     expected_data[16] <= prbs_in[12] ^ prbs_in[15] ;
                                     expected_data[17] <= prbs_in[13] ^ prbs_in[16] ;
                                     expected_data[18] <= prbs_in[14] ^ prbs_in[17] ;
                                     expected_data[19] <= prbs_in[15] ^ prbs_in[18] ;
                                     expected_data[20] <= prbs_in[16] ^ prbs_in[19] ;
                                     expected_data[21] <= prbs_in[17] ^ prbs_in[20] ;
                                     expected_data[22] <= prbs_in[18] ^ prbs_in[21] ;
                                     expected_data[23] <= prbs_in[19] ^ prbs_in[22] ;
                                     expected_data[24] <= prbs_in[20] ^ prbs_in[23] ;
                                     expected_data[25] <= prbs_in[21] ^ prbs_in[24] ;
                                     expected_data[26] <= prbs_in[22] ^ prbs_in[25] ;
                                     expected_data[27] <= prbs_in[23] ^ prbs_in[26] ;
                                     expected_data[28] <= prbs_in[24] ^ prbs_in[27] ;
                                     expected_data[29] <= prbs_in[25] ^ prbs_in[28] ;
                                     expected_data[30] <= prbs_in[26] ^ prbs_in[29] ;
                                     expected_data[31] <= prbs_in[27] ^ prbs_in[30] ;
                                end
                            end
							default: begin
								expected_data <= expected_data;
							end
                      endcase
                end // end else
            end // end always
        end
		if (ST_DATA_W == 40) begin
             always @(posedge asi_clk or posedge reset_sync) begin
                if (reset_sync) begin
                    expected_data <= 'b0;
                end else begin
                       // pattern_select does not need to be synchronized to asi_clk
                       // because the value does not change when the component is enabled
                       case (pattern_select)
							SEL_HIGH_FREQ: begin
                        		if( update_hflf_expt_data ) begin
                                   if ( buffered_data == 40'h55_5555_5555 | buffered_data == 40'hAA_AAAA_AAAA) begin
										expected_data <= buffered_data;
                                   end else begin
										expected_data <= 'b0;
								   end
								end
							end
							SEL_LOW_FREQ: begin
							// calculate the expected data only when a new set of data came 
							// and we are not in the locked state	
				    			if( update_hflf_expt_data ) begin
                                    if( buffered_data == 40'h7C1F07C1F0 | buffered_data == 40'h3E0F83E0F8 | buffered_data == 40'h1F07C1F07C |
									    buffered_data == 40'h0F83E0F83E | buffered_data == 40'h07C1F07C1F | buffered_data == 40'h83E0F83E0F |
                                        buffered_data == 40'hC1F07C1F07 | buffered_data == 40'hE0F83E0F83 | buffered_data == 40'hF07C1F07C1 |
										buffered_data == 40'hF83E0F83E0) begin
                                        expected_data <= buffered_data;
                                    end else begin
										expected_data <= 'b0;
									end
                                end
							end	
							SEL_PRBS_7 : begin
								// PRBS 2^7-1 (T[7,6]) (parallel 40-bit serializer)
                                if ( update_prbs_expt_data) begin
                                     expected_data[0]  <= prbs_in[0] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ;
                                     expected_data[1]  <= prbs_in[1] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ;
                                     expected_data[2]  <= prbs_in[0] ^ prbs_in[2] ^ prbs_in[5] ;
                                     expected_data[3]  <= prbs_in[1] ^ prbs_in[3] ^ prbs_in[6] ;
                                     expected_data[4]  <= prbs_in[0] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[6] ;
                                     expected_data[5]  <= prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ;
                                     expected_data[6]  <= prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ;
                                     expected_data[7]  <= prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ;
                                     expected_data[8]  <= prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[6] ;
                                     expected_data[9]  <= prbs_in[0] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ;
                                     expected_data[10] <= prbs_in[0] ^ prbs_in[1] ^ prbs_in[4] ^ prbs_in[5] ;
                                     expected_data[11] <= prbs_in[1] ^ prbs_in[2] ^ prbs_in[5] ^ prbs_in[6] ;
                                     expected_data[12] <= prbs_in[0] ^ prbs_in[2] ^ prbs_in[3] ;
                                     expected_data[13] <= prbs_in[1] ^ prbs_in[3] ^ prbs_in[4] ;
                                     expected_data[14] <= prbs_in[2] ^ prbs_in[4] ^ prbs_in[5] ;
                                     expected_data[15] <= prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ;
                                     expected_data[16] <= prbs_in[0] ^ prbs_in[4] ;
                                     expected_data[17] <= prbs_in[1] ^ prbs_in[5] ;
                                     expected_data[18] <= prbs_in[2] ^ prbs_in[6] ;
                                     expected_data[19] <= prbs_in[0] ^ prbs_in[3] ^ prbs_in[6] ;
                                     expected_data[20] <= prbs_in[0] ^ prbs_in[1] ^ prbs_in[4] ^ prbs_in[6] ;
                                     expected_data[21] <= prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[5] ^ prbs_in[6] ;
                                     expected_data[22] <= prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ;
                                     expected_data[23] <= prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ;
                                     expected_data[24] <= prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ;
                                     expected_data[25] <= prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ;
                                     expected_data[26] <= prbs_in[0] ^ prbs_in[4] ^ prbs_in[5] ;
                                     expected_data[27] <= prbs_in[1] ^ prbs_in[5] ^ prbs_in[6] ;
                                     expected_data[28] <= prbs_in[0] ^ prbs_in[2] ;
                                     expected_data[29] <= prbs_in[1] ^ prbs_in[3] ;
                                     expected_data[30] <= prbs_in[2] ^ prbs_in[4] ;
                                     expected_data[31] <= prbs_in[3] ^ prbs_in[5] ;
                                     expected_data[32] <= prbs_in[4] ^ prbs_in[6] ;
                                     expected_data[33] <= prbs_in[0] ^ prbs_in[5] ^ prbs_in[6] ;
                                     expected_data[34] <= prbs_in[0] ^ prbs_in[1] ;
                                     expected_data[35] <= prbs_in[1] ^ prbs_in[2] ;
                                     expected_data[36] <= prbs_in[2] ^ prbs_in[3] ;
                                     expected_data[37] <= prbs_in[3] ^ prbs_in[4] ;
                                     expected_data[38] <= prbs_in[4] ^ prbs_in[5] ;
                                     expected_data[39] <= prbs_in[5] ^ prbs_in[6] ;				
                                 end
							end
							SEL_PRBS_15 : begin
								// PRBS 2^15 (T[15, 14]) (parallel 40-bit serializer)
                                if ( update_prbs_expt_data) begin
                                     expected_data[0]  <= prbs_in[2]  ^ prbs_in[3]  ^ prbs_in[4]  ^ prbs_in[5]  ;
                                     expected_data[1]  <= prbs_in[3]  ^ prbs_in[4]  ^ prbs_in[5]  ^ prbs_in[6]  ;
                                     expected_data[2]  <= prbs_in[4]  ^ prbs_in[5]  ^ prbs_in[6]  ^ prbs_in[7]  ;
                                     expected_data[3]  <= prbs_in[5]  ^ prbs_in[6]  ^ prbs_in[7]  ^ prbs_in[8]  ;
                                     expected_data[4]  <= prbs_in[6]  ^ prbs_in[7]  ^ prbs_in[8]  ^ prbs_in[9]  ;
                                     expected_data[5]  <= prbs_in[7]  ^ prbs_in[8]  ^ prbs_in[9]  ^ prbs_in[10] ;
                                     expected_data[6]  <= prbs_in[8]  ^ prbs_in[9]  ^ prbs_in[10] ^ prbs_in[11] ;
                                     expected_data[7]  <= prbs_in[9]  ^ prbs_in[10] ^ prbs_in[11] ^ prbs_in[12] ;
                                     expected_data[8]  <= prbs_in[10] ^ prbs_in[11] ^ prbs_in[12] ^ prbs_in[13] ;
                                     expected_data[9]  <= prbs_in[11] ^ prbs_in[12] ^ prbs_in[13] ^ prbs_in[14] ;
                                     expected_data[10] <= prbs_in[0]  ^ prbs_in[12] ^ prbs_in[13] ;
                                     expected_data[11] <= prbs_in[1]  ^ prbs_in[13] ^ prbs_in[14] ;
                                     expected_data[12] <= prbs_in[0]  ^ prbs_in[2]  ;
                                     expected_data[13] <= prbs_in[1]  ^ prbs_in[3]  ;
                                     expected_data[14] <= prbs_in[2]  ^ prbs_in[4]  ;
                                     expected_data[15] <= prbs_in[3]  ^ prbs_in[5]  ;
                                     expected_data[16] <= prbs_in[4]  ^ prbs_in[6]  ;
                                     expected_data[17] <= prbs_in[5]  ^ prbs_in[7]  ;
                                     expected_data[18] <= prbs_in[6]  ^ prbs_in[8]  ;
                                     expected_data[19] <= prbs_in[7]  ^ prbs_in[9]  ;
                                     expected_data[20] <= prbs_in[8]  ^ prbs_in[10] ;
                                     expected_data[21] <= prbs_in[9]  ^ prbs_in[11] ;
                                     expected_data[22] <= prbs_in[10] ^ prbs_in[12] ;
                                     expected_data[23] <= prbs_in[11] ^ prbs_in[13] ;
                                     expected_data[24] <= prbs_in[12] ^ prbs_in[14] ;
                                     expected_data[25] <= prbs_in[0]  ^ prbs_in[13] ^ prbs_in[14] ;
                                     expected_data[26] <= prbs_in[0]  ^ prbs_in[1]  ;
                                     expected_data[27] <= prbs_in[1]  ^ prbs_in[2]  ;
                                     expected_data[28] <= prbs_in[2]  ^ prbs_in[3]  ;
                                     expected_data[29] <= prbs_in[3]  ^ prbs_in[4]  ;
                                     expected_data[30] <= prbs_in[4]  ^ prbs_in[5]  ;
                                     expected_data[31] <= prbs_in[5]  ^ prbs_in[6]  ;
                                     expected_data[32] <= prbs_in[6]  ^ prbs_in[7]  ;
                                     expected_data[33] <= prbs_in[7]  ^ prbs_in[8]  ;
                                     expected_data[34] <= prbs_in[8]  ^ prbs_in[9]  ;
                                     expected_data[35] <= prbs_in[9]  ^ prbs_in[10] ;
                                     expected_data[36] <= prbs_in[10] ^ prbs_in[11] ;
                                     expected_data[37] <= prbs_in[11] ^ prbs_in[12] ;
                                     expected_data[38] <= prbs_in[12] ^ prbs_in[13] ;
                                     expected_data[39] <= prbs_in[13] ^ prbs_in[14] ;
                                 end
							end
							SEL_PRBS_23 : begin
								// PRBS 2^23-1 (T[23,18]) (parallel 40-bit serializer)
							    if ( update_prbs_expt_data) begin	
                                     expected_data[0]  <= prbs_in[6]  ^ prbs_in[14] ^ prbs_in[19] ;
                                     expected_data[1]  <= prbs_in[7]  ^ prbs_in[15] ^ prbs_in[20] ;
                                     expected_data[2]  <= prbs_in[8]  ^ prbs_in[16] ^ prbs_in[21] ;
                                     expected_data[3]  <= prbs_in[9]  ^ prbs_in[17] ^ prbs_in[22] ;
                                     expected_data[4]  <= prbs_in[0]  ^ prbs_in[10] ;
                                     expected_data[5]  <= prbs_in[1]  ^ prbs_in[11] ;
                                     expected_data[6]  <= prbs_in[2]  ^ prbs_in[12] ;
                                     expected_data[7]  <= prbs_in[3]  ^ prbs_in[13] ;
                                     expected_data[8]  <= prbs_in[4]  ^ prbs_in[14] ;
                                     expected_data[9]  <= prbs_in[5]  ^ prbs_in[15] ;
                                     expected_data[10] <= prbs_in[6]  ^ prbs_in[16] ;
                                     expected_data[11] <= prbs_in[7]  ^ prbs_in[17] ;
                                     expected_data[12] <= prbs_in[8]  ^ prbs_in[18] ;
                                     expected_data[13] <= prbs_in[9]  ^ prbs_in[19] ;
                                     expected_data[14] <= prbs_in[10] ^ prbs_in[20] ;
                                     expected_data[15] <= prbs_in[11] ^ prbs_in[21] ;
                                     expected_data[16] <= prbs_in[12] ^ prbs_in[22] ;
                                     expected_data[17] <= prbs_in[0]  ^ prbs_in[13] ^ prbs_in[18] ;
                                     expected_data[18] <= prbs_in[1]  ^ prbs_in[14] ^ prbs_in[19] ;
                                     expected_data[19] <= prbs_in[2]  ^ prbs_in[15] ^ prbs_in[20] ;
                                     expected_data[20] <= prbs_in[3]  ^ prbs_in[16] ^ prbs_in[21] ;
                                     expected_data[21] <= prbs_in[4]  ^ prbs_in[17] ^ prbs_in[22] ;
                                     expected_data[22] <= prbs_in[0]  ^ prbs_in[5]  ;
                                     expected_data[23] <= prbs_in[1]  ^ prbs_in[6]  ;
                                     expected_data[24] <= prbs_in[2]  ^ prbs_in[7]  ;
                                     expected_data[25] <= prbs_in[3]  ^ prbs_in[8]  ;
                                     expected_data[26] <= prbs_in[4]  ^ prbs_in[9]  ;
                                     expected_data[27] <= prbs_in[5]  ^ prbs_in[10] ;
                                     expected_data[28] <= prbs_in[6]  ^ prbs_in[11] ;
                                     expected_data[29] <= prbs_in[7]  ^ prbs_in[12] ;
                                     expected_data[30] <= prbs_in[8]  ^ prbs_in[13] ;
                                     expected_data[31] <= prbs_in[9]  ^ prbs_in[14] ;
                                     expected_data[32] <= prbs_in[10] ^ prbs_in[15] ;
                                     expected_data[33] <= prbs_in[11] ^ prbs_in[16] ;
                                     expected_data[34] <= prbs_in[12] ^ prbs_in[17] ;
                                     expected_data[35] <= prbs_in[13] ^ prbs_in[18] ;
                                     expected_data[36] <= prbs_in[14] ^ prbs_in[19] ;
                                     expected_data[37] <= prbs_in[15] ^ prbs_in[20] ;
                                     expected_data[38] <= prbs_in[16] ^ prbs_in[21] ;
                                     expected_data[39] <= prbs_in[17] ^ prbs_in[22] ;
                                end
							end
							SEL_PRBS_31 : begin
                            // PRBS 2^31-1 (T[31,28]) (parallel 40-bit serializer)
                                if ( update_prbs_expt_data) begin 
                                     expected_data[0]  <= prbs_in[16] ^ prbs_in[22] ;
                                     expected_data[1]  <= prbs_in[17] ^ prbs_in[23] ;
                                     expected_data[2]  <= prbs_in[18] ^ prbs_in[24] ;
                                     expected_data[3]  <= prbs_in[19] ^ prbs_in[25] ;
                                     expected_data[4]  <= prbs_in[20] ^ prbs_in[26] ;
                                     expected_data[5]  <= prbs_in[21] ^ prbs_in[27] ;
                                     expected_data[6]  <= prbs_in[22] ^ prbs_in[28] ;
                                     expected_data[7]  <= prbs_in[23] ^ prbs_in[29] ;
                                     expected_data[8]  <= prbs_in[24] ^ prbs_in[30] ;
                                     expected_data[9]  <= prbs_in[0]  ^ prbs_in[25] ^ prbs_in[28] ;
                                     expected_data[10] <= prbs_in[1]  ^ prbs_in[26] ^ prbs_in[29] ;
                                     expected_data[11] <= prbs_in[2]  ^ prbs_in[27] ^ prbs_in[30] ;
                                     expected_data[12] <= prbs_in[0]  ^ prbs_in[3]  ;
                                     expected_data[13] <= prbs_in[1]  ^ prbs_in[4]  ;
                                     expected_data[14] <= prbs_in[2]  ^ prbs_in[5]  ;
                                     expected_data[15] <= prbs_in[3]  ^ prbs_in[6]  ;
                                     expected_data[16] <= prbs_in[4]  ^ prbs_in[7]  ;
                                     expected_data[17] <= prbs_in[5]  ^ prbs_in[8]  ;
                                     expected_data[18] <= prbs_in[6]  ^ prbs_in[9]  ;
                                     expected_data[19] <= prbs_in[7]  ^ prbs_in[10] ;
                                     expected_data[20] <= prbs_in[8]  ^ prbs_in[11] ;
                                     expected_data[21] <= prbs_in[9]  ^ prbs_in[12] ;
                                     expected_data[22] <= prbs_in[10] ^ prbs_in[13] ;
                                     expected_data[23] <= prbs_in[11] ^ prbs_in[14] ;
                                     expected_data[24] <= prbs_in[12] ^ prbs_in[15] ;
                                     expected_data[25] <= prbs_in[13] ^ prbs_in[16] ;
                                     expected_data[26] <= prbs_in[14] ^ prbs_in[17] ;
                                     expected_data[27] <= prbs_in[15] ^ prbs_in[18] ;
                                     expected_data[28] <= prbs_in[16] ^ prbs_in[19] ;
                                     expected_data[29] <= prbs_in[17] ^ prbs_in[20] ;
                                     expected_data[30] <= prbs_in[18] ^ prbs_in[21] ;
                                     expected_data[31] <= prbs_in[19] ^ prbs_in[22] ;
                                     expected_data[32] <= prbs_in[20] ^ prbs_in[23] ;
                                     expected_data[33] <= prbs_in[21] ^ prbs_in[24] ;
                                     expected_data[34] <= prbs_in[22] ^ prbs_in[25] ;
                                     expected_data[35] <= prbs_in[23] ^ prbs_in[26] ;
                                     expected_data[36] <= prbs_in[24] ^ prbs_in[27] ;
                                     expected_data[37] <= prbs_in[25] ^ prbs_in[28] ;
                                     expected_data[38] <= prbs_in[26] ^ prbs_in[29] ;
                                     expected_data[39] <= prbs_in[27] ^ prbs_in[30] ;
                                end
                            end
                        default: begin
                            expected_data <= expected_data;
                        end
                      endcase
                end // end else
            end // end always
        end 
		if (ST_DATA_W == 50) begin
		       always @(posedge asi_clk or posedge reset_sync) begin
                if (reset_sync) begin
                    expected_data <= 'b0;
                end else begin
                       // pattern_select does not need to be synchronized to asi_clk
                       // because the value does not change when the component is enabled
                       case (pattern_select)
							SEL_HIGH_FREQ: begin
								if ( update_hflf_expt_data) begin
                                    if ( buffered_data == 50'h2_AAAA_AAAA_AAAA | buffered_data ==  50'h1_5555_5555_5555) begin
                                        expected_data <= buffered_data;
                                    end else begin
                                        expected_data <= 'b0;
                                    end
								end
							end
						    SEL_LOW_FREQ: begin
									if ( update_hflf_expt_data) begin
										if(buffered_data == 50'h1F07C1F07C1F0 	|| buffered_data == 50'hF83E0F83E0F8
										|| buffered_data == 50'h7C1F07C1F07C 	|| buffered_data == 50'h3E0F83E0F83E
										|| buffered_data == 50'h1F07C1F07C1F 	|| buffered_data == 50'h20F83E0F83E0F
										|| buffered_data == 50'h307C1F07C1F07 	|| buffered_data == 50'h383E0F83E0F83
										|| buffered_data == 50'h3C1F07C1F07C1	|| buffered_data == 50'h3_E0F8_3E0F_83E0) begin
											expected_data <= buffered_data;
										end else
                                            expected_data <= 0;
									end
							end
							SEL_PRBS_7 : begin
                            // prbs_in 2^7-1 (T[7,6]) (parallel 50-bit serializer)
                                if ( update_prbs_expt_data ) begin 
                                     expected_data[0] <=  prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[1] <=  prbs_in[0] ^ prbs_in[5] ; 
                                     expected_data[2] <=  prbs_in[1] ^ prbs_in[6] ; 
                                     expected_data[3] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[6] ; 
                                     expected_data[4] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[5] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[6] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[7] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[8] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[9] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[10] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[11] <=  prbs_in[1] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[12] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[5] ; 
                                     expected_data[13] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[14] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[15] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[16] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ; 
                                     expected_data[17] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ; 
                                     expected_data[18] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[19] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[20] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[21] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[22] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[23] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[24] <=  prbs_in[2] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[25] <=  prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[26] <=  prbs_in[0] ^ prbs_in[4] ; 
                                     expected_data[27] <=  prbs_in[1] ^ prbs_in[5] ; 
                                     expected_data[28] <=  prbs_in[2] ^ prbs_in[6] ; 
                                     expected_data[29] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[30] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[31] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[32] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[33] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[34] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[35] <=  prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[36] <=  prbs_in[0] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[37] <=  prbs_in[1] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[38] <=  prbs_in[0] ^ prbs_in[2] ; 
                                     expected_data[39] <=  prbs_in[1] ^ prbs_in[3] ; 
                                     expected_data[40] <=  prbs_in[2] ^ prbs_in[4] ; 
                                     expected_data[41] <=  prbs_in[3] ^ prbs_in[5] ; 
                                     expected_data[42] <=  prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[43] <=  prbs_in[0] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[44] <=  prbs_in[0] ^ prbs_in[1] ; 
                                     expected_data[45] <=  prbs_in[1] ^ prbs_in[2] ; 
                                     expected_data[46] <=  prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[47] <=  prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[48] <=  prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[49] <=  prbs_in[5] ^ prbs_in[6] ; 
                                end
                            end
							SEL_PRBS_15 : begin
                            // prbs_in 2^15 (T[15, 14]) (parallel 50-bit serializer)
                                if ( update_prbs_expt_data ) begin
                                     expected_data[0] <=  prbs_in[6] ^ prbs_in[10] ; 
                                     expected_data[1] <=  prbs_in[7] ^ prbs_in[11] ; 
                                     expected_data[2] <=  prbs_in[8] ^ prbs_in[12] ; 
                                     expected_data[3] <=  prbs_in[9] ^ prbs_in[13] ; 
                                     expected_data[4] <=  prbs_in[10] ^ prbs_in[14] ; 
                                     expected_data[5] <=  prbs_in[0] ^ prbs_in[11] ^ prbs_in[14] ; 
                                     expected_data[6] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[12] ^ prbs_in[14] ; 
                                     expected_data[7] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[8] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[9] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[10] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[11] <=  prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[12] <=  prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ^ prbs_in[7] ; 
                                     expected_data[13] <=  prbs_in[5] ^ prbs_in[6] ^ prbs_in[7] ^ prbs_in[8] ; 
                                     expected_data[14] <=  prbs_in[6] ^ prbs_in[7] ^ prbs_in[8] ^ prbs_in[9] ; 
                                     expected_data[15] <=  prbs_in[7] ^ prbs_in[8] ^ prbs_in[9] ^ prbs_in[10] ; 
                                     expected_data[16] <=  prbs_in[8] ^ prbs_in[9] ^ prbs_in[10] ^ prbs_in[11] ; 
                                     expected_data[17] <=  prbs_in[9] ^ prbs_in[10] ^ prbs_in[11] ^ prbs_in[12] ; 
                                     expected_data[18] <=  prbs_in[10] ^ prbs_in[11] ^ prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[19] <=  prbs_in[11] ^ prbs_in[12] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[20] <=  prbs_in[0] ^ prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[21] <=  prbs_in[1] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[22] <=  prbs_in[0] ^ prbs_in[2] ; 
                                     expected_data[23] <=  prbs_in[1] ^ prbs_in[3] ; 
                                     expected_data[24] <=  prbs_in[2] ^ prbs_in[4] ; 
                                     expected_data[25] <=  prbs_in[3] ^ prbs_in[5] ; 
                                     expected_data[26] <=  prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[27] <=  prbs_in[5] ^ prbs_in[7] ; 
                                     expected_data[28] <=  prbs_in[6] ^ prbs_in[8] ; 
                                     expected_data[29] <=  prbs_in[7] ^ prbs_in[9] ; 
                                     expected_data[30] <=  prbs_in[8] ^ prbs_in[10] ; 
                                     expected_data[31] <=  prbs_in[9] ^ prbs_in[11] ; 
                                     expected_data[32] <=  prbs_in[10] ^ prbs_in[12] ; 
                                     expected_data[33] <=  prbs_in[11] ^ prbs_in[13] ; 
                                     expected_data[34] <=  prbs_in[12] ^ prbs_in[14] ; 
                                     expected_data[35] <=  prbs_in[0] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[36] <=  prbs_in[0] ^ prbs_in[1] ; 
                                     expected_data[37] <=  prbs_in[1] ^ prbs_in[2] ; 
                                     expected_data[38] <=  prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[39] <=  prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[40] <=  prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[41] <=  prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[42] <=  prbs_in[6] ^ prbs_in[7] ; 
                                     expected_data[43] <=  prbs_in[7] ^ prbs_in[8] ; 
                                     expected_data[44] <=  prbs_in[8] ^ prbs_in[9] ; 
                                     expected_data[45] <=  prbs_in[9] ^ prbs_in[10] ; 
                                     expected_data[46] <=  prbs_in[10] ^ prbs_in[11] ; 
                                     expected_data[47] <=  prbs_in[11] ^ prbs_in[12] ; 
                                     expected_data[48] <=  prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[49] <=  prbs_in[13] ^ prbs_in[14] ; 
                                end
                            end
							SEL_PRBS_23 : begin
                            // prbs_in 2^23-1 (T[23,18]) (parallel 50-bit serializer)
                                if ( update_prbs_expt_data ) begin
                                     expected_data[0] <=  prbs_in[4] ^ prbs_in[9] ^ prbs_in[14] ^ prbs_in[19] ; 
                                     expected_data[1] <=  prbs_in[5] ^ prbs_in[10] ^ prbs_in[15] ^ prbs_in[20] ; 
                                     expected_data[2] <=  prbs_in[6] ^ prbs_in[11] ^ prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[3] <=  prbs_in[7] ^ prbs_in[12] ^ prbs_in[17] ^ prbs_in[22] ; 
                                     expected_data[4] <=  prbs_in[0] ^ prbs_in[8] ^ prbs_in[13] ; 
                                     expected_data[5] <=  prbs_in[1] ^ prbs_in[9] ^ prbs_in[14] ; 
                                     expected_data[6] <=  prbs_in[2] ^ prbs_in[10] ^ prbs_in[15] ; 
                                     expected_data[7] <=  prbs_in[3] ^ prbs_in[11] ^ prbs_in[16] ; 
                                     expected_data[8] <=  prbs_in[4] ^ prbs_in[12] ^ prbs_in[17] ; 
                                     expected_data[9] <=  prbs_in[5] ^ prbs_in[13] ^ prbs_in[18] ; 
                                     expected_data[10] <=  prbs_in[6] ^ prbs_in[14] ^ prbs_in[19] ; 
                                     expected_data[11] <=  prbs_in[7] ^ prbs_in[15] ^ prbs_in[20] ; 
                                     expected_data[12] <=  prbs_in[8] ^ prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[13] <=  prbs_in[9] ^ prbs_in[17] ^ prbs_in[22] ; 
                                     expected_data[14] <=  prbs_in[0] ^ prbs_in[10] ; 
                                     expected_data[15] <=  prbs_in[1] ^ prbs_in[11] ; 
                                     expected_data[16] <=  prbs_in[2] ^ prbs_in[12] ; 
                                     expected_data[17] <=  prbs_in[3] ^ prbs_in[13] ; 
                                     expected_data[18] <=  prbs_in[4] ^ prbs_in[14] ; 
                                     expected_data[19] <=  prbs_in[5] ^ prbs_in[15] ; 
                                     expected_data[20] <=  prbs_in[6] ^ prbs_in[16] ; 
                                     expected_data[21] <=  prbs_in[7] ^ prbs_in[17] ; 
                                     expected_data[22] <=  prbs_in[8] ^ prbs_in[18] ; 
                                     expected_data[23] <=  prbs_in[9] ^ prbs_in[19] ; 
                                     expected_data[24] <=  prbs_in[10] ^ prbs_in[20] ; 
                                     expected_data[25] <=  prbs_in[11] ^ prbs_in[21] ; 
                                     expected_data[26] <=  prbs_in[12] ^ prbs_in[22] ; 
                                     expected_data[27] <=  prbs_in[0] ^ prbs_in[13] ^ prbs_in[18] ; 
                                     expected_data[28] <=  prbs_in[1] ^ prbs_in[14] ^ prbs_in[19] ; 
                                     expected_data[29] <=  prbs_in[2] ^ prbs_in[15] ^ prbs_in[20] ; 
                                     expected_data[30] <=  prbs_in[3] ^ prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[31] <=  prbs_in[4] ^ prbs_in[17] ^ prbs_in[22] ; 
                                     expected_data[32] <=  prbs_in[0] ^ prbs_in[5] ; 
                                     expected_data[33] <=  prbs_in[1] ^ prbs_in[6] ; 
                                     expected_data[34] <=  prbs_in[2] ^ prbs_in[7] ; 
                                     expected_data[35] <=  prbs_in[3] ^ prbs_in[8] ; 
                                     expected_data[36] <=  prbs_in[4] ^ prbs_in[9] ; 
                                     expected_data[37] <=  prbs_in[5] ^ prbs_in[10] ; 
                                     expected_data[38] <=  prbs_in[6] ^ prbs_in[11] ; 
                                     expected_data[39] <=  prbs_in[7] ^ prbs_in[12] ; 
                                     expected_data[40] <=  prbs_in[8] ^ prbs_in[13] ; 
                                     expected_data[41] <=  prbs_in[9] ^ prbs_in[14] ; 
                                     expected_data[42] <=  prbs_in[10] ^ prbs_in[15] ; 
                                     expected_data[43] <=  prbs_in[11] ^ prbs_in[16] ; 
                                     expected_data[44] <=  prbs_in[12] ^ prbs_in[17] ; 
                                     expected_data[45] <=  prbs_in[13] ^ prbs_in[18] ; 
                                     expected_data[46] <=  prbs_in[14] ^ prbs_in[19] ; 
                                     expected_data[47] <=  prbs_in[15] ^ prbs_in[20] ; 
                                     expected_data[48] <=  prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[49] <=  prbs_in[17] ^ prbs_in[22] ; 
                                end
                            end
							SEL_PRBS_31 : begin
                            // prbs_in 2^31-1 (T[31,28]) (parallel 50-bit serializer)
                                if ( update_prbs_expt_data ) begin 
                                     expected_data[0] <=  prbs_in[6] ^ prbs_in[12] ; 
                                     expected_data[1] <=  prbs_in[7] ^ prbs_in[13] ; 
                                     expected_data[2] <=  prbs_in[8] ^ prbs_in[14] ; 
                                     expected_data[3] <=  prbs_in[9] ^ prbs_in[15] ; 
                                     expected_data[4] <=  prbs_in[10] ^ prbs_in[16] ; 
                                     expected_data[5] <=  prbs_in[11] ^ prbs_in[17] ; 
                                     expected_data[6] <=  prbs_in[12] ^ prbs_in[18] ; 
                                     expected_data[7] <=  prbs_in[13] ^ prbs_in[19] ; 
                                     expected_data[8] <=  prbs_in[14] ^ prbs_in[20] ; 
                                     expected_data[9] <=  prbs_in[15] ^ prbs_in[21] ; 
                                     expected_data[10] <=  prbs_in[16] ^ prbs_in[22] ; 
                                     expected_data[11] <=  prbs_in[17] ^ prbs_in[23] ; 
                                     expected_data[12] <=  prbs_in[18] ^ prbs_in[24] ; 
                                     expected_data[13] <=  prbs_in[19] ^ prbs_in[25] ; 
                                     expected_data[14] <=  prbs_in[20] ^ prbs_in[26] ; 
                                     expected_data[15] <=  prbs_in[21] ^ prbs_in[27] ; 
                                     expected_data[16] <=  prbs_in[22] ^ prbs_in[28] ; 
                                     expected_data[17] <=  prbs_in[23] ^ prbs_in[29] ; 
                                     expected_data[18] <=  prbs_in[24] ^ prbs_in[30] ; 
                                     expected_data[19] <=  prbs_in[0] ^ prbs_in[25] ^ prbs_in[28] ; 
                                     expected_data[20] <=  prbs_in[1] ^ prbs_in[26] ^ prbs_in[29] ; 
                                     expected_data[21] <=  prbs_in[2] ^ prbs_in[27] ^ prbs_in[30] ; 
                                     expected_data[22] <=  prbs_in[0] ^ prbs_in[3] ; 
                                     expected_data[23] <=  prbs_in[1] ^ prbs_in[4] ; 
                                     expected_data[24] <=  prbs_in[2] ^ prbs_in[5] ; 
                                     expected_data[25] <=  prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[26] <=  prbs_in[4] ^ prbs_in[7] ; 
                                     expected_data[27] <=  prbs_in[5] ^ prbs_in[8] ; 
                                     expected_data[28] <=  prbs_in[6] ^ prbs_in[9] ; 
                                     expected_data[29] <=  prbs_in[7] ^ prbs_in[10] ; 
                                     expected_data[30] <=  prbs_in[8] ^ prbs_in[11] ; 
                                     expected_data[31] <=  prbs_in[9] ^ prbs_in[12] ; 
                                     expected_data[32] <=  prbs_in[10] ^ prbs_in[13] ; 
                                     expected_data[33] <=  prbs_in[11] ^ prbs_in[14] ; 
                                     expected_data[34] <=  prbs_in[12] ^ prbs_in[15] ; 
                                     expected_data[35] <=  prbs_in[13] ^ prbs_in[16] ; 
                                     expected_data[36] <=  prbs_in[14] ^ prbs_in[17] ; 
                                     expected_data[37] <=  prbs_in[15] ^ prbs_in[18] ; 
                                     expected_data[38] <=  prbs_in[16] ^ prbs_in[19] ; 
                                     expected_data[39] <=  prbs_in[17] ^ prbs_in[20] ; 
                                     expected_data[40] <=  prbs_in[18] ^ prbs_in[21] ; 
                                     expected_data[41] <=  prbs_in[19] ^ prbs_in[22] ; 
                                     expected_data[42] <=  prbs_in[20] ^ prbs_in[23] ; 
                                     expected_data[43] <=  prbs_in[21] ^ prbs_in[24] ; 
                                     expected_data[44] <=  prbs_in[22] ^ prbs_in[25] ; 
                                     expected_data[45] <=  prbs_in[23] ^ prbs_in[26] ; 
                                     expected_data[46] <=  prbs_in[24] ^ prbs_in[27] ; 
                                     expected_data[47] <=  prbs_in[25] ^ prbs_in[28] ; 
                                     expected_data[48] <=  prbs_in[26] ^ prbs_in[29] ; 
                                     expected_data[49] <=  prbs_in[27] ^ prbs_in[30] ; 
                                 end
                            end
							default: begin
								expected_data <= expected_data;
							end
                      endcase
                end // end else
            end // end always
        end // end if ST_DATA_W
		if (ST_DATA_W == 64) begin
            always @(posedge asi_clk or posedge reset_sync) begin
                if (reset_sync) begin
                    expected_data <= 'b0;
                end else begin
						// pattern_select does not need to be synchronized to asi_clk
						// because the value does not change when the component is enabled
						case (pattern_select)
							SEL_HIGH_FREQ: begin
								if ( update_hflf_expt_data ) begin
									if(buffered_data == 64'h5555_5555_5555_5555 || buffered_data ==  64'hAAAA_AAAA_AAAA_AAAA) begin
										expected_data <= buffered_data;
									end else begin
										expected_data <= 64'h0;
									end
								end
							end
							SEL_LOW_FREQ: begin
								if ( update_hflf_expt_data) begin
									if (buffered_data == 64'hE1E1_E1E1_E1E1_E1E1 || buffered_data == 64'hC3C3_C3C3_C3C3_C3C3
									|| buffered_data == 64'h8787_8787_8787_8787 || buffered_data == 64'h0F0F_0F0F_0F0F_0F0F
									|| buffered_data == 64'h1E1E_1E1E_1E1E_1E1E || buffered_data == 64'h3C3C_3C3C_3C3C_3C3C
									|| buffered_data == 64'h7878_7878_7878_7878 || buffered_data == 64'hF0F0_F0F0_F0F0_F0F0) begin
										expected_data <= buffered_data;
									end else begin
										expected_data <= 64'h0;
									end
								end
							end
							SEL_PRBS_7 : begin
                            // prbs_in 2^7-1 (T[7,6]) (parallel 64-bit serializer)
                                if ( update_prbs_expt_data ) begin
                                     expected_data[0] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[1] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[2] <=  prbs_in[1] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[3] <=  prbs_in[2] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[4] <=  prbs_in[0] ^ prbs_in[3] ; 
                                     expected_data[5] <=  prbs_in[1] ^ prbs_in[4] ; 
                                     expected_data[6] <=  prbs_in[2] ^ prbs_in[5] ; 
                                     expected_data[7] <=  prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[8] <=  prbs_in[0] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[9] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[10] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ; 
                                     expected_data[11] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[12] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[13] <=  prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[14] <=  prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[15] <=  prbs_in[0] ^ prbs_in[5] ; 
                                     expected_data[16] <=  prbs_in[1] ^ prbs_in[6] ; 
                                     expected_data[17] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[6] ; 
                                     expected_data[18] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[19] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[20] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[21] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[22] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[23] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[24] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[25] <=  prbs_in[1] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[26] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[5] ; 
                                     expected_data[27] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[28] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[29] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[30] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ; 
                                     expected_data[31] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ; 
                                     expected_data[32] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[33] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[34] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[35] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[36] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[37] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[38] <=  prbs_in[2] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[39] <=  prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[40] <=  prbs_in[0] ^ prbs_in[4] ; 
                                     expected_data[41] <=  prbs_in[1] ^ prbs_in[5] ; 
                                     expected_data[42] <=  prbs_in[2] ^ prbs_in[6] ; 
                                     expected_data[43] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[44] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[45] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[46] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[47] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[48] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[49] <=  prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[50] <=  prbs_in[0] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[51] <=  prbs_in[1] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[52] <=  prbs_in[0] ^ prbs_in[2] ; 
                                     expected_data[53] <=  prbs_in[1] ^ prbs_in[3] ; 
                                     expected_data[54] <=  prbs_in[2] ^ prbs_in[4] ; 
                                     expected_data[55] <=  prbs_in[3] ^ prbs_in[5] ; 
                                     expected_data[56] <=  prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[57] <=  prbs_in[0] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[58] <=  prbs_in[0] ^ prbs_in[1] ; 
                                     expected_data[59] <=  prbs_in[1] ^ prbs_in[2] ; 
                                     expected_data[60] <=  prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[61] <=  prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[62] <=  prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[63] <=  prbs_in[5] ^ prbs_in[6] ; 
                                end
                            end
							SEL_PRBS_15 : begin
                            // prbs_in 2^15 (T[15, 14]) (parallel 64-bit serializer)
                                if ( update_prbs_expt_data ) begin
                                     expected_data[0] <=  prbs_in[6] ^ prbs_in[7] ^ prbs_in[10] ^ prbs_in[11] ; 
                                     expected_data[1] <=  prbs_in[7] ^ prbs_in[8] ^ prbs_in[11] ^ prbs_in[12] ; 
                                     expected_data[2] <=  prbs_in[8] ^ prbs_in[9] ^ prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[3] <=  prbs_in[9] ^ prbs_in[10] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[4] <=  prbs_in[0] ^ prbs_in[10] ^ prbs_in[11] ; 
                                     expected_data[5] <=  prbs_in[1] ^ prbs_in[11] ^ prbs_in[12] ; 
                                     expected_data[6] <=  prbs_in[2] ^ prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[7] <=  prbs_in[3] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[8] <=  prbs_in[0] ^ prbs_in[4] ; 
                                     expected_data[9] <=  prbs_in[1] ^ prbs_in[5] ; 
                                     expected_data[10] <=  prbs_in[2] ^ prbs_in[6] ; 
                                     expected_data[11] <=  prbs_in[3] ^ prbs_in[7] ; 
                                     expected_data[12] <=  prbs_in[4] ^ prbs_in[8] ; 
                                     expected_data[13] <=  prbs_in[5] ^ prbs_in[9] ; 
                                     expected_data[14] <=  prbs_in[6] ^ prbs_in[10] ; 
                                     expected_data[15] <=  prbs_in[7] ^ prbs_in[11] ; 
                                     expected_data[16] <=  prbs_in[8] ^ prbs_in[12] ; 
                                     expected_data[17] <=  prbs_in[9] ^ prbs_in[13] ; 
                                     expected_data[18] <=  prbs_in[10] ^ prbs_in[14] ; 
                                     expected_data[19] <=  prbs_in[0] ^ prbs_in[11] ^ prbs_in[14] ; 
                                     expected_data[20] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[12] ^ prbs_in[14] ; 
                                     expected_data[21] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[22] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[23] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[24] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[25] <=  prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[26] <=  prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ^ prbs_in[7] ; 
                                     expected_data[27] <=  prbs_in[5] ^ prbs_in[6] ^ prbs_in[7] ^ prbs_in[8] ; 
                                     expected_data[28] <=  prbs_in[6] ^ prbs_in[7] ^ prbs_in[8] ^ prbs_in[9] ; 
                                     expected_data[29] <=  prbs_in[7] ^ prbs_in[8] ^ prbs_in[9] ^ prbs_in[10] ; 
                                     expected_data[30] <=  prbs_in[8] ^ prbs_in[9] ^ prbs_in[10] ^ prbs_in[11] ; 
                                     expected_data[31] <=  prbs_in[9] ^ prbs_in[10] ^ prbs_in[11] ^ prbs_in[12] ; 
                                     expected_data[32] <=  prbs_in[10] ^ prbs_in[11] ^ prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[33] <=  prbs_in[11] ^ prbs_in[12] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[34] <=  prbs_in[0] ^ prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[35] <=  prbs_in[1] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[36] <=  prbs_in[0] ^ prbs_in[2] ; 
                                     expected_data[37] <=  prbs_in[1] ^ prbs_in[3] ; 
                                     expected_data[38] <=  prbs_in[2] ^ prbs_in[4] ; 
                                     expected_data[39] <=  prbs_in[3] ^ prbs_in[5] ; 
                                     expected_data[40] <=  prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[41] <=  prbs_in[5] ^ prbs_in[7] ; 
                                     expected_data[42] <=  prbs_in[6] ^ prbs_in[8] ; 
                                     expected_data[43] <=  prbs_in[7] ^ prbs_in[9] ; 
                                     expected_data[44] <=  prbs_in[8] ^ prbs_in[10] ; 
                                     expected_data[45] <=  prbs_in[9] ^ prbs_in[11] ; 
                                     expected_data[46] <=  prbs_in[10] ^ prbs_in[12] ; 
                                     expected_data[47] <=  prbs_in[11] ^ prbs_in[13] ; 
                                     expected_data[48] <=  prbs_in[12] ^ prbs_in[14] ; 
                                     expected_data[49] <=  prbs_in[0] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[50] <=  prbs_in[0] ^ prbs_in[1] ; 
                                     expected_data[51] <=  prbs_in[1] ^ prbs_in[2] ; 
                                     expected_data[52] <=  prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[53] <=  prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[54] <=  prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[55] <=  prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[56] <=  prbs_in[6] ^ prbs_in[7] ; 
                                     expected_data[57] <=  prbs_in[7] ^ prbs_in[8] ; 
                                     expected_data[58] <=  prbs_in[8] ^ prbs_in[9] ; 
                                     expected_data[59] <=  prbs_in[9] ^ prbs_in[10] ; 
                                     expected_data[60] <=  prbs_in[10] ^ prbs_in[11] ; 
                                     expected_data[61] <=  prbs_in[11] ^ prbs_in[12] ; 
                                     expected_data[62] <=  prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[63] <=  prbs_in[13] ^ prbs_in[14] ; 
                                end
                            end
							SEL_PRBS_23 : begin
                            // prbs_in 2^23-1 (T[23,18]) (parallel 64-bit serializer)
                                if ( update_prbs_expt_data ) begin
                                     expected_data[0] <=  prbs_in[0] ^ prbs_in[5] ^ prbs_in[8] ^ prbs_in[18] ; 
                                     expected_data[1] <=  prbs_in[1] ^ prbs_in[6] ^ prbs_in[9] ^ prbs_in[19] ; 
                                     expected_data[2] <=  prbs_in[2] ^ prbs_in[7] ^ prbs_in[10] ^ prbs_in[20] ; 
                                     expected_data[3] <=  prbs_in[3] ^ prbs_in[8] ^ prbs_in[11] ^ prbs_in[21] ; 
                                     expected_data[4] <=  prbs_in[4] ^ prbs_in[9] ^ prbs_in[12] ^ prbs_in[22] ; 
                                     expected_data[5] <=  prbs_in[0] ^ prbs_in[5] ^ prbs_in[10] ^ prbs_in[13] ^ prbs_in[18] ; 
                                     expected_data[6] <=  prbs_in[1] ^ prbs_in[6] ^ prbs_in[11] ^ prbs_in[14] ^ prbs_in[19] ; 
                                     expected_data[7] <=  prbs_in[2] ^ prbs_in[7] ^ prbs_in[12] ^ prbs_in[15] ^ prbs_in[20] ; 
                                     expected_data[8] <=  prbs_in[3] ^ prbs_in[8] ^ prbs_in[13] ^ prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[9] <=  prbs_in[4] ^ prbs_in[9] ^ prbs_in[14] ^ prbs_in[17] ^ prbs_in[22] ; 
                                     expected_data[10] <=  prbs_in[0] ^ prbs_in[5] ^ prbs_in[10] ^ prbs_in[15] ; 
                                     expected_data[11] <=  prbs_in[1] ^ prbs_in[6] ^ prbs_in[11] ^ prbs_in[16] ; 
                                     expected_data[12] <=  prbs_in[2] ^ prbs_in[7] ^ prbs_in[12] ^ prbs_in[17] ; 
                                     expected_data[13] <=  prbs_in[3] ^ prbs_in[8] ^ prbs_in[13] ^ prbs_in[18] ; 
                                     expected_data[14] <=  prbs_in[4] ^ prbs_in[9] ^ prbs_in[14] ^ prbs_in[19] ; 
                                     expected_data[15] <=  prbs_in[5] ^ prbs_in[10] ^ prbs_in[15] ^ prbs_in[20] ; 
                                     expected_data[16] <=  prbs_in[6] ^ prbs_in[11] ^ prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[17] <=  prbs_in[7] ^ prbs_in[12] ^ prbs_in[17] ^ prbs_in[22] ; 
                                     expected_data[18] <=  prbs_in[0] ^ prbs_in[8] ^ prbs_in[13] ; 
                                     expected_data[19] <=  prbs_in[1] ^ prbs_in[9] ^ prbs_in[14] ; 
                                     expected_data[20] <=  prbs_in[2] ^ prbs_in[10] ^ prbs_in[15] ; 
                                     expected_data[21] <=  prbs_in[3] ^ prbs_in[11] ^ prbs_in[16] ; 
                                     expected_data[22] <=  prbs_in[4] ^ prbs_in[12] ^ prbs_in[17] ; 
                                     expected_data[23] <=  prbs_in[5] ^ prbs_in[13] ^ prbs_in[18] ; 
                                     expected_data[24] <=  prbs_in[6] ^ prbs_in[14] ^ prbs_in[19] ; 
                                     expected_data[25] <=  prbs_in[7] ^ prbs_in[15] ^ prbs_in[20] ; 
                                     expected_data[26] <=  prbs_in[8] ^ prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[27] <=  prbs_in[9] ^ prbs_in[17] ^ prbs_in[22] ; 
                                     expected_data[28] <=  prbs_in[0] ^ prbs_in[10] ; 
                                     expected_data[29] <=  prbs_in[1] ^ prbs_in[11] ; 
                                     expected_data[30] <=  prbs_in[2] ^ prbs_in[12] ; 
                                     expected_data[31] <=  prbs_in[3] ^ prbs_in[13] ; 
                                     expected_data[32] <=  prbs_in[4] ^ prbs_in[14] ; 
                                     expected_data[33] <=  prbs_in[5] ^ prbs_in[15] ; 
                                     expected_data[34] <=  prbs_in[6] ^ prbs_in[16] ; 
                                     expected_data[35] <=  prbs_in[7] ^ prbs_in[17] ; 
                                     expected_data[36] <=  prbs_in[8] ^ prbs_in[18] ; 
                                     expected_data[37] <=  prbs_in[9] ^ prbs_in[19] ; 
                                     expected_data[38] <=  prbs_in[10] ^ prbs_in[20] ; 
                                     expected_data[39] <=  prbs_in[11] ^ prbs_in[21] ; 
                                     expected_data[40] <=  prbs_in[12] ^ prbs_in[22] ; 
                                     expected_data[41] <=  prbs_in[0] ^ prbs_in[13] ^ prbs_in[18] ; 
                                     expected_data[42] <=  prbs_in[1] ^ prbs_in[14] ^ prbs_in[19] ; 
                                     expected_data[43] <=  prbs_in[2] ^ prbs_in[15] ^ prbs_in[20] ; 
                                     expected_data[44] <=  prbs_in[3] ^ prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[45] <=  prbs_in[4] ^ prbs_in[17] ^ prbs_in[22] ; 
                                     expected_data[46] <=  prbs_in[0] ^ prbs_in[5] ; 
                                     expected_data[47] <=  prbs_in[1] ^ prbs_in[6] ; 
                                     expected_data[48] <=  prbs_in[2] ^ prbs_in[7] ; 
                                     expected_data[49] <=  prbs_in[3] ^ prbs_in[8] ; 
                                     expected_data[50] <=  prbs_in[4] ^ prbs_in[9] ; 
                                     expected_data[51] <=  prbs_in[5] ^ prbs_in[10] ; 
                                     expected_data[52] <=  prbs_in[6] ^ prbs_in[11] ; 
                                     expected_data[53] <=  prbs_in[7] ^ prbs_in[12] ; 
                                     expected_data[54] <=  prbs_in[8] ^ prbs_in[13] ; 
                                     expected_data[55] <=  prbs_in[9] ^ prbs_in[14] ; 
                                     expected_data[56] <=  prbs_in[10] ^ prbs_in[15] ; 
                                     expected_data[57] <=  prbs_in[11] ^ prbs_in[16] ; 
                                     expected_data[58] <=  prbs_in[12] ^ prbs_in[17] ; 
                                     expected_data[59] <=  prbs_in[13] ^ prbs_in[18] ; 
                                     expected_data[60] <=  prbs_in[14] ^ prbs_in[19] ; 
                                     expected_data[61] <=  prbs_in[15] ^ prbs_in[20] ; 
                                     expected_data[62] <=  prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[63] <=  prbs_in[17] ^ prbs_in[22] ; 
                                end
                            end
							SEL_PRBS_31 : begin
                            // prbs_in 2^31-1 (T[31,28]) (parallel 64-bit serializer)
                                if (update_prbs_expt_data) begin
                                     expected_data[0] <=  prbs_in[20] ^ prbs_in[23] ^ prbs_in[26] ^ prbs_in[29] ; 
                                     expected_data[1] <=  prbs_in[21] ^ prbs_in[24] ^ prbs_in[27] ^ prbs_in[30] ; 
                                     expected_data[2] <=  prbs_in[0] ^ prbs_in[22] ^ prbs_in[25] ; 
                                     expected_data[3] <=  prbs_in[1] ^ prbs_in[23] ^ prbs_in[26] ; 
                                     expected_data[4] <=  prbs_in[2] ^ prbs_in[24] ^ prbs_in[27] ; 
                                     expected_data[5] <=  prbs_in[3] ^ prbs_in[25] ^ prbs_in[28] ; 
                                     expected_data[6] <=  prbs_in[4] ^ prbs_in[26] ^ prbs_in[29] ; 
                                     expected_data[7] <=  prbs_in[5] ^ prbs_in[27] ^ prbs_in[30] ; 
                                     expected_data[8] <=  prbs_in[0] ^ prbs_in[6] ; 
                                     expected_data[9] <=  prbs_in[1] ^ prbs_in[7] ; 
                                     expected_data[10] <=  prbs_in[2] ^ prbs_in[8] ; 
                                     expected_data[11] <=  prbs_in[3] ^ prbs_in[9] ; 
                                     expected_data[12] <=  prbs_in[4] ^ prbs_in[10] ; 
                                     expected_data[13] <=  prbs_in[5] ^ prbs_in[11] ; 
                                     expected_data[14] <=  prbs_in[6] ^ prbs_in[12] ; 
                                     expected_data[15] <=  prbs_in[7] ^ prbs_in[13] ; 
                                     expected_data[16] <=  prbs_in[8] ^ prbs_in[14] ; 
                                     expected_data[17] <=  prbs_in[9] ^ prbs_in[15] ; 
                                     expected_data[18] <=  prbs_in[10] ^ prbs_in[16] ; 
                                     expected_data[19] <=  prbs_in[11] ^ prbs_in[17] ; 
                                     expected_data[20] <=  prbs_in[12] ^ prbs_in[18] ; 
                                     expected_data[21] <=  prbs_in[13] ^ prbs_in[19] ; 
                                     expected_data[22] <=  prbs_in[14] ^ prbs_in[20] ; 
                                     expected_data[23] <=  prbs_in[15] ^ prbs_in[21] ; 
                                     expected_data[24] <=  prbs_in[16] ^ prbs_in[22] ; 
                                     expected_data[25] <=  prbs_in[17] ^ prbs_in[23] ; 
                                     expected_data[26] <=  prbs_in[18] ^ prbs_in[24] ; 
                                     expected_data[27] <=  prbs_in[19] ^ prbs_in[25] ; 
                                     expected_data[28] <=  prbs_in[20] ^ prbs_in[26] ; 
                                     expected_data[29] <=  prbs_in[21] ^ prbs_in[27] ; 
                                     expected_data[30] <=  prbs_in[22] ^ prbs_in[28] ; 
                                     expected_data[31] <=  prbs_in[23] ^ prbs_in[29] ; 
                                     expected_data[32] <=  prbs_in[24] ^ prbs_in[30] ; 
                                     expected_data[33] <=  prbs_in[0] ^ prbs_in[25] ^ prbs_in[28] ; 
                                     expected_data[34] <=  prbs_in[1] ^ prbs_in[26] ^ prbs_in[29] ; 
                                     expected_data[35] <=  prbs_in[2] ^ prbs_in[27] ^ prbs_in[30] ; 
                                     expected_data[36] <=  prbs_in[0] ^ prbs_in[3] ; 
                                     expected_data[37] <=  prbs_in[1] ^ prbs_in[4] ; 
                                     expected_data[38] <=  prbs_in[2] ^ prbs_in[5] ; 
                                     expected_data[39] <=  prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[40] <=  prbs_in[4] ^ prbs_in[7] ; 
                                     expected_data[41] <=  prbs_in[5] ^ prbs_in[8] ; 
                                     expected_data[42] <=  prbs_in[6] ^ prbs_in[9] ; 
                                     expected_data[43] <=  prbs_in[7] ^ prbs_in[10] ; 
                                     expected_data[44] <=  prbs_in[8] ^ prbs_in[11] ; 
                                     expected_data[45] <=  prbs_in[9] ^ prbs_in[12] ; 
                                     expected_data[46] <=  prbs_in[10] ^ prbs_in[13] ; 
                                     expected_data[47] <=  prbs_in[11] ^ prbs_in[14] ; 
                                     expected_data[48] <=  prbs_in[12] ^ prbs_in[15] ; 
                                     expected_data[49] <=  prbs_in[13] ^ prbs_in[16] ; 
                                     expected_data[50] <=  prbs_in[14] ^ prbs_in[17] ; 
                                     expected_data[51] <=  prbs_in[15] ^ prbs_in[18] ; 
                                     expected_data[52] <=  prbs_in[16] ^ prbs_in[19] ; 
                                     expected_data[53] <=  prbs_in[17] ^ prbs_in[20] ; 
                                     expected_data[54] <=  prbs_in[18] ^ prbs_in[21] ; 
                                     expected_data[55] <=  prbs_in[19] ^ prbs_in[22] ; 
                                     expected_data[56] <=  prbs_in[20] ^ prbs_in[23] ; 
                                     expected_data[57] <=  prbs_in[21] ^ prbs_in[24] ; 
                                     expected_data[58] <=  prbs_in[22] ^ prbs_in[25] ; 
                                     expected_data[59] <=  prbs_in[23] ^ prbs_in[26] ; 
                                     expected_data[60] <=  prbs_in[24] ^ prbs_in[27] ; 
                                     expected_data[61] <=  prbs_in[25] ^ prbs_in[28] ; 
                                     expected_data[62] <=  prbs_in[26] ^ prbs_in[29] ; 
                                     expected_data[63] <=  prbs_in[27] ^ prbs_in[30] ; 
                                end
                            end
                            default: begin
                                expected_data <= expected_data;
                            end
                      endcase
                end // end else
            end // end always
		end
		if (ST_DATA_W == 66) begin
		       always @(posedge asi_clk or posedge reset_sync) begin
                if (reset_sync) begin
                    expected_data <= 'b0;
                end else begin
                       // pattern_select does not need to be synchronized to asi_clk
                       // because the value does not change when the component is enabled
					    case (pattern_select)
                        	SEL_HIGH_FREQ: begin
								if ( update_hflf_expt_data ) begin
									if(buffered_data == 66'h1_5555_5555_5555_5555 || buffered_data ==  66'h2_AAAA_AAAA_AAAA_AAAA) begin
										expected_data <= buffered_data;
									end else begin
										expected_data <= 66'h0;
									end
								end
							end
							SEL_LOW_FREQ: begin
								if ( update_hflf_expt_data) begin
									if(buffered_data == 66'h1_C71C_71C7_1C71_C71C 	|| buffered_data == 66'hE38E_38E3_8E38_E38E
									|| buffered_data == 66'h71C7_1C71_C71C_71C7 	|| buffered_data == 66'h2_38E3_8E38_E38E_38E3
									|| buffered_data == 66'h3_1C71_C71C_71C7_1C71	|| buffered_data == 66'h3_8E38_E38E_38E3_8E38) begin
										expected_data <= buffered_data;
									end else begin
										expected_data <= 66'h0;
									end
								end
							end
							SEL_PRBS_7 : begin
                            // prbs_in 2^7-1 (T[7,6]) (parallel 66-bit serializer)
                                if ( update_prbs_expt_data ) begin
                                     expected_data[0] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[1] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[2] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[3] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[4] <=  prbs_in[1] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[5] <=  prbs_in[2] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[6] <=  prbs_in[0] ^ prbs_in[3] ; 
                                     expected_data[7] <=  prbs_in[1] ^ prbs_in[4] ; 
                                     expected_data[8] <=  prbs_in[2] ^ prbs_in[5] ; 
                                     expected_data[9] <=  prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[10] <=  prbs_in[0] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[11] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[12] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ; 
                                     expected_data[13] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[14] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[15] <=  prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[16] <=  prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[17] <=  prbs_in[0] ^ prbs_in[5] ; 
                                     expected_data[18] <=  prbs_in[1] ^ prbs_in[6] ; 
                                     expected_data[19] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[6] ; 
                                     expected_data[20] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[21] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[22] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[23] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[24] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[25] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[26] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[27] <=  prbs_in[1] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[28] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[5] ; 
                                     expected_data[29] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[30] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[31] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[32] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ; 
                                     expected_data[33] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ; 
                                     expected_data[34] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[35] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[36] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[37] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[38] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[39] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[40] <=  prbs_in[2] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[41] <=  prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[42] <=  prbs_in[0] ^ prbs_in[4] ; 
                                     expected_data[43] <=  prbs_in[1] ^ prbs_in[5] ; 
                                     expected_data[44] <=  prbs_in[2] ^ prbs_in[6] ; 
                                     expected_data[45] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[46] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[47] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[48] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[49] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[50] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[51] <=  prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[52] <=  prbs_in[0] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[53] <=  prbs_in[1] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[54] <=  prbs_in[0] ^ prbs_in[2] ; 
                                     expected_data[55] <=  prbs_in[1] ^ prbs_in[3] ; 
                                     expected_data[56] <=  prbs_in[2] ^ prbs_in[4] ; 
                                     expected_data[57] <=  prbs_in[3] ^ prbs_in[5] ; 
                                     expected_data[58] <=  prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[59] <=  prbs_in[0] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[60] <=  prbs_in[0] ^ prbs_in[1] ; 
                                     expected_data[61] <=  prbs_in[1] ^ prbs_in[2] ; 
                                     expected_data[62] <=  prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[63] <=  prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[64] <=  prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[65] <=  prbs_in[5] ^ prbs_in[6] ; 		
                                end
                            end
							SEL_PRBS_15 : begin
                            // prbs_in 2^15 (T[15, 14]) (parallel 66-bit serializer)
                                if ( update_prbs_expt_data) begin 
                                     expected_data[0] <=  prbs_in[4] ^ prbs_in[5] ^ prbs_in[8] ^ prbs_in[9] ; 
                                     expected_data[1] <=  prbs_in[5] ^ prbs_in[6] ^ prbs_in[9] ^ prbs_in[10] ; 
                                     expected_data[2] <=  prbs_in[6] ^ prbs_in[7] ^ prbs_in[10] ^ prbs_in[11] ; 
                                     expected_data[3] <=  prbs_in[7] ^ prbs_in[8] ^ prbs_in[11] ^ prbs_in[12] ; 
                                     expected_data[4] <=  prbs_in[8] ^ prbs_in[9] ^ prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[5] <=  prbs_in[9] ^ prbs_in[10] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[6] <=  prbs_in[0] ^ prbs_in[10] ^ prbs_in[11] ; 
                                     expected_data[7] <=  prbs_in[1] ^ prbs_in[11] ^ prbs_in[12] ; 
                                     expected_data[8] <=  prbs_in[2] ^ prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[9] <=  prbs_in[3] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[10] <=  prbs_in[0] ^ prbs_in[4] ; 
                                     expected_data[11] <=  prbs_in[1] ^ prbs_in[5] ; 
                                     expected_data[12] <=  prbs_in[2] ^ prbs_in[6] ; 
                                     expected_data[13] <=  prbs_in[3] ^ prbs_in[7] ; 
                                     expected_data[14] <=  prbs_in[4] ^ prbs_in[8] ; 
                                     expected_data[15] <=  prbs_in[5] ^ prbs_in[9] ; 
                                     expected_data[16] <=  prbs_in[6] ^ prbs_in[10] ; 
                                     expected_data[17] <=  prbs_in[7] ^ prbs_in[11] ; 
                                     expected_data[18] <=  prbs_in[8] ^ prbs_in[12] ; 
                                     expected_data[19] <=  prbs_in[9] ^ prbs_in[13] ; 
                                     expected_data[20] <=  prbs_in[10] ^ prbs_in[14] ; 
                                     expected_data[21] <=  prbs_in[0] ^ prbs_in[11] ^ prbs_in[14] ; 
                                     expected_data[22] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[12] ^ prbs_in[14] ; 
                                     expected_data[23] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[24] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[25] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[26] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[27] <=  prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[28] <=  prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ^ prbs_in[7] ; 
                                     expected_data[29] <=  prbs_in[5] ^ prbs_in[6] ^ prbs_in[7] ^ prbs_in[8] ; 
                                     expected_data[30] <=  prbs_in[6] ^ prbs_in[7] ^ prbs_in[8] ^ prbs_in[9] ; 
                                     expected_data[31] <=  prbs_in[7] ^ prbs_in[8] ^ prbs_in[9] ^ prbs_in[10] ; 
                                     expected_data[32] <=  prbs_in[8] ^ prbs_in[9] ^ prbs_in[10] ^ prbs_in[11] ; 
                                     expected_data[33] <=  prbs_in[9] ^ prbs_in[10] ^ prbs_in[11] ^ prbs_in[12] ; 
                                     expected_data[34] <=  prbs_in[10] ^ prbs_in[11] ^ prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[35] <=  prbs_in[11] ^ prbs_in[12] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[36] <=  prbs_in[0] ^ prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[37] <=  prbs_in[1] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[38] <=  prbs_in[0] ^ prbs_in[2] ; 
                                     expected_data[39] <=  prbs_in[1] ^ prbs_in[3] ; 
                                     expected_data[40] <=  prbs_in[2] ^ prbs_in[4] ; 
                                     expected_data[41] <=  prbs_in[3] ^ prbs_in[5] ; 
                                     expected_data[42] <=  prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[43] <=  prbs_in[5] ^ prbs_in[7] ; 
                                     expected_data[44] <=  prbs_in[6] ^ prbs_in[8] ; 
                                     expected_data[45] <=  prbs_in[7] ^ prbs_in[9] ; 
                                     expected_data[46] <=  prbs_in[8] ^ prbs_in[10] ; 
                                     expected_data[47] <=  prbs_in[9] ^ prbs_in[11] ; 
                                     expected_data[48] <=  prbs_in[10] ^ prbs_in[12] ; 
                                     expected_data[49] <=  prbs_in[11] ^ prbs_in[13] ; 
                                     expected_data[50] <=  prbs_in[12] ^ prbs_in[14] ; 
                                     expected_data[51] <=  prbs_in[0] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[52] <=  prbs_in[0] ^ prbs_in[1] ; 
                                     expected_data[53] <=  prbs_in[1] ^ prbs_in[2] ; 
                                     expected_data[54] <=  prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[55] <=  prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[56] <=  prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[57] <=  prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[58] <=  prbs_in[6] ^ prbs_in[7] ; 
                                     expected_data[59] <=  prbs_in[7] ^ prbs_in[8] ; 
                                     expected_data[60] <=  prbs_in[8] ^ prbs_in[9] ; 
                                     expected_data[61] <=  prbs_in[9] ^ prbs_in[10] ; 
                                     expected_data[62] <=  prbs_in[10] ^ prbs_in[11] ; 
                                     expected_data[63] <=  prbs_in[11] ^ prbs_in[12] ; 
                                     expected_data[64] <=  prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[65] <=  prbs_in[13] ^ prbs_in[14] ; 
                                end
                            end
							SEL_PRBS_23 : begin
                            // prbs_in 2^23-1 (T[23,18]) (parallel 66-bit serializer)
                                if ( update_prbs_expt_data ) begin 
                                     expected_data[0] <=  prbs_in[3] ^ prbs_in[6] ^ prbs_in[21] ; 
                                     expected_data[1] <=  prbs_in[4] ^ prbs_in[7] ^ prbs_in[22] ; 
                                     expected_data[2] <=  prbs_in[0] ^ prbs_in[5] ^ prbs_in[8] ^ prbs_in[18] ; 
                                     expected_data[3] <=  prbs_in[1] ^ prbs_in[6] ^ prbs_in[9] ^ prbs_in[19] ; 
                                     expected_data[4] <=  prbs_in[2] ^ prbs_in[7] ^ prbs_in[10] ^ prbs_in[20] ; 
                                     expected_data[5] <=  prbs_in[3] ^ prbs_in[8] ^ prbs_in[11] ^ prbs_in[21] ; 
                                     expected_data[6] <=  prbs_in[4] ^ prbs_in[9] ^ prbs_in[12] ^ prbs_in[22] ; 
                                     expected_data[7] <=  prbs_in[0] ^ prbs_in[5] ^ prbs_in[10] ^ prbs_in[13] ^ prbs_in[18] ; 
                                     expected_data[8] <=  prbs_in[1] ^ prbs_in[6] ^ prbs_in[11] ^ prbs_in[14] ^ prbs_in[19] ; 
                                     expected_data[9] <=  prbs_in[2] ^ prbs_in[7] ^ prbs_in[12] ^ prbs_in[15] ^ prbs_in[20] ; 
                                     expected_data[10] <=  prbs_in[3] ^ prbs_in[8] ^ prbs_in[13] ^ prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[11] <=  prbs_in[4] ^ prbs_in[9] ^ prbs_in[14] ^ prbs_in[17] ^ prbs_in[22] ; 
                                     expected_data[12] <=  prbs_in[0] ^ prbs_in[5] ^ prbs_in[10] ^ prbs_in[15] ; 
                                     expected_data[13] <=  prbs_in[1] ^ prbs_in[6] ^ prbs_in[11] ^ prbs_in[16] ; 
                                     expected_data[14] <=  prbs_in[2] ^ prbs_in[7] ^ prbs_in[12] ^ prbs_in[17] ; 
                                     expected_data[15] <=  prbs_in[3] ^ prbs_in[8] ^ prbs_in[13] ^ prbs_in[18] ; 
                                     expected_data[16] <=  prbs_in[4] ^ prbs_in[9] ^ prbs_in[14] ^ prbs_in[19] ; 
                                     expected_data[17] <=  prbs_in[5] ^ prbs_in[10] ^ prbs_in[15] ^ prbs_in[20] ; 
                                     expected_data[18] <=  prbs_in[6] ^ prbs_in[11] ^ prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[19] <=  prbs_in[7] ^ prbs_in[12] ^ prbs_in[17] ^ prbs_in[22] ; 
                                     expected_data[20] <=  prbs_in[0] ^ prbs_in[8] ^ prbs_in[13] ; 
                                     expected_data[21] <=  prbs_in[1] ^ prbs_in[9] ^ prbs_in[14] ; 
                                     expected_data[22] <=  prbs_in[2] ^ prbs_in[10] ^ prbs_in[15] ; 
                                     expected_data[23] <=  prbs_in[3] ^ prbs_in[11] ^ prbs_in[16] ; 
                                     expected_data[24] <=  prbs_in[4] ^ prbs_in[12] ^ prbs_in[17] ; 
                                     expected_data[25] <=  prbs_in[5] ^ prbs_in[13] ^ prbs_in[18] ; 
                                     expected_data[26] <=  prbs_in[6] ^ prbs_in[14] ^ prbs_in[19] ; 
                                     expected_data[27] <=  prbs_in[7] ^ prbs_in[15] ^ prbs_in[20] ; 
                                     expected_data[28] <=  prbs_in[8] ^ prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[29] <=  prbs_in[9] ^ prbs_in[17] ^ prbs_in[22] ; 
                                     expected_data[30] <=  prbs_in[0] ^ prbs_in[10] ; 
                                     expected_data[31] <=  prbs_in[1] ^ prbs_in[11] ; 
                                     expected_data[32] <=  prbs_in[2] ^ prbs_in[12] ; 
                                     expected_data[33] <=  prbs_in[3] ^ prbs_in[13] ; 
                                     expected_data[34] <=  prbs_in[4] ^ prbs_in[14] ; 
                                     expected_data[35] <=  prbs_in[5] ^ prbs_in[15] ; 
                                     expected_data[36] <=  prbs_in[6] ^ prbs_in[16] ; 
                                     expected_data[37] <=  prbs_in[7] ^ prbs_in[17] ; 
                                     expected_data[38] <=  prbs_in[8] ^ prbs_in[18] ; 
                                     expected_data[39] <=  prbs_in[9] ^ prbs_in[19] ; 
                                     expected_data[40] <=  prbs_in[10] ^ prbs_in[20] ; 
                                     expected_data[41] <=  prbs_in[11] ^ prbs_in[21] ; 
                                     expected_data[42] <=  prbs_in[12] ^ prbs_in[22] ; 
                                     expected_data[43] <=  prbs_in[0] ^ prbs_in[13] ^ prbs_in[18] ; 
                                     expected_data[44] <=  prbs_in[1] ^ prbs_in[14] ^ prbs_in[19] ; 
                                     expected_data[45] <=  prbs_in[2] ^ prbs_in[15] ^ prbs_in[20] ; 
                                     expected_data[46] <=  prbs_in[3] ^ prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[47] <=  prbs_in[4] ^ prbs_in[17] ^ prbs_in[22] ; 
                                     expected_data[48] <=  prbs_in[0] ^ prbs_in[5] ; 
                                     expected_data[49] <=  prbs_in[1] ^ prbs_in[6] ; 
                                     expected_data[50] <=  prbs_in[2] ^ prbs_in[7] ; 
                                     expected_data[51] <=  prbs_in[3] ^ prbs_in[8] ; 
                                     expected_data[52] <=  prbs_in[4] ^ prbs_in[9] ; 
                                     expected_data[53] <=  prbs_in[5] ^ prbs_in[10] ; 
                                     expected_data[54] <=  prbs_in[6] ^ prbs_in[11] ; 
                                     expected_data[55] <=  prbs_in[7] ^ prbs_in[12] ; 
                                     expected_data[56] <=  prbs_in[8] ^ prbs_in[13] ; 
                                     expected_data[57] <=  prbs_in[9] ^ prbs_in[14] ; 
                                     expected_data[58] <=  prbs_in[10] ^ prbs_in[15] ; 
                                     expected_data[59] <=  prbs_in[11] ^ prbs_in[16] ; 
                                     expected_data[60] <=  prbs_in[12] ^ prbs_in[17] ; 
                                     expected_data[61] <=  prbs_in[13] ^ prbs_in[18] ; 
                                     expected_data[62] <=  prbs_in[14] ^ prbs_in[19] ; 
                                     expected_data[63] <=  prbs_in[15] ^ prbs_in[20] ; 
                                     expected_data[64] <=  prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[65] <=  prbs_in[17] ^ prbs_in[22] ; 
                                end
                            end
							SEL_PRBS_31 : begin
                            // prbs_in 2^31-1 (T[31,28]) (parallel 66-bit serializer)
                                if ( update_prbs_expt_data) begin
                                     expected_data[0] <=  prbs_in[18] ^ prbs_in[21] ^ prbs_in[24] ^ prbs_in[27] ; 
                                     expected_data[1] <=  prbs_in[19] ^ prbs_in[22] ^ prbs_in[25] ^ prbs_in[28] ; 
                                     expected_data[2] <=  prbs_in[20] ^ prbs_in[23] ^ prbs_in[26] ^ prbs_in[29] ; 
                                     expected_data[3] <=  prbs_in[21] ^ prbs_in[24] ^ prbs_in[27] ^ prbs_in[30] ; 
                                     expected_data[4] <=  prbs_in[0] ^ prbs_in[22] ^ prbs_in[25] ; 
                                     expected_data[5] <=  prbs_in[1] ^ prbs_in[23] ^ prbs_in[26] ; 
                                     expected_data[6] <=  prbs_in[2] ^ prbs_in[24] ^ prbs_in[27] ; 
                                     expected_data[7] <=  prbs_in[3] ^ prbs_in[25] ^ prbs_in[28] ; 
                                     expected_data[8] <=  prbs_in[4] ^ prbs_in[26] ^ prbs_in[29] ; 
                                     expected_data[9] <=  prbs_in[5] ^ prbs_in[27] ^ prbs_in[30] ; 
                                     expected_data[10] <=  prbs_in[0] ^ prbs_in[6] ; 
                                     expected_data[11] <=  prbs_in[1] ^ prbs_in[7] ; 
                                     expected_data[12] <=  prbs_in[2] ^ prbs_in[8] ; 
                                     expected_data[13] <=  prbs_in[3] ^ prbs_in[9] ; 
                                     expected_data[14] <=  prbs_in[4] ^ prbs_in[10] ; 
                                     expected_data[15] <=  prbs_in[5] ^ prbs_in[11] ; 
                                     expected_data[16] <=  prbs_in[6] ^ prbs_in[12] ; 
                                     expected_data[17] <=  prbs_in[7] ^ prbs_in[13] ; 
                                     expected_data[18] <=  prbs_in[8] ^ prbs_in[14] ; 
                                     expected_data[19] <=  prbs_in[9] ^ prbs_in[15] ; 
                                     expected_data[20] <=  prbs_in[10] ^ prbs_in[16] ; 
                                     expected_data[21] <=  prbs_in[11] ^ prbs_in[17] ; 
                                     expected_data[22] <=  prbs_in[12] ^ prbs_in[18] ; 
                                     expected_data[23] <=  prbs_in[13] ^ prbs_in[19] ; 
                                     expected_data[24] <=  prbs_in[14] ^ prbs_in[20] ; 
                                     expected_data[25] <=  prbs_in[15] ^ prbs_in[21] ; 
                                     expected_data[26] <=  prbs_in[16] ^ prbs_in[22] ; 
                                     expected_data[27] <=  prbs_in[17] ^ prbs_in[23] ; 
                                     expected_data[28] <=  prbs_in[18] ^ prbs_in[24] ; 
                                     expected_data[29] <=  prbs_in[19] ^ prbs_in[25] ; 
                                     expected_data[30] <=  prbs_in[20] ^ prbs_in[26] ; 
                                     expected_data[31] <=  prbs_in[21] ^ prbs_in[27] ; 
                                     expected_data[32] <=  prbs_in[22] ^ prbs_in[28] ; 
                                     expected_data[33] <=  prbs_in[23] ^ prbs_in[29] ; 
                                     expected_data[34] <=  prbs_in[24] ^ prbs_in[30] ; 
                                     expected_data[35] <=  prbs_in[0] ^ prbs_in[25] ^ prbs_in[28] ; 
                                     expected_data[36] <=  prbs_in[1] ^ prbs_in[26] ^ prbs_in[29] ; 
                                     expected_data[37] <=  prbs_in[2] ^ prbs_in[27] ^ prbs_in[30] ; 
                                     expected_data[38] <=  prbs_in[0] ^ prbs_in[3] ; 
                                     expected_data[39] <=  prbs_in[1] ^ prbs_in[4] ; 
                                     expected_data[40] <=  prbs_in[2] ^ prbs_in[5] ; 
                                     expected_data[41] <=  prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[42] <=  prbs_in[4] ^ prbs_in[7] ; 
                                     expected_data[43] <=  prbs_in[5] ^ prbs_in[8] ; 
                                     expected_data[44] <=  prbs_in[6] ^ prbs_in[9] ; 
                                     expected_data[45] <=  prbs_in[7] ^ prbs_in[10] ; 
                                     expected_data[46] <=  prbs_in[8] ^ prbs_in[11] ; 
                                     expected_data[47] <=  prbs_in[9] ^ prbs_in[12] ; 
                                     expected_data[48] <=  prbs_in[10] ^ prbs_in[13] ; 
                                     expected_data[49] <=  prbs_in[11] ^ prbs_in[14] ; 
                                     expected_data[50] <=  prbs_in[12] ^ prbs_in[15] ; 
                                     expected_data[51] <=  prbs_in[13] ^ prbs_in[16] ; 
                                     expected_data[52] <=  prbs_in[14] ^ prbs_in[17] ; 
                                     expected_data[53] <=  prbs_in[15] ^ prbs_in[18] ; 
                                     expected_data[54] <=  prbs_in[16] ^ prbs_in[19] ; 
                                     expected_data[55] <=  prbs_in[17] ^ prbs_in[20] ; 
                                     expected_data[56] <=  prbs_in[18] ^ prbs_in[21] ; 
                                     expected_data[57] <=  prbs_in[19] ^ prbs_in[22] ; 
                                     expected_data[58] <=  prbs_in[20] ^ prbs_in[23] ; 
                                     expected_data[59] <=  prbs_in[21] ^ prbs_in[24] ; 
                                     expected_data[60] <=  prbs_in[22] ^ prbs_in[25] ; 
                                     expected_data[61] <=  prbs_in[23] ^ prbs_in[26] ; 
                                     expected_data[62] <=  prbs_in[24] ^ prbs_in[27] ; 
                                     expected_data[63] <=  prbs_in[25] ^ prbs_in[28] ; 
                                     expected_data[64] <=  prbs_in[26] ^ prbs_in[29] ; 
                                     expected_data[65] <=  prbs_in[27] ^ prbs_in[30] ;
                                end
                            end
							default: begin
								expected_data <= expected_data;
							end
						endcase
                end // end else
            end // end always
        end
		if (ST_DATA_W == 80) begin
            always @(posedge asi_clk or posedge reset_sync) begin
                if (reset_sync) begin
                    expected_data <= 'b0;
                end else begin
                       // pattern_select does not need to be synchronized to asi_clk
                       // because the value does not change when the component is enabled
                   case (pattern_select)
                        SEL_HIGH_FREQ: begin
							if ( update_hflf_expt_data) begin
								if(buffered_data == 80'h5555_5555_5555_5555_5555|| buffered_data == 80'hAAAA_AAAA_AAAA_AAAA_AAAA) begin
									expected_data <= buffered_data;
								end else begin
									expected_data <= 80'h0;
								end
							end
       					end
                        SEL_LOW_FREQ: begin
							if ( update_hflf_expt_data) begin
								if(buffered_data == 80'hE1E1_E1E1_E1E1_E1E1_E1E1 || buffered_data == 80'hC3C3_C3C3_C3C3_C3C3_C3C3
								|| buffered_data == 80'h8787_8787_8787_8787_8787 || buffered_data == 80'h0F0F_0F0F_0F0F_0F0F_0F0F
								|| buffered_data == 80'h1E1E_1E1E_1E1E_1E1E_1E1E || buffered_data == 80'h3C3C_3C3C_3C3C_3C3C_3C3C
								|| buffered_data == 80'h7878_7878_7878_7878_7878 || buffered_data == 80'hF0F0_F0F0_F0F0_F0F0_F0F0) begin
									expected_data <= buffered_data;
								end else begin
									expected_data <= 80'h0;
								end
							end
				        end
                        SEL_PRBS_7 : begin
                            // PRBS 2^7-1 (T[7,6]) (parallel 80-bit serializer)
                            if ( update_prbs_expt_data ) begin
                                 expected_data[0] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[6] ; 
                                 expected_data[1] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[6] ; 
                                 expected_data[2] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[3] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ; 
                                 expected_data[4] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[6] ; 
                                 expected_data[5] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[6] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                 expected_data[7] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[8] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ; 
                                 expected_data[9] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[6] ; 
                                 expected_data[10] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[11] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[5] ; 
                                 expected_data[12] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[6] ; 
                                 expected_data[13] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[14] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[4] ; 
                                 expected_data[15] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[5] ; 
                                 expected_data[16] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[17] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[4] ; 
                                 expected_data[18] <=  prbs_in[1] ^ prbs_in[4] ^ prbs_in[5] ; 
                                 expected_data[19] <=  prbs_in[2] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[20] <=  prbs_in[0] ^ prbs_in[3] ; 
                                 expected_data[21] <=  prbs_in[1] ^ prbs_in[4] ; 
                                 expected_data[22] <=  prbs_in[2] ^ prbs_in[5] ; 
                                 expected_data[23] <=  prbs_in[3] ^ prbs_in[6] ; 
                                 expected_data[24] <=  prbs_in[0] ^ prbs_in[4] ^ prbs_in[6] ; 
                                 expected_data[25] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[26] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ; 
                                 expected_data[27] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ; 
                                 expected_data[28] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ; 
                                 expected_data[29] <=  prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                 expected_data[30] <=  prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[31] <=  prbs_in[0] ^ prbs_in[5] ; 
                                 expected_data[32] <=  prbs_in[1] ^ prbs_in[6] ; 
                                 expected_data[33] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[6] ; 
                                 expected_data[34] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[6] ; 
                                 expected_data[35] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[6] ; 
                                 expected_data[36] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[37] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ; 
                                 expected_data[38] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                 expected_data[39] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[40] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                 expected_data[41] <=  prbs_in[1] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[42] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[5] ; 
                                 expected_data[43] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[6] ; 
                                 expected_data[44] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[6] ; 
                                 expected_data[45] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[46] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ; 
                                 expected_data[47] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ; 
                                 expected_data[48] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[6] ; 
                                 expected_data[49] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[50] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[4] ^ prbs_in[5] ; 
                                 expected_data[51] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[52] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[3] ; 
                                 expected_data[53] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[4] ; 
                                 expected_data[54] <=  prbs_in[2] ^ prbs_in[4] ^ prbs_in[5] ; 
                                 expected_data[55] <=  prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[56] <=  prbs_in[0] ^ prbs_in[4] ; 
                                 expected_data[57] <=  prbs_in[1] ^ prbs_in[5] ; 
                                 expected_data[58] <=  prbs_in[2] ^ prbs_in[6] ; 
                                 expected_data[59] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[6] ; 
                                 expected_data[60] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[4] ^ prbs_in[6] ; 
                                 expected_data[61] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[62] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ; 
                                 expected_data[63] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ; 
                                 expected_data[64] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                 expected_data[65] <=  prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[66] <=  prbs_in[0] ^ prbs_in[4] ^ prbs_in[5] ; 
                                 expected_data[67] <=  prbs_in[1] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[68] <=  prbs_in[0] ^ prbs_in[2] ; 
                                 expected_data[69] <=  prbs_in[1] ^ prbs_in[3] ; 
                                 expected_data[70] <=  prbs_in[2] ^ prbs_in[4] ; 
                                 expected_data[71] <=  prbs_in[3] ^ prbs_in[5] ; 
                                 expected_data[72] <=  prbs_in[4] ^ prbs_in[6] ; 
                                 expected_data[73] <=  prbs_in[0] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[74] <=  prbs_in[0] ^ prbs_in[1] ; 
                                 expected_data[75] <=  prbs_in[1] ^ prbs_in[2] ; 
                                 expected_data[76] <=  prbs_in[2] ^ prbs_in[3] ; 
                                 expected_data[77] <=  prbs_in[3] ^ prbs_in[4] ; 
                                 expected_data[78] <=  prbs_in[4] ^ prbs_in[5] ; 
                                 expected_data[79] <=  prbs_in[5] ^ prbs_in[6] ; 
                             end
                        end
                        SEL_PRBS_15 : begin
                            // PRBS 2^15 (T[15, 14]) (parallel 80-bit serializer)
                            if ( update_prbs_expt_data ) begin 
                                 expected_data[0] <=  prbs_in[4] ^ prbs_in[6] ^ prbs_in[8] ^ prbs_in[10] ; 
                                 expected_data[1] <=  prbs_in[5] ^ prbs_in[7] ^ prbs_in[9] ^ prbs_in[11] ; 
                                 expected_data[2] <=  prbs_in[6] ^ prbs_in[8] ^ prbs_in[10] ^ prbs_in[12] ; 
                                 expected_data[3] <=  prbs_in[7] ^ prbs_in[9] ^ prbs_in[11] ^ prbs_in[13] ; 
                                 expected_data[4] <=  prbs_in[8] ^ prbs_in[10] ^ prbs_in[12] ^ prbs_in[14] ; 
                                 expected_data[5] <=  prbs_in[0] ^ prbs_in[9] ^ prbs_in[11] ^ prbs_in[13] ^ prbs_in[14] ; 
                                 expected_data[6] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[10] ^ prbs_in[12] ; 
                                 expected_data[7] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[11] ^ prbs_in[13] ; 
                                 expected_data[8] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[12] ^ prbs_in[14] ; 
                                 expected_data[9] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[13] ^ prbs_in[14] ; 
                                 expected_data[10] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[4] ^ prbs_in[5] ; 
                                 expected_data[11] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[12] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[6] ^ prbs_in[7] ; 
                                 expected_data[13] <=  prbs_in[3] ^ prbs_in[4] ^ prbs_in[7] ^ prbs_in[8] ; 
                                 expected_data[14] <=  prbs_in[4] ^ prbs_in[5] ^ prbs_in[8] ^ prbs_in[9] ; 
                                 expected_data[15] <=  prbs_in[5] ^ prbs_in[6] ^ prbs_in[9] ^ prbs_in[10] ; 
                                 expected_data[16] <=  prbs_in[6] ^ prbs_in[7] ^ prbs_in[10] ^ prbs_in[11] ; 
                                 expected_data[17] <=  prbs_in[7] ^ prbs_in[8] ^ prbs_in[11] ^ prbs_in[12] ; 
                                 expected_data[18] <=  prbs_in[8] ^ prbs_in[9] ^ prbs_in[12] ^ prbs_in[13] ; 
                                 expected_data[19] <=  prbs_in[9] ^ prbs_in[10] ^ prbs_in[13] ^ prbs_in[14] ; 
                                 expected_data[20] <=  prbs_in[0] ^ prbs_in[10] ^ prbs_in[11] ; 
                                 expected_data[21] <=  prbs_in[1] ^ prbs_in[11] ^ prbs_in[12] ; 
                                 expected_data[22] <=  prbs_in[2] ^ prbs_in[12] ^ prbs_in[13] ; 
                                 expected_data[23] <=  prbs_in[3] ^ prbs_in[13] ^ prbs_in[14] ; 
                                 expected_data[24] <=  prbs_in[0] ^ prbs_in[4] ; 
                                 expected_data[25] <=  prbs_in[1] ^ prbs_in[5] ; 
                                 expected_data[26] <=  prbs_in[2] ^ prbs_in[6] ; 
                                 expected_data[27] <=  prbs_in[3] ^ prbs_in[7] ; 
                                 expected_data[28] <=  prbs_in[4] ^ prbs_in[8] ; 
                                 expected_data[29] <=  prbs_in[5] ^ prbs_in[9] ; 
                                 expected_data[30] <=  prbs_in[6] ^ prbs_in[10] ; 
                                 expected_data[31] <=  prbs_in[7] ^ prbs_in[11] ; 
                                 expected_data[32] <=  prbs_in[8] ^ prbs_in[12] ; 
                                 expected_data[33] <=  prbs_in[9] ^ prbs_in[13] ; 
                                 expected_data[34] <=  prbs_in[10] ^ prbs_in[14] ; 
                                 expected_data[35] <=  prbs_in[0] ^ prbs_in[11] ^ prbs_in[14] ; 
                                 expected_data[36] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[12] ^ prbs_in[14] ; 
                                 expected_data[37] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[13] ^ prbs_in[14] ; 
                                 expected_data[38] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ; 
                                 expected_data[39] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ; 
                                 expected_data[40] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                 expected_data[41] <=  prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[42] <=  prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ^ prbs_in[7] ; 
                                 expected_data[43] <=  prbs_in[5] ^ prbs_in[6] ^ prbs_in[7] ^ prbs_in[8] ; 
                                 expected_data[44] <=  prbs_in[6] ^ prbs_in[7] ^ prbs_in[8] ^ prbs_in[9] ; 
                                 expected_data[45] <=  prbs_in[7] ^ prbs_in[8] ^ prbs_in[9] ^ prbs_in[10] ; 
                                 expected_data[46] <=  prbs_in[8] ^ prbs_in[9] ^ prbs_in[10] ^ prbs_in[11] ; 
                                 expected_data[47] <=  prbs_in[9] ^ prbs_in[10] ^ prbs_in[11] ^ prbs_in[12] ; 
                                 expected_data[48] <=  prbs_in[10] ^ prbs_in[11] ^ prbs_in[12] ^ prbs_in[13] ; 
                                 expected_data[49] <=  prbs_in[11] ^ prbs_in[12] ^ prbs_in[13] ^ prbs_in[14] ; 
                                 expected_data[50] <=  prbs_in[0] ^ prbs_in[12] ^ prbs_in[13] ; 
                                 expected_data[51] <=  prbs_in[1] ^ prbs_in[13] ^ prbs_in[14] ; 
                                 expected_data[52] <=  prbs_in[0] ^ prbs_in[2] ; 
                                 expected_data[53] <=  prbs_in[1] ^ prbs_in[3] ; 
                                 expected_data[54] <=  prbs_in[2] ^ prbs_in[4] ; 
                                 expected_data[55] <=  prbs_in[3] ^ prbs_in[5] ; 
                                 expected_data[56] <=  prbs_in[4] ^ prbs_in[6] ; 
                                 expected_data[57] <=  prbs_in[5] ^ prbs_in[7] ; 
                                 expected_data[58] <=  prbs_in[6] ^ prbs_in[8] ; 
                                 expected_data[59] <=  prbs_in[7] ^ prbs_in[9] ; 
                                 expected_data[60] <=  prbs_in[8] ^ prbs_in[10] ; 
                                 expected_data[61] <=  prbs_in[9] ^ prbs_in[11] ; 
                                 expected_data[62] <=  prbs_in[10] ^ prbs_in[12] ; 
                                 expected_data[63] <=  prbs_in[11] ^ prbs_in[13] ; 
                                 expected_data[64] <=  prbs_in[12] ^ prbs_in[14] ; 
                                 expected_data[65] <=  prbs_in[0] ^ prbs_in[13] ^ prbs_in[14] ; 
                                 expected_data[66] <=  prbs_in[0] ^ prbs_in[1] ; 
                                 expected_data[67] <=  prbs_in[1] ^ prbs_in[2] ; 
                                 expected_data[68] <=  prbs_in[2] ^ prbs_in[3] ; 
                                 expected_data[69] <=  prbs_in[3] ^ prbs_in[4] ; 
                                 expected_data[70] <=  prbs_in[4] ^ prbs_in[5] ; 
                                 expected_data[71] <=  prbs_in[5] ^ prbs_in[6] ; 
                                 expected_data[72] <=  prbs_in[6] ^ prbs_in[7] ; 
                                 expected_data[73] <=  prbs_in[7] ^ prbs_in[8] ; 
                                 expected_data[74] <=  prbs_in[8] ^ prbs_in[9] ; 
                                 expected_data[75] <=  prbs_in[9] ^ prbs_in[10] ; 
                                 expected_data[76] <=  prbs_in[10] ^ prbs_in[11] ; 
                                 expected_data[77] <=  prbs_in[11] ^ prbs_in[12] ; 
                                 expected_data[78] <=  prbs_in[12] ^ prbs_in[13] ; 
                                 expected_data[79] <=  prbs_in[13] ^ prbs_in[14] ; 
                             end
                        end
                        SEL_PRBS_23 : begin
                            // PRBS 2^23-1 (T[23,18]) (parallel 80-bit serializer)
                            if ( update_prbs_expt_data ) begin
                                 expected_data[0] <=  prbs_in[10] ^ prbs_in[12] ^ prbs_in[15] ; 
                                 expected_data[1] <=  prbs_in[11] ^ prbs_in[13] ^ prbs_in[16] ; 
                                 expected_data[2] <=  prbs_in[12] ^ prbs_in[14] ^ prbs_in[17] ; 
                                 expected_data[3] <=  prbs_in[13] ^ prbs_in[15] ^ prbs_in[18] ; 
                                 expected_data[4] <=  prbs_in[14] ^ prbs_in[16] ^ prbs_in[19] ; 
                                 expected_data[5] <=  prbs_in[15] ^ prbs_in[17] ^ prbs_in[20] ; 
                                 expected_data[6] <=  prbs_in[16] ^ prbs_in[18] ^ prbs_in[21] ; 
                                 expected_data[7] <=  prbs_in[17] ^ prbs_in[19] ^ prbs_in[22] ; 
                                 expected_data[8] <=  prbs_in[0] ^ prbs_in[20] ; 
                                 expected_data[9] <=  prbs_in[1] ^ prbs_in[21] ; 
                                 expected_data[10] <=  prbs_in[2] ^ prbs_in[22] ; 
                                 expected_data[11] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[18] ; 
                                 expected_data[12] <=  prbs_in[1] ^ prbs_in[4] ^ prbs_in[19] ; 
                                 expected_data[13] <=  prbs_in[2] ^ prbs_in[5] ^ prbs_in[20] ; 
                                 expected_data[14] <=  prbs_in[3] ^ prbs_in[6] ^ prbs_in[21] ; 
                                 expected_data[15] <=  prbs_in[4] ^ prbs_in[7] ^ prbs_in[22] ; 
                                 expected_data[16] <=  prbs_in[0] ^ prbs_in[5] ^ prbs_in[8] ^ prbs_in[18] ; 
                                 expected_data[17] <=  prbs_in[1] ^ prbs_in[6] ^ prbs_in[9] ^ prbs_in[19] ; 
                                 expected_data[18] <=  prbs_in[2] ^ prbs_in[7] ^ prbs_in[10] ^ prbs_in[20] ; 
                                 expected_data[19] <=  prbs_in[3] ^ prbs_in[8] ^ prbs_in[11] ^ prbs_in[21] ; 
                                 expected_data[20] <=  prbs_in[4] ^ prbs_in[9] ^ prbs_in[12] ^ prbs_in[22] ; 
                                 expected_data[21] <=  prbs_in[0] ^ prbs_in[5] ^ prbs_in[10] ^ prbs_in[13] ^ prbs_in[18] ; 
                                 expected_data[22] <=  prbs_in[1] ^ prbs_in[6] ^ prbs_in[11] ^ prbs_in[14] ^ prbs_in[19] ; 
                                 expected_data[23] <=  prbs_in[2] ^ prbs_in[7] ^ prbs_in[12] ^ prbs_in[15] ^ prbs_in[20] ; 
                                 expected_data[24] <=  prbs_in[3] ^ prbs_in[8] ^ prbs_in[13] ^ prbs_in[16] ^ prbs_in[21] ; 
                                 expected_data[25] <=  prbs_in[4] ^ prbs_in[9] ^ prbs_in[14] ^ prbs_in[17] ^ prbs_in[22] ; 
                                 expected_data[26] <=  prbs_in[0] ^ prbs_in[5] ^ prbs_in[10] ^ prbs_in[15] ; 
                                 expected_data[27] <=  prbs_in[1] ^ prbs_in[6] ^ prbs_in[11] ^ prbs_in[16] ; 
                                 expected_data[28] <=  prbs_in[2] ^ prbs_in[7] ^ prbs_in[12] ^ prbs_in[17] ; 
                                 expected_data[29] <=  prbs_in[3] ^ prbs_in[8] ^ prbs_in[13] ^ prbs_in[18] ; 
                                 expected_data[30] <=  prbs_in[4] ^ prbs_in[9] ^ prbs_in[14] ^ prbs_in[19] ; 
                                 expected_data[31] <=  prbs_in[5] ^ prbs_in[10] ^ prbs_in[15] ^ prbs_in[20] ; 
                                 expected_data[32] <=  prbs_in[6] ^ prbs_in[11] ^ prbs_in[16] ^ prbs_in[21] ; 
                                 expected_data[33] <=  prbs_in[7] ^ prbs_in[12] ^ prbs_in[17] ^ prbs_in[22] ; 
                                 expected_data[34] <=  prbs_in[0] ^ prbs_in[8] ^ prbs_in[13] ; 
                                 expected_data[35] <=  prbs_in[1] ^ prbs_in[9] ^ prbs_in[14] ; 
                                 expected_data[36] <=  prbs_in[2] ^ prbs_in[10] ^ prbs_in[15] ; 
                                 expected_data[37] <=  prbs_in[3] ^ prbs_in[11] ^ prbs_in[16] ; 
                                 expected_data[38] <=  prbs_in[4] ^ prbs_in[12] ^ prbs_in[17] ; 
                                 expected_data[39] <=  prbs_in[5] ^ prbs_in[13] ^ prbs_in[18] ; 
                                 expected_data[40] <=  prbs_in[6] ^ prbs_in[14] ^ prbs_in[19] ; 
                                 expected_data[41] <=  prbs_in[7] ^ prbs_in[15] ^ prbs_in[20] ; 
                                 expected_data[42] <=  prbs_in[8] ^ prbs_in[16] ^ prbs_in[21] ; 
                                 expected_data[43] <=  prbs_in[9] ^ prbs_in[17] ^ prbs_in[22] ; 
                                 expected_data[44] <=  prbs_in[0] ^ prbs_in[10] ; 
                                 expected_data[45] <=  prbs_in[1] ^ prbs_in[11] ; 
                                 expected_data[46] <=  prbs_in[2] ^ prbs_in[12] ; 
                                 expected_data[47] <=  prbs_in[3] ^ prbs_in[13] ; 
                                 expected_data[48] <=  prbs_in[4] ^ prbs_in[14] ; 
                                 expected_data[49] <=  prbs_in[5] ^ prbs_in[15] ; 
                                 expected_data[50] <=  prbs_in[6] ^ prbs_in[16] ; 
                                 expected_data[51] <=  prbs_in[7] ^ prbs_in[17] ; 
                                 expected_data[52] <=  prbs_in[8] ^ prbs_in[18] ; 
                                 expected_data[53] <=  prbs_in[9] ^ prbs_in[19] ; 
                                 expected_data[54] <=  prbs_in[10] ^ prbs_in[20] ; 
                                 expected_data[55] <=  prbs_in[11] ^ prbs_in[21] ; 
                                 expected_data[56] <=  prbs_in[12] ^ prbs_in[22] ; 
                                 expected_data[57] <=  prbs_in[0] ^ prbs_in[13] ^ prbs_in[18] ; 
                                 expected_data[58] <=  prbs_in[1] ^ prbs_in[14] ^ prbs_in[19] ; 
                                 expected_data[59] <=  prbs_in[2] ^ prbs_in[15] ^ prbs_in[20] ; 
                                 expected_data[60] <=  prbs_in[3] ^ prbs_in[16] ^ prbs_in[21] ; 
                                 expected_data[61] <=  prbs_in[4] ^ prbs_in[17] ^ prbs_in[22] ; 
                                 expected_data[62] <=  prbs_in[0] ^ prbs_in[5] ; 
                                 expected_data[63] <=  prbs_in[1] ^ prbs_in[6] ; 
                                 expected_data[64] <=  prbs_in[2] ^ prbs_in[7] ; 
                                 expected_data[65] <=  prbs_in[3] ^ prbs_in[8] ; 
                                 expected_data[66] <=  prbs_in[4] ^ prbs_in[9] ; 
                                 expected_data[67] <=  prbs_in[5] ^ prbs_in[10] ; 
                                 expected_data[68] <=  prbs_in[6] ^ prbs_in[11] ; 
                                 expected_data[69] <=  prbs_in[7] ^ prbs_in[12] ; 
                                 expected_data[70] <=  prbs_in[8] ^ prbs_in[13] ; 
                                 expected_data[71] <=  prbs_in[9] ^ prbs_in[14] ; 
                                 expected_data[72] <=  prbs_in[10] ^ prbs_in[15] ; 
                                 expected_data[73] <=  prbs_in[11] ^ prbs_in[16] ; 
                                 expected_data[74] <=  prbs_in[12] ^ prbs_in[17] ; 
                                 expected_data[75] <=  prbs_in[13] ^ prbs_in[18] ; 
                                 expected_data[76] <=  prbs_in[14] ^ prbs_in[19] ; 
                                 expected_data[77] <=  prbs_in[15] ^ prbs_in[20] ; 
                                 expected_data[78] <=  prbs_in[16] ^ prbs_in[21] ; 
                                 expected_data[79] <=  prbs_in[17] ^ prbs_in[22] ; 
                             end
                        end
                        SEL_PRBS_31 : begin
                            // PRBS 2^31-1 (T[31,28]) (parallel 80-bit serializer)
                            if ( update_prbs_expt_data ) begin 
                                 expected_data[0] <=  prbs_in[4] ^ prbs_in[7] ^ prbs_in[10] ^ prbs_in[13] ; 
                                 expected_data[1] <=  prbs_in[5] ^ prbs_in[8] ^ prbs_in[11] ^ prbs_in[14] ; 
                                 expected_data[2] <=  prbs_in[6] ^ prbs_in[9] ^ prbs_in[12] ^ prbs_in[15] ; 
                                 expected_data[3] <=  prbs_in[7] ^ prbs_in[10] ^ prbs_in[13] ^ prbs_in[16] ; 
                                 expected_data[4] <=  prbs_in[8] ^ prbs_in[11] ^ prbs_in[14] ^ prbs_in[17] ; 
                                 expected_data[5] <=  prbs_in[9] ^ prbs_in[12] ^ prbs_in[15] ^ prbs_in[18] ; 
                                 expected_data[6] <=  prbs_in[10] ^ prbs_in[13] ^ prbs_in[16] ^ prbs_in[19] ; 
                                 expected_data[7] <=  prbs_in[11] ^ prbs_in[14] ^ prbs_in[17] ^ prbs_in[20] ; 
                                 expected_data[8] <=  prbs_in[12] ^ prbs_in[15] ^ prbs_in[18] ^ prbs_in[21] ; 
                                 expected_data[9] <=  prbs_in[13] ^ prbs_in[16] ^ prbs_in[19] ^ prbs_in[22] ; 
                                 expected_data[10] <=  prbs_in[14] ^ prbs_in[17] ^ prbs_in[20] ^ prbs_in[23] ; 
                                 expected_data[11] <=  prbs_in[15] ^ prbs_in[18] ^ prbs_in[21] ^ prbs_in[24] ; 
                                 expected_data[12] <=  prbs_in[16] ^ prbs_in[19] ^ prbs_in[22] ^ prbs_in[25] ; 
                                 expected_data[13] <=  prbs_in[17] ^ prbs_in[20] ^ prbs_in[23] ^ prbs_in[26] ; 
                                 expected_data[14] <=  prbs_in[18] ^ prbs_in[21] ^ prbs_in[24] ^ prbs_in[27] ; 
                                 expected_data[15] <=  prbs_in[19] ^ prbs_in[22] ^ prbs_in[25] ^ prbs_in[28] ; 
                                 expected_data[16] <=  prbs_in[20] ^ prbs_in[23] ^ prbs_in[26] ^ prbs_in[29] ; 
                                 expected_data[17] <=  prbs_in[21] ^ prbs_in[24] ^ prbs_in[27] ^ prbs_in[30] ; 
                                 expected_data[18] <=  prbs_in[0] ^ prbs_in[22] ^ prbs_in[25] ; 
                                 expected_data[19] <=  prbs_in[1] ^ prbs_in[23] ^ prbs_in[26] ; 
                                 expected_data[20] <=  prbs_in[2] ^ prbs_in[24] ^ prbs_in[27] ; 
                                 expected_data[21] <=  prbs_in[3] ^ prbs_in[25] ^ prbs_in[28] ; 
                                 expected_data[22] <=  prbs_in[4] ^ prbs_in[26] ^ prbs_in[29] ; 
                                 expected_data[23] <=  prbs_in[5] ^ prbs_in[27] ^ prbs_in[30] ; 
                                 expected_data[24] <=  prbs_in[0] ^ prbs_in[6] ; 
                                 expected_data[25] <=  prbs_in[1] ^ prbs_in[7] ; 
                                 expected_data[26] <=  prbs_in[2] ^ prbs_in[8] ; 
                                 expected_data[27] <=  prbs_in[3] ^ prbs_in[9] ; 
                                 expected_data[28] <=  prbs_in[4] ^ prbs_in[10] ; 
                                 expected_data[29] <=  prbs_in[5] ^ prbs_in[11] ; 
                                 expected_data[30] <=  prbs_in[6] ^ prbs_in[12] ; 
                                 expected_data[31] <=  prbs_in[7] ^ prbs_in[13] ; 
                                 expected_data[32] <=  prbs_in[8] ^ prbs_in[14] ; 
                                 expected_data[33] <=  prbs_in[9] ^ prbs_in[15] ; 
                                 expected_data[34] <=  prbs_in[10] ^ prbs_in[16] ; 
                                 expected_data[35] <=  prbs_in[11] ^ prbs_in[17] ; 
                                 expected_data[36] <=  prbs_in[12] ^ prbs_in[18] ; 
                                 expected_data[37] <=  prbs_in[13] ^ prbs_in[19] ; 
                                 expected_data[38] <=  prbs_in[14] ^ prbs_in[20] ; 
                                 expected_data[39] <=  prbs_in[15] ^ prbs_in[21] ; 
                                 expected_data[40] <=  prbs_in[16] ^ prbs_in[22] ; 
                                 expected_data[41] <=  prbs_in[17] ^ prbs_in[23] ; 
                                 expected_data[42] <=  prbs_in[18] ^ prbs_in[24] ; 
                                 expected_data[43] <=  prbs_in[19] ^ prbs_in[25] ; 
                                 expected_data[44] <=  prbs_in[20] ^ prbs_in[26] ; 
                                 expected_data[45] <=  prbs_in[21] ^ prbs_in[27] ; 
                                 expected_data[46] <=  prbs_in[22] ^ prbs_in[28] ; 
                                 expected_data[47] <=  prbs_in[23] ^ prbs_in[29] ; 
                                 expected_data[48] <=  prbs_in[24] ^ prbs_in[30] ; 
                                 expected_data[49] <=  prbs_in[0] ^ prbs_in[25] ^ prbs_in[28] ; 
                                 expected_data[50] <=  prbs_in[1] ^ prbs_in[26] ^ prbs_in[29] ; 
                                 expected_data[51] <=  prbs_in[2] ^ prbs_in[27] ^ prbs_in[30] ; 
                                 expected_data[52] <=  prbs_in[0] ^ prbs_in[3] ; 
                                 expected_data[53] <=  prbs_in[1] ^ prbs_in[4] ; 
                                 expected_data[54] <=  prbs_in[2] ^ prbs_in[5] ; 
                                 expected_data[55] <=  prbs_in[3] ^ prbs_in[6] ; 
                                 expected_data[56] <=  prbs_in[4] ^ prbs_in[7] ; 
                                 expected_data[57] <=  prbs_in[5] ^ prbs_in[8] ; 
                                 expected_data[58] <=  prbs_in[6] ^ prbs_in[9] ; 
                                 expected_data[59] <=  prbs_in[7] ^ prbs_in[10] ; 
                                 expected_data[60] <=  prbs_in[8] ^ prbs_in[11] ; 
                                 expected_data[61] <=  prbs_in[9] ^ prbs_in[12] ; 
                                 expected_data[62] <=  prbs_in[10] ^ prbs_in[13] ; 
                                 expected_data[63] <=  prbs_in[11] ^ prbs_in[14] ; 
                                 expected_data[64] <=  prbs_in[12] ^ prbs_in[15] ; 
                                 expected_data[65] <=  prbs_in[13] ^ prbs_in[16] ; 
                                 expected_data[66] <=  prbs_in[14] ^ prbs_in[17] ; 
                                 expected_data[67] <=  prbs_in[15] ^ prbs_in[18] ; 
                                 expected_data[68] <=  prbs_in[16] ^ prbs_in[19] ; 
                                 expected_data[69] <=  prbs_in[17] ^ prbs_in[20] ; 
                                 expected_data[70] <=  prbs_in[18] ^ prbs_in[21] ; 
                                 expected_data[71] <=  prbs_in[19] ^ prbs_in[22] ; 
                                 expected_data[72] <=  prbs_in[20] ^ prbs_in[23] ; 
                                 expected_data[73] <=  prbs_in[21] ^ prbs_in[24] ; 
                                 expected_data[74] <=  prbs_in[22] ^ prbs_in[25] ; 
                                 expected_data[75] <=  prbs_in[23] ^ prbs_in[26] ; 
                                 expected_data[76] <=  prbs_in[24] ^ prbs_in[27] ; 
                                 expected_data[77] <=  prbs_in[25] ^ prbs_in[28] ; 
                                 expected_data[78] <=  prbs_in[26] ^ prbs_in[29] ; 
                                 expected_data[79] <=  prbs_in[27] ^ prbs_in[30] ; 
                             end
                        end
                        default: begin
                            expected_data <= expected_data;
                        end
                      endcase
                end // end else
            end // end always
		  end 
		if (ST_DATA_W == 128) begin
            always @(posedge asi_clk or posedge reset_sync) begin
                if (reset_sync) begin
                    expected_data <= 'b0;
                end else begin
                       // pattern_select does not need to be synchronized to asi_clk
                       // because the value does not change when the component is enabled
						case (pattern_select)
							SEL_HIGH_FREQ: begin
								if ( update_hflf_expt_data) begin
									if(buffered_data == 128'h5555_5555_5555_5555_5555_5555_5555_5555 || buffered_data == 128'hAAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA) begin
										expected_data <= buffered_data;
									end else begin
										expected_data <= 128'h0;
									end
								end
                        	end
							SEL_LOW_FREQ: begin
								if ( update_hflf_expt_data) begin
									if(buffered_data == 128'hE1E1_E1E1_E1E1_E1E1_E1E1_E1E1_E1E1_E1E1 || buffered_data == 128'hC3C3_C3C3_C3C3_C3C3_C3C3_C3C3_C3C3_C3C3
									|| buffered_data == 128'h8787_8787_8787_8787_8787_8787_8787_8787 || buffered_data == 128'h0F0F_0F0F_0F0F_0F0F_0F0F_0F0F_0F0F_0F0F
									|| buffered_data == 128'h1E1E_1E1E_1E1E_1E1E_1E1E_1E1E_1E1E_1E1E || buffered_data == 128'h3C3C_3C3C_3C3C_3C3C_3C3C_3C3C_3C3C_3C3C
									|| buffered_data == 128'h7878_7878_7878_7878_7878_7878_7878_7878 || buffered_data == 128'hF0F0_F0F0_F0F0_F0F0_F0F0_F0F0_F0F0_F0F0) begin
										expected_data <= buffered_data;
									end else begin
										expected_data <= 128'h0;
									end
								end
							end
							SEL_PRBS_7 : begin
                            // prbs_in 2^7-1 (T[7,6]) (parallel 128-bit serializer)
                                if ( update_prbs_expt_data) begin
                                     expected_data[0] <=  prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[1] <=  prbs_in[0] ; 
                                     expected_data[2] <=  prbs_in[1] ; 
                                     expected_data[3] <=  prbs_in[2] ; 
                                     expected_data[4] <=  prbs_in[3] ; 
                                     expected_data[5] <=  prbs_in[4] ; 
                                     expected_data[6] <=  prbs_in[5] ; 
                                     expected_data[7] <=  prbs_in[6] ; 
                                     expected_data[8] <=  prbs_in[0] ^ prbs_in[6] ; 
                                     expected_data[9] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[6] ; 
                                     expected_data[10] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[6] ; 
                                     expected_data[11] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[12] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[13] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6]; 
                                     expected_data[14] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[15] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[16] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[17] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[18] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[19] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[20] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[4] ; 
                                     expected_data[21] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[5] ; 
                                     expected_data[22] <=  prbs_in[2] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[23] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[24] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[4] ; 
                                     expected_data[25] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[5] ; 
                                     expected_data[26] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[27] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[28] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[29] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[5] ; 
                                     expected_data[30] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[31] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[32] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[33] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[34] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[35] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[36] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[37] <=  prbs_in[2] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[38] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[5] ; 
                                     expected_data[39] <=  prbs_in[1] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[40] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[41] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ; 
                                     expected_data[42] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ; 
                                     expected_data[43] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ; 
                                     expected_data[44] <=  prbs_in[3] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[45] <=  prbs_in[0] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[46] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[5] ; 
                                     expected_data[47] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[6] ; 
                                     expected_data[48] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[49] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[50] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[51] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ; 
                                     expected_data[52] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[53] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[54] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[55] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[56] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ; 
                                     expected_data[57] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[58] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[59] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[5] ; 
                                     expected_data[60] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[61] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[62] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[63] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[64] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[65] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[66] <=  prbs_in[1] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[67] <=  prbs_in[2] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[68] <=  prbs_in[0] ^ prbs_in[3] ; 
                                     expected_data[69] <=  prbs_in[1] ^ prbs_in[4] ; 
                                     expected_data[70] <=  prbs_in[2] ^ prbs_in[5] ; 
                                     expected_data[71] <=  prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[72] <=  prbs_in[0] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[73] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[74] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ; 
                                     expected_data[75] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[76] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[77] <=  prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[78] <=  prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[79] <=  prbs_in[0] ^ prbs_in[5] ; 
                                     expected_data[80] <=  prbs_in[1] ^ prbs_in[6] ; 
                                     expected_data[81] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[6] ; 
                                     expected_data[82] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[83] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[84] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[85] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[86] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[87] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[88] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[89] <=  prbs_in[1] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[90] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[5] ; 
                                     expected_data[91] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[92] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[93] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[94] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[4] ; 
                                     expected_data[95] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[5] ; 
                                     expected_data[96] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[97] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[98] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[99] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[100] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[101] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[102] <=  prbs_in[2] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[103] <=  prbs_in[3] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[104] <=  prbs_in[0] ^ prbs_in[4] ; 
                                     expected_data[105] <=  prbs_in[1] ^ prbs_in[5] ; 
                                     expected_data[106] <=  prbs_in[2] ^ prbs_in[6] ; 
                                     expected_data[107] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[108] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[109] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[110] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[111] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[112] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[113] <=  prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[114] <=  prbs_in[0] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[115] <=  prbs_in[1] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[116] <=  prbs_in[0] ^ prbs_in[2] ; 
                                     expected_data[117] <=  prbs_in[1] ^ prbs_in[3] ; 
                                     expected_data[118] <=  prbs_in[2] ^ prbs_in[4] ; 
                                     expected_data[119] <=  prbs_in[3] ^ prbs_in[5] ; 
                                     expected_data[120] <=  prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[121] <=  prbs_in[0] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[122] <=  prbs_in[0] ^ prbs_in[1] ; 
                                     expected_data[123] <=  prbs_in[1] ^ prbs_in[2] ; 
                                     expected_data[124] <=  prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[125] <=  prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[126] <=  prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[127] <=  prbs_in[5] ^ prbs_in[6] ; 
                                end
                            end
							SEL_PRBS_15 : begin
                            // prbs_in 2^15 (T[15, 14]) (parallel 128-bit serializer)
                                if( update_prbs_expt_data) begin
                                     expected_data[0] <=  prbs_in[6] ^ prbs_in[7] ^ prbs_in[12] ^ prbs_in[14] ; 
                                     expected_data[1] <=  prbs_in[0] ^ prbs_in[7] ^ prbs_in[8] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[2] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[8] ^ prbs_in[9] ; 
                                     expected_data[3] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[9] ^ prbs_in[10] ; 
                                     expected_data[4] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[10] ^ prbs_in[11] ; 
                                     expected_data[5] <=  prbs_in[3] ^ prbs_in[4] ^ prbs_in[11] ^ prbs_in[12] ; 
                                     expected_data[6] <=  prbs_in[4] ^ prbs_in[5] ^ prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[7] <=  prbs_in[5] ^ prbs_in[6] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[8] <=  prbs_in[0] ^ prbs_in[6] ^ prbs_in[7] ; 
                                     expected_data[9] <=  prbs_in[1] ^ prbs_in[7] ^ prbs_in[8] ; 
                                     expected_data[10] <=  prbs_in[2] ^ prbs_in[8] ^ prbs_in[9] ; 
                                     expected_data[11] <=  prbs_in[3] ^ prbs_in[9] ^ prbs_in[10] ; 
                                     expected_data[12] <=  prbs_in[4] ^ prbs_in[10] ^ prbs_in[11] ; 
                                     expected_data[13] <=  prbs_in[5] ^ prbs_in[11] ^ prbs_in[12] ; 
                                     expected_data[14] <=  prbs_in[6] ^ prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[15] <=  prbs_in[7] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[16] <=  prbs_in[0] ^ prbs_in[8] ; 
                                     expected_data[17] <=  prbs_in[1] ^ prbs_in[9] ; 
                                     expected_data[18] <=  prbs_in[2] ^ prbs_in[10] ; 
                                     expected_data[19] <=  prbs_in[3] ^ prbs_in[11] ; 
                                     expected_data[20] <=  prbs_in[4] ^ prbs_in[12] ; 
                                     expected_data[21] <=  prbs_in[5] ^ prbs_in[13] ; 
                                     expected_data[22] <=  prbs_in[6] ^ prbs_in[14] ; 
                                     expected_data[23] <=  prbs_in[0] ^ prbs_in[7] ^ prbs_in[14] ; 
                                     expected_data[24] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[8] ^ prbs_in[14] ; 
                                     expected_data[25] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[9] ^ prbs_in[14] ; 
                                     expected_data[26] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[10] ^ prbs_in[14] ; 
                                     expected_data[27] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[11] ^ prbs_in[14] ; 
                                     expected_data[28] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[12] ^ prbs_in[14] ; 
                                     expected_data[29] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[30] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ^ prbs_in[7] ; 
                                     expected_data[31] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ^ prbs_in[7] ^ prbs_in[8] ; 
                                     expected_data[32] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ^ prbs_in[7] ^ prbs_in[8] ^ prbs_in[9] ; 
                                     expected_data[33] <=  prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ^ prbs_in[7] ^ prbs_in[8] ^ prbs_in[9] ^ prbs_in[10] ; 
                                     expected_data[34] <=  prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ^ prbs_in[7] ^ prbs_in[8] ^ prbs_in[9] ^ prbs_in[10] ^ prbs_in[11] ; 
                                     expected_data[35] <=  prbs_in[5] ^ prbs_in[6] ^ prbs_in[7] ^ prbs_in[8] ^ prbs_in[9] ^ prbs_in[10] ^ prbs_in[11] ^ prbs_in[12] ; 
                                     expected_data[36] <=  prbs_in[6] ^ prbs_in[7] ^ prbs_in[8] ^ prbs_in[9] ^ prbs_in[10] ^ prbs_in[11] ^ prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[37] <=  prbs_in[7] ^ prbs_in[8] ^ prbs_in[9] ^ prbs_in[10] ^ prbs_in[11] ^ prbs_in[12] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[38] <=  prbs_in[0] ^ prbs_in[8] ^ prbs_in[9] ^ prbs_in[10] ^ prbs_in[11] ^ prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[39] <=  prbs_in[1] ^ prbs_in[9] ^ prbs_in[10] ^ prbs_in[11] ^ prbs_in[12] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[40] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[10] ^ prbs_in[11] ^ prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[41] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[11] ^ prbs_in[12] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[42] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[43] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[44] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[45] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[5] ^ prbs_in[7] ; 
                                     expected_data[46] <=  prbs_in[2] ^ prbs_in[4] ^ prbs_in[6] ^ prbs_in[8] ; 
                                     expected_data[47] <=  prbs_in[3] ^ prbs_in[5] ^ prbs_in[7] ^ prbs_in[9] ; 
                                     expected_data[48] <=  prbs_in[4] ^ prbs_in[6] ^ prbs_in[8] ^ prbs_in[10] ; 
                                     expected_data[49] <=  prbs_in[5] ^ prbs_in[7] ^ prbs_in[9] ^ prbs_in[11] ; 
                                     expected_data[50] <=  prbs_in[6] ^ prbs_in[8] ^ prbs_in[10] ^ prbs_in[12] ; 
                                     expected_data[51] <=  prbs_in[7] ^ prbs_in[9] ^ prbs_in[11] ^ prbs_in[13] ; 
                                     expected_data[52] <=  prbs_in[8] ^ prbs_in[10] ^ prbs_in[12] ^ prbs_in[14] ; 
                                     expected_data[53] <=  prbs_in[0] ^ prbs_in[9] ^ prbs_in[11] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[54] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[10] ^ prbs_in[12] ; 
                                     expected_data[55] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[11] ^ prbs_in[13] ; 
                                     expected_data[56] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[12] ^ prbs_in[14] ; 
                                     expected_data[57] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[58] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[59] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[60] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[6] ^ prbs_in[7] ; 
                                     expected_data[61] <=  prbs_in[3] ^ prbs_in[4] ^ prbs_in[7] ^ prbs_in[8] ; 
                                     expected_data[62] <=  prbs_in[4] ^ prbs_in[5] ^ prbs_in[8] ^ prbs_in[9] ; 
                                     expected_data[63] <=  prbs_in[5] ^ prbs_in[6] ^ prbs_in[9] ^ prbs_in[10] ; 
                                     expected_data[64] <=  prbs_in[6] ^ prbs_in[7] ^ prbs_in[10] ^ prbs_in[11] ; 
                                     expected_data[65] <=  prbs_in[7] ^ prbs_in[8] ^ prbs_in[11] ^ prbs_in[12] ; 
                                     expected_data[66] <=  prbs_in[8] ^ prbs_in[9] ^ prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[67] <=  prbs_in[9] ^ prbs_in[10] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[68] <=  prbs_in[0] ^ prbs_in[10] ^ prbs_in[11] ; 
                                     expected_data[69] <=  prbs_in[1] ^ prbs_in[11] ^ prbs_in[12] ; 
                                     expected_data[70] <=  prbs_in[2] ^ prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[71] <=  prbs_in[3] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[72] <=  prbs_in[0] ^ prbs_in[4] ; 
                                     expected_data[73] <=  prbs_in[1] ^ prbs_in[5] ; 
                                     expected_data[74] <=  prbs_in[2] ^ prbs_in[6] ; 
                                     expected_data[75] <=  prbs_in[3] ^ prbs_in[7] ; 
                                     expected_data[76] <=  prbs_in[4] ^ prbs_in[8] ; 
                                     expected_data[77] <=  prbs_in[5] ^ prbs_in[9] ; 
                                     expected_data[78] <=  prbs_in[6] ^ prbs_in[10] ; 
                                     expected_data[79] <=  prbs_in[7] ^ prbs_in[11] ; 
                                     expected_data[80] <=  prbs_in[8] ^ prbs_in[12] ; 
                                     expected_data[81] <=  prbs_in[9] ^ prbs_in[13] ; 
                                     expected_data[82] <=  prbs_in[10] ^ prbs_in[14] ; 
                                     expected_data[83] <=  prbs_in[0] ^ prbs_in[11] ^ prbs_in[14] ; 
                                     expected_data[84] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[12] ^ prbs_in[14] ; 
                                     expected_data[85] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[86] <=  prbs_in[0] ^ prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[87] <=  prbs_in[1] ^ prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[88] <=  prbs_in[2] ^ prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[89] <=  prbs_in[3] ^ prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[90] <=  prbs_in[4] ^ prbs_in[5] ^ prbs_in[6] ^ prbs_in[7] ; 
                                     expected_data[91] <=  prbs_in[5] ^ prbs_in[6] ^ prbs_in[7] ^ prbs_in[8] ; 
                                     expected_data[92] <=  prbs_in[6] ^ prbs_in[7] ^ prbs_in[8] ^ prbs_in[9] ; 
                                     expected_data[93] <=  prbs_in[7] ^ prbs_in[8] ^ prbs_in[9] ^ prbs_in[10] ; 
                                     expected_data[94] <=  prbs_in[8] ^ prbs_in[9] ^ prbs_in[10] ^ prbs_in[11] ; 
                                     expected_data[95] <=  prbs_in[9] ^ prbs_in[10] ^ prbs_in[11] ^ prbs_in[12] ; 
                                     expected_data[96] <=  prbs_in[10] ^ prbs_in[11] ^ prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[97] <=  prbs_in[11] ^ prbs_in[12] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[98] <=  prbs_in[0] ^ prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[99] <=  prbs_in[1] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[100] <=  prbs_in[0] ^ prbs_in[2] ; 
                                     expected_data[101] <=  prbs_in[1] ^ prbs_in[3] ; 
                                     expected_data[102] <=  prbs_in[2] ^ prbs_in[4] ; 
                                     expected_data[103] <=  prbs_in[3] ^ prbs_in[5] ; 
                                     expected_data[104] <=  prbs_in[4] ^ prbs_in[6] ; 
                                     expected_data[105] <=  prbs_in[5] ^ prbs_in[7] ; 
                                     expected_data[106] <=  prbs_in[6] ^ prbs_in[8] ; 
                                     expected_data[107] <=  prbs_in[7] ^ prbs_in[9] ; 
                                     expected_data[108] <=  prbs_in[8] ^ prbs_in[10] ; 
                                     expected_data[109] <=  prbs_in[9] ^ prbs_in[11] ; 
                                     expected_data[110] <=  prbs_in[10] ^ prbs_in[12] ; 
                                     expected_data[111] <=  prbs_in[11] ^ prbs_in[13] ; 
                                     expected_data[112] <=  prbs_in[12] ^ prbs_in[14] ; 
                                     expected_data[113] <=  prbs_in[0] ^ prbs_in[13] ^ prbs_in[14] ; 
                                     expected_data[114] <=  prbs_in[0] ^ prbs_in[1] ; 
                                     expected_data[115] <=  prbs_in[1] ^ prbs_in[2] ; 
                                     expected_data[116] <=  prbs_in[2] ^ prbs_in[3] ; 
                                     expected_data[117] <=  prbs_in[3] ^ prbs_in[4] ; 
                                     expected_data[118] <=  prbs_in[4] ^ prbs_in[5] ; 
                                     expected_data[119] <=  prbs_in[5] ^ prbs_in[6] ; 
                                     expected_data[120] <=  prbs_in[6] ^ prbs_in[7] ; 
                                     expected_data[121] <=  prbs_in[7] ^ prbs_in[8] ; 
                                     expected_data[122] <=  prbs_in[8] ^ prbs_in[9] ; 
                                     expected_data[123] <=  prbs_in[9] ^ prbs_in[10] ; 
                                     expected_data[124] <=  prbs_in[10] ^ prbs_in[11] ; 
                                     expected_data[125] <=  prbs_in[11] ^ prbs_in[12] ; 
                                     expected_data[126] <=  prbs_in[12] ^ prbs_in[13] ; 
                                     expected_data[127] <=  prbs_in[13] ^ prbs_in[14] ; 
                                 end
                            end
							SEL_PRBS_23 : begin
                            // prbs_in 2^23-1 (T[23,18]) (parallel 128-bit serializer)
                                if ( update_prbs_expt_data ) begin
                                     expected_data[0] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[8] ^ prbs_in[10] ^ prbs_in[13] ^ prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[1] <=  prbs_in[1] ^ prbs_in[4] ^ prbs_in[9] ^ prbs_in[11] ^ prbs_in[14] ^ prbs_in[17] ^ prbs_in[22] ; 
                                     expected_data[2] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[5] ^ prbs_in[10] ^ prbs_in[12] ^ prbs_in[15] ; 
                                     expected_data[3] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[6] ^ prbs_in[11] ^ prbs_in[13] ^ prbs_in[16] ; 
                                     expected_data[4] <=  prbs_in[2] ^ prbs_in[4] ^ prbs_in[7] ^ prbs_in[12] ^ prbs_in[14] ^ prbs_in[17] ; 
                                     expected_data[5] <=  prbs_in[3] ^ prbs_in[5] ^ prbs_in[8] ^ prbs_in[13] ^ prbs_in[15] ^ prbs_in[18] ; 
                                     expected_data[6] <=  prbs_in[4] ^ prbs_in[6] ^ prbs_in[9] ^ prbs_in[14] ^ prbs_in[16] ^ prbs_in[19] ; 
                                     expected_data[7] <=  prbs_in[5] ^ prbs_in[7] ^ prbs_in[10] ^ prbs_in[15] ^ prbs_in[17] ^ prbs_in[20] ; 
                                     expected_data[8] <=  prbs_in[6] ^ prbs_in[8] ^ prbs_in[11] ^ prbs_in[16] ^ prbs_in[18] ^ prbs_in[21] ; 
                                     expected_data[9] <=  prbs_in[7] ^ prbs_in[9] ^ prbs_in[12] ^ prbs_in[17] ^ prbs_in[19] ^ prbs_in[22] ; 
                                     expected_data[10] <=  prbs_in[0] ^ prbs_in[8] ^ prbs_in[10] ^ prbs_in[13] ^ prbs_in[20] ; 
                                     expected_data[11] <=  prbs_in[1] ^ prbs_in[9] ^ prbs_in[11] ^ prbs_in[14] ^ prbs_in[21] ; 
                                     expected_data[12] <=  prbs_in[2] ^ prbs_in[10] ^ prbs_in[12] ^ prbs_in[15] ^ prbs_in[22] ; 
                                     expected_data[13] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[11] ^ prbs_in[13] ^ prbs_in[16] ^ prbs_in[18] ; 
                                     expected_data[14] <=  prbs_in[1] ^ prbs_in[4] ^ prbs_in[12] ^ prbs_in[14] ^ prbs_in[17] ^ prbs_in[19] ; 
                                     expected_data[15] <=  prbs_in[2] ^ prbs_in[5] ^ prbs_in[13] ^ prbs_in[15] ^ prbs_in[18] ^ prbs_in[20] ; 
                                     expected_data[16] <=  prbs_in[3] ^ prbs_in[6] ^ prbs_in[14] ^ prbs_in[16] ^ prbs_in[19] ^ prbs_in[21] ; 
                                     expected_data[17] <=  prbs_in[4] ^ prbs_in[7] ^ prbs_in[15] ^ prbs_in[17] ^ prbs_in[20] ^ prbs_in[22] ; 
                                     expected_data[18] <=  prbs_in[0] ^ prbs_in[5] ^ prbs_in[8] ^ prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[19] <=  prbs_in[1] ^ prbs_in[6] ^ prbs_in[9] ^ prbs_in[17] ^ prbs_in[22] ; 
                                     expected_data[20] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[7] ^ prbs_in[10] ; 
                                     expected_data[21] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[8] ^ prbs_in[11] ; 
                                     expected_data[22] <=  prbs_in[2] ^ prbs_in[4] ^ prbs_in[9] ^ prbs_in[12] ; 
                                     expected_data[23] <=  prbs_in[3] ^ prbs_in[5] ^ prbs_in[10] ^ prbs_in[13] ; 
                                     expected_data[24] <=  prbs_in[4] ^ prbs_in[6] ^ prbs_in[11] ^ prbs_in[14] ; 
                                     expected_data[25] <=  prbs_in[5] ^ prbs_in[7] ^ prbs_in[12] ^ prbs_in[15] ; 
                                     expected_data[26] <=  prbs_in[6] ^ prbs_in[8] ^ prbs_in[13] ^ prbs_in[16] ; 
                                     expected_data[27] <=  prbs_in[7] ^ prbs_in[9] ^ prbs_in[14] ^ prbs_in[17] ; 
                                     expected_data[28] <=  prbs_in[8] ^ prbs_in[10] ^ prbs_in[15] ^ prbs_in[18] ; 
                                     expected_data[29] <=  prbs_in[9] ^ prbs_in[11] ^ prbs_in[16] ^ prbs_in[19] ; 
                                     expected_data[30] <=  prbs_in[10] ^ prbs_in[12] ^ prbs_in[17] ^ prbs_in[20] ; 
                                     expected_data[31] <=  prbs_in[11] ^ prbs_in[13] ^ prbs_in[18] ^ prbs_in[21] ; 
                                     expected_data[32] <=  prbs_in[12] ^ prbs_in[14] ^ prbs_in[19] ^ prbs_in[22] ; 
                                     expected_data[33] <=  prbs_in[0] ^ prbs_in[13] ^ prbs_in[15] ^ prbs_in[18] ^ prbs_in[20] ; 
                                     expected_data[34] <=  prbs_in[1] ^ prbs_in[14] ^ prbs_in[16] ^ prbs_in[19] ^ prbs_in[21] ; 
                                     expected_data[35] <=  prbs_in[2] ^ prbs_in[15] ^ prbs_in[17] ^ prbs_in[20] ^ prbs_in[22] ; 
                                     expected_data[36] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[37] <=  prbs_in[1] ^ prbs_in[4] ^ prbs_in[17] ^ prbs_in[22] ; 
                                     expected_data[38] <=  prbs_in[0] ^ prbs_in[2] ^ prbs_in[5] ; 
                                     expected_data[39] <=  prbs_in[1] ^ prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[40] <=  prbs_in[2] ^ prbs_in[4] ^ prbs_in[7] ; 
                                     expected_data[41] <=  prbs_in[3] ^ prbs_in[5] ^ prbs_in[8] ; 
                                     expected_data[42] <=  prbs_in[4] ^ prbs_in[6] ^ prbs_in[9] ; 
                                     expected_data[43] <=  prbs_in[5] ^ prbs_in[7] ^ prbs_in[10] ; 
                                     expected_data[44] <=  prbs_in[6] ^ prbs_in[8] ^ prbs_in[11] ; 
                                     expected_data[45] <=  prbs_in[7] ^ prbs_in[9] ^ prbs_in[12] ; 
                                     expected_data[46] <=  prbs_in[8] ^ prbs_in[10] ^ prbs_in[13] ; 
                                     expected_data[47] <=  prbs_in[9] ^ prbs_in[11] ^ prbs_in[14] ; 
                                     expected_data[48] <=  prbs_in[10] ^ prbs_in[12] ^ prbs_in[15] ; 
                                     expected_data[49] <=  prbs_in[11] ^ prbs_in[13] ^ prbs_in[16] ; 
                                     expected_data[50] <=  prbs_in[12] ^ prbs_in[14] ^ prbs_in[17] ; 
                                     expected_data[51] <=  prbs_in[13] ^ prbs_in[15] ^ prbs_in[18] ; 
                                     expected_data[52] <=  prbs_in[14] ^ prbs_in[16] ^ prbs_in[19] ; 
                                     expected_data[53] <=  prbs_in[15] ^ prbs_in[17] ^ prbs_in[20] ; 
                                     expected_data[54] <=  prbs_in[16] ^ prbs_in[18] ^ prbs_in[21] ; 
                                     expected_data[55] <=  prbs_in[17] ^ prbs_in[19] ^ prbs_in[22] ; 
                                     expected_data[56] <=  prbs_in[0] ^ prbs_in[20] ; 
                                     expected_data[57] <=  prbs_in[1] ^ prbs_in[21] ; 
                                     expected_data[58] <=  prbs_in[2] ^ prbs_in[22] ; 
                                     expected_data[59] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[18] ; 
                                     expected_data[60] <=  prbs_in[1] ^ prbs_in[4] ^ prbs_in[19] ; 
                                     expected_data[61] <=  prbs_in[2] ^ prbs_in[5] ^ prbs_in[20] ; 
                                     expected_data[62] <=  prbs_in[3] ^ prbs_in[6] ^ prbs_in[21] ; 
                                     expected_data[63] <=  prbs_in[4] ^ prbs_in[7] ^ prbs_in[22] ; 
                                     expected_data[64] <=  prbs_in[0] ^ prbs_in[5] ^ prbs_in[8] ^ prbs_in[18] ; 
                                     expected_data[65] <=  prbs_in[1] ^ prbs_in[6] ^ prbs_in[9] ^ prbs_in[19] ; 
                                     expected_data[66] <=  prbs_in[2] ^ prbs_in[7] ^ prbs_in[10] ^ prbs_in[20] ; 
                                     expected_data[67] <=  prbs_in[3] ^ prbs_in[8] ^ prbs_in[11] ^ prbs_in[21] ; 
                                     expected_data[68] <=  prbs_in[4] ^ prbs_in[9] ^ prbs_in[12] ^ prbs_in[22] ; 
                                     expected_data[69] <=  prbs_in[0] ^ prbs_in[5] ^ prbs_in[10] ^ prbs_in[13] ^ prbs_in[18] ; 
                                     expected_data[70] <=  prbs_in[1] ^ prbs_in[6] ^ prbs_in[11] ^ prbs_in[14] ^ prbs_in[19] ; 
                                     expected_data[71] <=  prbs_in[2] ^ prbs_in[7] ^ prbs_in[12] ^ prbs_in[15] ^ prbs_in[20] ; 
                                     expected_data[72] <=  prbs_in[3] ^ prbs_in[8] ^ prbs_in[13] ^ prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[73] <=  prbs_in[4] ^ prbs_in[9] ^ prbs_in[14] ^ prbs_in[17] ^ prbs_in[22] ; 
                                     expected_data[74] <=  prbs_in[0] ^ prbs_in[5] ^ prbs_in[10] ^ prbs_in[15] ; 
                                     expected_data[75] <=  prbs_in[1] ^ prbs_in[6] ^ prbs_in[11] ^ prbs_in[16] ; 
                                     expected_data[76] <=  prbs_in[2] ^ prbs_in[7] ^ prbs_in[12] ^ prbs_in[17] ; 
                                     expected_data[77] <=  prbs_in[3] ^ prbs_in[8] ^ prbs_in[13] ^ prbs_in[18] ; 
                                     expected_data[78] <=  prbs_in[4] ^ prbs_in[9] ^ prbs_in[14] ^ prbs_in[19] ; 
                                     expected_data[79] <=  prbs_in[5] ^ prbs_in[10] ^ prbs_in[15] ^ prbs_in[20] ; 
                                     expected_data[80] <=  prbs_in[6] ^ prbs_in[11] ^ prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[81] <=  prbs_in[7] ^ prbs_in[12] ^ prbs_in[17] ^ prbs_in[22] ; 
                                     expected_data[82] <=  prbs_in[0] ^ prbs_in[8] ^ prbs_in[13] ; 
                                     expected_data[83] <=  prbs_in[1] ^ prbs_in[9] ^ prbs_in[14] ; 
                                     expected_data[84] <=  prbs_in[2] ^ prbs_in[10] ^ prbs_in[15] ; 
                                     expected_data[85] <=  prbs_in[3] ^ prbs_in[11] ^ prbs_in[16] ; 
                                     expected_data[86] <=  prbs_in[4] ^ prbs_in[12] ^ prbs_in[17] ; 
                                     expected_data[87] <=  prbs_in[5] ^ prbs_in[13] ^ prbs_in[18] ; 
                                     expected_data[88] <=  prbs_in[6] ^ prbs_in[14] ^ prbs_in[19] ; 
                                     expected_data[89] <=  prbs_in[7] ^ prbs_in[15] ^ prbs_in[20] ; 
                                     expected_data[90] <=  prbs_in[8] ^ prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[91] <=  prbs_in[9] ^ prbs_in[17] ^ prbs_in[22] ; 
                                     expected_data[92] <=  prbs_in[0] ^ prbs_in[10] ; 
                                     expected_data[93] <=  prbs_in[1] ^ prbs_in[11] ; 
                                     expected_data[94] <=  prbs_in[2] ^ prbs_in[12] ; 
                                     expected_data[95] <=  prbs_in[3] ^ prbs_in[13] ; 
                                     expected_data[96] <=  prbs_in[4] ^ prbs_in[14] ; 
                                     expected_data[97] <=  prbs_in[5] ^ prbs_in[15] ; 
                                     expected_data[98] <=  prbs_in[6] ^ prbs_in[16] ; 
                                     expected_data[99] <=  prbs_in[7] ^ prbs_in[17] ; 
                                     expected_data[100] <=  prbs_in[8] ^ prbs_in[18] ; 
                                     expected_data[101] <=  prbs_in[9] ^ prbs_in[19] ; 
                                     expected_data[102] <=  prbs_in[10] ^ prbs_in[20] ; 
                                     expected_data[103] <=  prbs_in[11] ^ prbs_in[21] ; 
                                     expected_data[104] <=  prbs_in[12] ^ prbs_in[22] ; 
                                     expected_data[105] <=  prbs_in[0] ^ prbs_in[13] ^ prbs_in[18] ; 
                                     expected_data[106] <=  prbs_in[1] ^ prbs_in[14] ^ prbs_in[19] ; 
                                     expected_data[107] <=  prbs_in[2] ^ prbs_in[15] ^ prbs_in[20] ; 
                                     expected_data[108] <=  prbs_in[3] ^ prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[109] <=  prbs_in[4] ^ prbs_in[17] ^ prbs_in[22] ; 
                                     expected_data[110] <=  prbs_in[0] ^ prbs_in[5] ; 
                                     expected_data[111] <=  prbs_in[1] ^ prbs_in[6] ; 
                                     expected_data[112] <=  prbs_in[2] ^ prbs_in[7] ; 
                                     expected_data[113] <=  prbs_in[3] ^ prbs_in[8] ; 
                                     expected_data[114] <=  prbs_in[4] ^ prbs_in[9] ; 
                                     expected_data[115] <=  prbs_in[5] ^ prbs_in[10] ; 
                                     expected_data[116] <=  prbs_in[6] ^ prbs_in[11] ; 
                                     expected_data[117] <=  prbs_in[7] ^ prbs_in[12] ; 
                                     expected_data[118] <=  prbs_in[8] ^ prbs_in[13] ; 
                                     expected_data[119] <=  prbs_in[9] ^ prbs_in[14] ; 
                                     expected_data[120] <=  prbs_in[10] ^ prbs_in[15] ; 
                                     expected_data[121] <=  prbs_in[11] ^ prbs_in[16] ; 
                                     expected_data[122] <=  prbs_in[12] ^ prbs_in[17] ; 
                                     expected_data[123] <=  prbs_in[13] ^ prbs_in[18] ; 
                                     expected_data[124] <=  prbs_in[14] ^ prbs_in[19] ; 
                                     expected_data[125] <=  prbs_in[15] ^ prbs_in[20] ; 
                                     expected_data[126] <=  prbs_in[16] ^ prbs_in[21] ; 
                                     expected_data[127] <=  prbs_in[17] ^ prbs_in[22] ; 
                                end
                            end
							SEL_PRBS_31 : begin
                            // prbs_in 2^31-1 (T[31,28]) (parallel 128-bit serializer)
                                if ( update_prbs_expt_data) begin
                                     expected_data[0] <=  prbs_in[12] ^ prbs_in[15] ^ prbs_in[24] ^ prbs_in[27] ; 
                                     expected_data[1] <=  prbs_in[13] ^ prbs_in[16] ^ prbs_in[25] ^ prbs_in[28] ; 
                                     expected_data[2] <=  prbs_in[14] ^ prbs_in[17] ^ prbs_in[26] ^ prbs_in[29] ; 
                                     expected_data[3] <=  prbs_in[15] ^ prbs_in[18] ^ prbs_in[27] ^ prbs_in[30] ; 
                                     expected_data[4] <=  prbs_in[0] ^ prbs_in[16] ^ prbs_in[19] ; 
                                     expected_data[5] <=  prbs_in[1] ^ prbs_in[17] ^ prbs_in[20] ; 
                                     expected_data[6] <=  prbs_in[2] ^ prbs_in[18] ^ prbs_in[21] ; 
                                     expected_data[7] <=  prbs_in[3] ^ prbs_in[19] ^ prbs_in[22] ; 
                                     expected_data[8] <=  prbs_in[4] ^ prbs_in[20] ^ prbs_in[23] ; 
                                     expected_data[9] <=  prbs_in[5] ^ prbs_in[21] ^ prbs_in[24] ; 
                                     expected_data[10] <=  prbs_in[6] ^ prbs_in[22] ^ prbs_in[25] ; 
                                     expected_data[11] <=  prbs_in[7] ^ prbs_in[23] ^ prbs_in[26] ; 
                                     expected_data[12] <=  prbs_in[8] ^ prbs_in[24] ^ prbs_in[27] ; 
                                     expected_data[13] <=  prbs_in[9] ^ prbs_in[25] ^ prbs_in[28] ; 
                                     expected_data[14] <=  prbs_in[10] ^ prbs_in[26] ^ prbs_in[29] ; 
                                     expected_data[15] <=  prbs_in[11] ^ prbs_in[27] ^ prbs_in[30] ; 
                                     expected_data[16] <=  prbs_in[0] ^ prbs_in[12] ; 
                                     expected_data[17] <=  prbs_in[1] ^ prbs_in[13] ; 
                                     expected_data[18] <=  prbs_in[2] ^ prbs_in[14] ; 
                                     expected_data[19] <=  prbs_in[3] ^ prbs_in[15] ; 
                                     expected_data[20] <=  prbs_in[4] ^ prbs_in[16] ; 
                                     expected_data[21] <=  prbs_in[5] ^ prbs_in[17] ; 
                                     expected_data[22] <=  prbs_in[6] ^ prbs_in[18] ; 
                                     expected_data[23] <=  prbs_in[7] ^ prbs_in[19] ; 
                                     expected_data[24] <=  prbs_in[8] ^ prbs_in[20] ; 
                                     expected_data[25] <=  prbs_in[9] ^ prbs_in[21] ; 
                                     expected_data[26] <=  prbs_in[10] ^ prbs_in[22] ; 
                                     expected_data[27] <=  prbs_in[11] ^ prbs_in[23] ; 
                                     expected_data[28] <=  prbs_in[12] ^ prbs_in[24] ; 
                                     expected_data[29] <=  prbs_in[13] ^ prbs_in[25] ; 
                                     expected_data[30] <=  prbs_in[14] ^ prbs_in[26] ; 
                                     expected_data[31] <=  prbs_in[15] ^ prbs_in[27] ; 
                                     expected_data[32] <=  prbs_in[16] ^ prbs_in[28] ; 
                                     expected_data[33] <=  prbs_in[17] ^ prbs_in[29] ; 
                                     expected_data[34] <=  prbs_in[18] ^ prbs_in[30] ; 
                                     expected_data[35] <=  prbs_in[0] ^ prbs_in[19] ^ prbs_in[28] ; 
                                     expected_data[36] <=  prbs_in[1] ^ prbs_in[20] ^ prbs_in[29] ; 
                                     expected_data[37] <=  prbs_in[2] ^ prbs_in[21] ^ prbs_in[30] ; 
                                     expected_data[38] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[22] ^ prbs_in[28] ; 
                                     expected_data[39] <=  prbs_in[1] ^ prbs_in[4] ^ prbs_in[23] ^ prbs_in[29] ; 
                                     expected_data[40] <=  prbs_in[2] ^ prbs_in[5] ^ prbs_in[24] ^ prbs_in[30] ; 
                                     expected_data[41] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[6] ^ prbs_in[25] ^ prbs_in[28] ; 
                                     expected_data[42] <=  prbs_in[1] ^ prbs_in[4] ^ prbs_in[7] ^ prbs_in[26] ^ prbs_in[29] ; 
                                     expected_data[43] <=  prbs_in[2] ^ prbs_in[5] ^ prbs_in[8] ^ prbs_in[27] ^ prbs_in[30] ; 
                                     expected_data[44] <=  prbs_in[0] ^ prbs_in[3] ^ prbs_in[6] ^ prbs_in[9] ; 
                                     expected_data[45] <=  prbs_in[1] ^ prbs_in[4] ^ prbs_in[7] ^ prbs_in[10] ; 
                                     expected_data[46] <=  prbs_in[2] ^ prbs_in[5] ^ prbs_in[8] ^ prbs_in[11] ; 
                                     expected_data[47] <=  prbs_in[3] ^ prbs_in[6] ^ prbs_in[9] ^ prbs_in[12] ; 
                                     expected_data[48] <=  prbs_in[4] ^ prbs_in[7] ^ prbs_in[10] ^ prbs_in[13] ; 
                                     expected_data[49] <=  prbs_in[5] ^ prbs_in[8] ^ prbs_in[11] ^ prbs_in[14] ; 
                                     expected_data[50] <=  prbs_in[6] ^ prbs_in[9] ^ prbs_in[12] ^ prbs_in[15] ; 
                                     expected_data[51] <=  prbs_in[7] ^ prbs_in[10] ^ prbs_in[13] ^ prbs_in[16] ; 
                                     expected_data[52] <=  prbs_in[8] ^ prbs_in[11] ^ prbs_in[14] ^ prbs_in[17] ; 
                                     expected_data[53] <=  prbs_in[9] ^ prbs_in[12] ^ prbs_in[15] ^ prbs_in[18] ; 
                                     expected_data[54] <=  prbs_in[10] ^ prbs_in[13] ^ prbs_in[16] ^ prbs_in[19] ; 
                                     expected_data[55] <=  prbs_in[11] ^ prbs_in[14] ^ prbs_in[17] ^ prbs_in[20] ; 
                                     expected_data[56] <=  prbs_in[12] ^ prbs_in[15] ^ prbs_in[18] ^ prbs_in[21] ; 
                                     expected_data[57] <=  prbs_in[13] ^ prbs_in[16] ^ prbs_in[19] ^ prbs_in[22] ; 
                                     expected_data[58] <=  prbs_in[14] ^ prbs_in[17] ^ prbs_in[20] ^ prbs_in[23] ; 
                                     expected_data[59] <=  prbs_in[15] ^ prbs_in[18] ^ prbs_in[21] ^ prbs_in[24] ; 
                                     expected_data[60] <=  prbs_in[16] ^ prbs_in[19] ^ prbs_in[22] ^ prbs_in[25] ; 
                                     expected_data[61] <=  prbs_in[17] ^ prbs_in[20] ^ prbs_in[23] ^ prbs_in[26] ; 
                                     expected_data[62] <=  prbs_in[18] ^ prbs_in[21] ^ prbs_in[24] ^ prbs_in[27] ; 
                                     expected_data[63] <=  prbs_in[19] ^ prbs_in[22] ^ prbs_in[25] ^ prbs_in[28] ; 
                                     expected_data[64] <=  prbs_in[20] ^ prbs_in[23] ^ prbs_in[26] ^ prbs_in[29] ; 
                                     expected_data[65] <=  prbs_in[21] ^ prbs_in[24] ^ prbs_in[27] ^ prbs_in[30] ; 
                                     expected_data[66] <=  prbs_in[0] ^ prbs_in[22] ^ prbs_in[25] ; 
                                     expected_data[67] <=  prbs_in[1] ^ prbs_in[23] ^ prbs_in[26] ; 
                                     expected_data[68] <=  prbs_in[2] ^ prbs_in[24] ^ prbs_in[27] ; 
                                     expected_data[69] <=  prbs_in[3] ^ prbs_in[25] ^ prbs_in[28] ; 
                                     expected_data[70] <=  prbs_in[4] ^ prbs_in[26] ^ prbs_in[29] ; 
                                     expected_data[71] <=  prbs_in[5] ^ prbs_in[27] ^ prbs_in[30] ; 
                                     expected_data[72] <=  prbs_in[0] ^ prbs_in[6] ; 
                                     expected_data[73] <=  prbs_in[1] ^ prbs_in[7] ; 
                                     expected_data[74] <=  prbs_in[2] ^ prbs_in[8] ; 
                                     expected_data[75] <=  prbs_in[3] ^ prbs_in[9] ; 
                                     expected_data[76] <=  prbs_in[4] ^ prbs_in[10] ; 
                                     expected_data[77] <=  prbs_in[5] ^ prbs_in[11] ; 
                                     expected_data[78] <=  prbs_in[6] ^ prbs_in[12] ; 
                                     expected_data[79] <=  prbs_in[7] ^ prbs_in[13] ; 
                                     expected_data[80] <=  prbs_in[8] ^ prbs_in[14] ; 
                                     expected_data[81] <=  prbs_in[9] ^ prbs_in[15] ; 
                                     expected_data[82] <=  prbs_in[10] ^ prbs_in[16] ; 
                                     expected_data[83] <=  prbs_in[11] ^ prbs_in[17] ; 
                                     expected_data[84] <=  prbs_in[12] ^ prbs_in[18] ; 
                                     expected_data[85] <=  prbs_in[13] ^ prbs_in[19] ; 
                                     expected_data[86] <=  prbs_in[14] ^ prbs_in[20] ; 
                                     expected_data[87] <=  prbs_in[15] ^ prbs_in[21] ; 
                                     expected_data[88] <=  prbs_in[16] ^ prbs_in[22] ; 
                                     expected_data[89] <=  prbs_in[17] ^ prbs_in[23] ; 
                                     expected_data[90] <=  prbs_in[18] ^ prbs_in[24] ; 
                                     expected_data[91] <=  prbs_in[19] ^ prbs_in[25] ; 
                                     expected_data[92] <=  prbs_in[20] ^ prbs_in[26] ; 
                                     expected_data[93] <=  prbs_in[21] ^ prbs_in[27] ; 
                                     expected_data[94] <=  prbs_in[22] ^ prbs_in[28] ; 
                                     expected_data[95] <=  prbs_in[23] ^ prbs_in[29] ; 
                                     expected_data[96] <=  prbs_in[24] ^ prbs_in[30] ; 
                                     expected_data[97] <=  prbs_in[0] ^ prbs_in[25] ^ prbs_in[28] ; 
                                     expected_data[98] <=  prbs_in[1] ^ prbs_in[26] ^ prbs_in[29] ; 
                                     expected_data[99] <=  prbs_in[2] ^ prbs_in[27] ^ prbs_in[30] ; 
                                     expected_data[100] <=  prbs_in[0] ^ prbs_in[3] ; 
                                     expected_data[101] <=  prbs_in[1] ^ prbs_in[4] ; 
                                     expected_data[102] <=  prbs_in[2] ^ prbs_in[5] ; 
                                     expected_data[103] <=  prbs_in[3] ^ prbs_in[6] ; 
                                     expected_data[104] <=  prbs_in[4] ^ prbs_in[7] ; 
                                     expected_data[105] <=  prbs_in[5] ^ prbs_in[8] ; 
                                     expected_data[106] <=  prbs_in[6] ^ prbs_in[9] ; 
                                     expected_data[107] <=  prbs_in[7] ^ prbs_in[10] ; 
                                     expected_data[108] <=  prbs_in[8] ^ prbs_in[11] ; 
                                     expected_data[109] <=  prbs_in[9] ^ prbs_in[12] ; 
                                     expected_data[110] <=  prbs_in[10] ^ prbs_in[13] ; 
                                     expected_data[111] <=  prbs_in[11] ^ prbs_in[14] ; 
                                     expected_data[112] <=  prbs_in[12] ^ prbs_in[15] ; 
                                     expected_data[113] <=  prbs_in[13] ^ prbs_in[16] ; 
                                     expected_data[114] <=  prbs_in[14] ^ prbs_in[17] ; 
                                     expected_data[115] <=  prbs_in[15] ^ prbs_in[18] ; 
                                     expected_data[116] <=  prbs_in[16] ^ prbs_in[19] ; 
                                     expected_data[117] <=  prbs_in[17] ^ prbs_in[20] ; 
                                     expected_data[118] <=  prbs_in[18] ^ prbs_in[21] ; 
                                     expected_data[119] <=  prbs_in[19] ^ prbs_in[22] ; 
                                     expected_data[120] <=  prbs_in[20] ^ prbs_in[23] ; 
                                     expected_data[121] <=  prbs_in[21] ^ prbs_in[24] ; 
                                     expected_data[122] <=  prbs_in[22] ^ prbs_in[25] ; 
                                     expected_data[123] <=  prbs_in[23] ^ prbs_in[26] ; 
                                     expected_data[124] <=  prbs_in[24] ^ prbs_in[27] ; 
                                     expected_data[125] <=  prbs_in[25] ^ prbs_in[28] ; 
                                     expected_data[126] <=  prbs_in[26] ^ prbs_in[29] ; 
                                     expected_data[127] <=  prbs_in[27] ^ prbs_in[30] ; 
                                end
                            end
							default: begin
								expected_data <= expected_data;
							end
                      endcase
                end // end else
            end // end always
		  end 
endgenerate
endmodule

module ones_counter
#(
    parameter ST_DATA_W = 40
)
(
    input clk,
    input reset,
    input sclr,

    input [ST_DATA_W-1 : 0] in_data,
    input                   in_valid,

    output reg         out_valid,
    output reg [7 : 0] out_data // expanded for 128-bit
);

    reg valid0, valid1, valid2, valid3, valid4;
    reg [ST_DATA_W-1 : 0] stage0; 
    reg [63 : 0]          stage1;// expanded for up to 128-bit
    reg [39 : 0]          stage2; 
    reg [23 : 0]          stage3; 
    reg [13 : 0]          stage4; 
    // ------------------------------------------------
    // Ones counter 
    // ------------------------------------------------
    
    // pipeline for valid
    always @(posedge clk or posedge reset) begin
      if (reset) begin
        valid0 <= 'b0;
        valid1 <= 'b0;
        valid2 <= 'b0;
        valid3 <= 'b0;
        valid4 <= 'b0;
        out_valid <= 'b0;
      end else begin
            valid0 <= in_valid;
            valid1 <= valid0;
            valid2 <= valid1;
            valid3 <= valid2;
            valid4 <= valid3;
            out_valid <= valid4;
      end // end if reset
    end // end always

    generate
        if (ST_DATA_W == 40) begin
            always @(posedge clk or posedge reset) begin
              if (reset) begin
                stage0 <= 'b0;
                stage1[29:0] <= 'b0;
                stage2[19:0] <= 'b0;
                stage3[13:0] <= 'b0;
                stage4[9:0] <= 'b0;
                out_data <= 'b0;
              end else begin
                    stage0 <= in_data;
                    /* simple method */
                    stage1[29:27] <= stage0[39] + stage0[38] + stage0[37] + stage0[36];
                    stage1[26:24] <= stage0[35] + stage0[34] + stage0[33] + stage0[32];
                    stage1[23:21] <= stage0[31] + stage0[30] + stage0[29] + stage0[28];
                    stage1[20:18] <= stage0[27] + stage0[26] + stage0[25] + stage0[24];
                    stage1[17:15] <= stage0[23] + stage0[22] + stage0[21] + stage0[20];
                    stage1[14:12] <= stage0[19] + stage0[18] + stage0[17] + stage0[16];
                    stage1[11:9] <= stage0[15] + stage0[14] + stage0[13] + stage0[12];
                    stage1[8:6] <= stage0[11] + stage0[10] + stage0[9] + stage0[8];
                    stage1[5:3] <= stage0[7] + stage0[6] + stage0[5] + stage0[4];
                    stage1[2:0] <= stage0[3] + stage0[2] + stage0[1] + stage0[0];
                    
                    stage2[19:16] <= stage1[29:27] + stage1[26:24];
                    stage2[15:12] <= stage1[23:21] + stage1[20:18];
                    stage2[11:8] <= stage1[17:15] + stage1[14:12];
                    stage2[7:4] <= stage1[11:9] + stage1[8:6];
                    stage2[3:0] <= stage1[5:3] + stage1[2:0];
                    
                    stage3[13:10] <= stage2[19:16];
                    stage3[9:5] <= stage2[15:12] + stage2[11:8];
                    stage3[4:0] <= stage2[7:4] + stage2[3:0];
                    
                    stage4[9:6] <= stage3[13:10];
                    stage4[5:0] <= stage3[9:5] + stage3[4:0];
                    
                    out_data <= stage4[5:0] + stage4[9:6];
              end // end if reset
            end // end always
        end else if (ST_DATA_W == 32) begin
            always @(posedge clk or posedge reset) begin
              if (reset) begin
                stage0 <= 'b0;
                stage1[23:0] <= 'b0;
                stage2[15:0] <= 'b0;
                stage3[9:0] <= 'b0;
                stage4[5:0] <= 'b0;
                out_data <= 'b0;
              end else begin
                    stage0 <= in_data;
                    /* simple method */
                    stage1[23:21] <= stage0[31] + stage0[30] + stage0[29] + stage0[28];
                    stage1[20:18] <= stage0[27] + stage0[26] + stage0[25] + stage0[24];
                    stage1[17:15] <= stage0[23] + stage0[22] + stage0[21] + stage0[20];
                    stage1[14:12] <= stage0[19] + stage0[18] + stage0[17] + stage0[16];
                    stage1[11:9] <= stage0[15] + stage0[14] + stage0[13] + stage0[12];
                    stage1[8:6] <= stage0[11] + stage0[10] + stage0[9] + stage0[8];
                    stage1[5:3] <= stage0[7] + stage0[6] + stage0[5] + stage0[4];
                    stage1[2:0] <= stage0[3] + stage0[2] + stage0[1] + stage0[0];
                    
                    stage2[15:12] <= stage1[23:21] + stage1[20:18];
                    stage2[11:8] <= stage1[17:15] + stage1[14:12];
                    stage2[7:4] <= stage1[11:9] + stage1[8:6];
                    stage2[3:0] <= stage1[5:3] + stage1[2:0];
                    
                    stage3[9:5] <= stage2[15:12] + stage2[11:8];
                    stage3[4:0] <= stage2[7:4] + stage2[3:0];
                    
                    stage4[5:0] <= stage3[9:5] + stage3[4:0];
                    
                    out_data <= stage4[5:0];
              end // end if reset
            end // end always
		end else if (ST_DATA_W == 64) begin
            always @(posedge clk or posedge reset) begin
              if (reset) begin
                stage0 <= 'b0;
                stage1[47:0] <= 'b0;
                stage2[31:0] <= 'b0;
                stage3[19:0] <= 'b0;
                stage4[11:0] <= 'b0;
                out_data <= 'b0;
              end else begin
                    stage0 <= in_data;
                    /* simple method */
					stage1[2:0] <= stage0[3] + stage0[2] + stage0[1] + stage0[0];
					stage1[5:3] <= stage0[7] + stage0[6] + stage0[5] + stage0[4];
					stage1[8:6] <= stage0[11] + stage0[10] + stage0[9] + stage0[8];
					stage1[11:9] <= stage0[15] + stage0[14] + stage0[13] + stage0[12];
					stage1[14:12] <= stage0[19] + stage0[18] + stage0[17] + stage0[16];
					stage1[17:15] <= stage0[23] + stage0[22] + stage0[21] + stage0[20];
					stage1[20:18] <= stage0[27] + stage0[26] + stage0[25] + stage0[24];
					stage1[23:21] <= stage0[31] + stage0[30] + stage0[29] + stage0[28];
					stage1[26:24] <= stage0[35] + stage0[34] + stage0[33] + stage0[32];
					stage1[29:27] <= stage0[39] + stage0[38] + stage0[37] + stage0[36];
					stage1[32:30] <= stage0[43] + stage0[42] + stage0[41] + stage0[40];
					stage1[35:33] <= stage0[47] + stage0[46] + stage0[45] + stage0[44];
					stage1[38:36] <= stage0[51] + stage0[50] + stage0[49] + stage0[48];
					stage1[41:39] <= stage0[55] + stage0[54] + stage0[53] + stage0[52];
					stage1[44:42] <= stage0[59] + stage0[58] + stage0[57] + stage0[56];
					stage1[47:45] <= stage0[63] + stage0[62] + stage0[61] + stage0[60];
                    
					stage2[3:0] <= stage1[5 : 3] + stage1[2 : 0];
					stage2[7:4] <= stage1[11 : 9] + stage1[8 : 6];
					stage2[11:8] <= stage1[17 : 15] + stage1[14 : 12];
					stage2[15:12] <= stage1[23 : 21] + stage1[20 : 18];
					stage2[19:16] <= stage1[29 : 27] + stage1[26 : 24];
					stage2[23:20] <= stage1[35 : 33] + stage1[32 : 30];
					stage2[27:24] <= stage1[41 : 39] + stage1[38 : 36];
					stage2[31:28] <= stage1[47 : 45] + stage1[44 : 42];
                    
					stage3[4:0] <= stage2[7 : 4] + stage2[3 : 0];
					stage3[9:5] <= stage2[15 : 12] + stage2[11 : 8];
					stage3[14:10] <= stage2[23 : 20] + stage2[19 : 16];
					stage3[19:15] <= stage2[31 : 28] + stage2[27 : 24];
                    
                    stage4[5:0] <= stage3[9:5] + stage3[4:0];
                    stage4[11:6] <= stage3[19:15] + stage3[14:10];
                    
                    out_data <= stage4[5:0] + stage4[11:6];
              end // end if reset
            end // end always
		end else if (ST_DATA_W == 66) begin		
            always @(posedge clk or posedge reset) begin
              if (reset) begin
                stage0 <= 'b0;
                stage1[49:0] <= 'b0;
                stage2[33:0] <= 'b0;
                stage3[21:0] <= 'b0;
                stage4[13:0] <= 'b0;
                out_data <= 'b0;
              end else begin
                    stage0 <= in_data;
                    /* simple method */
					stage1[2:0] <= stage0[3] + stage0[2] + stage0[1] + stage0[0];
					stage1[5:3] <= stage0[7] + stage0[6] + stage0[5] + stage0[4];
					stage1[8:6] <= stage0[11] + stage0[10] + stage0[9] + stage0[8];
					stage1[11:9] <= stage0[15] + stage0[14] + stage0[13] + stage0[12];
					stage1[14:12] <= stage0[19] + stage0[18] + stage0[17] + stage0[16];
					stage1[17:15] <= stage0[23] + stage0[22] + stage0[21] + stage0[20];
					stage1[20:18] <= stage0[27] + stage0[26] + stage0[25] + stage0[24];
					stage1[23:21] <= stage0[31] + stage0[30] + stage0[29] + stage0[28];
					stage1[26:24] <= stage0[35] + stage0[34] + stage0[33] + stage0[32];
					stage1[29:27] <= stage0[39] + stage0[38] + stage0[37] + stage0[36];
					stage1[32:30] <= stage0[43] + stage0[42] + stage0[41] + stage0[40];
					stage1[35:33] <= stage0[47] + stage0[46] + stage0[45] + stage0[44];
					stage1[38:36] <= stage0[51] + stage0[50] + stage0[49] + stage0[48];
					stage1[41:39] <= stage0[55] + stage0[54] + stage0[53] + stage0[52];
					stage1[44:42] <= stage0[59] + stage0[58] + stage0[57] + stage0[56];
					stage1[47:45] <= stage0[63] + stage0[62] + stage0[61] + stage0[60];
					stage1[49:48] <= stage0[65] + stage0[64] ;
                    
					stage2[3:0] <= stage1[5 : 3] + stage1[2 : 0];
					stage2[7:4] <= stage1[11 : 9] + stage1[8 : 6];
					stage2[11:8] <= stage1[17 : 15] + stage1[14 : 12];
					stage2[15:12] <= stage1[23 : 21] + stage1[20 : 18];
					stage2[19:16] <= stage1[29 : 27] + stage1[26 : 24];
					stage2[23:20] <= stage1[35 : 33] + stage1[32 : 30];
					stage2[27:24] <= stage1[41 : 39] + stage1[38 : 36];
					stage2[31:28] <= stage1[47 : 45] + stage1[44 : 42];
					stage2[33:32] <= stage1[49:48] ;
                    
					stage3[4:0] <= stage2[7 : 4] + stage2[3 : 0];
					stage3[9:5] <= stage2[15 : 12] + stage2[11 : 8];
					stage3[14:10] <= stage2[23 : 20] + stage2[19 : 16];
					stage3[19:15] <= stage2[31 : 28] + stage2[27 : 24];
                    stage3[21:20] <= stage2[33:32];
					
					
                    stage4[5:0] <= stage3[9:5] + stage3[4:0];
                    stage4[11:6] <= stage3[19:15] + stage3[14:10];
                    stage4[13:12] <= stage3[21:20];
					
                    out_data <= stage4[5:0] + stage4[11:6] + stage4[13:12] ;// add the top 2 bits at the end, since the maximum number is 66
              end // end if reset
            end // end always
		end else if (ST_DATA_W == 80) begin
            always @(posedge clk or posedge reset) begin
              if (reset) begin
                stage0 <= 'b0;
                stage1[39:0] <= 'b0;
                stage2[24:0] <= 'b0;
                stage3[16:0] <= 'b0;
                stage4[11:0] <= 'b0;
                out_data <= 'b0;
              end else begin
                    stage0 <= in_data;
                    /* simple method */
					stage1[3:0] <= stage0[7] + stage0[6] + stage0[5] + stage0[4] + stage0[3] + stage0[2] + stage0[1] + stage0[0] ;
					stage1[7:4] <= stage0[15] + stage0[14] + stage0[13] + stage0[12] + stage0[11] + stage0[10] + stage0[9] + stage0[8] ;
					stage1[11:8] <= stage0[23] + stage0[22] + stage0[21] + stage0[20] + stage0[19] + stage0[18] + stage0[17] + stage0[16] ;
					stage1[15:12] <= stage0[31] + stage0[30] + stage0[29] + stage0[28] + stage0[27] + stage0[26] + stage0[25] + stage0[24] ;
					stage1[19:16] <= stage0[39] + stage0[38] + stage0[37] + stage0[36] + stage0[35] + stage0[34] + stage0[33] + stage0[32] ;
					stage1[23:20] <= stage0[47] + stage0[46] + stage0[45] + stage0[44] + stage0[43] + stage0[42] + stage0[41] + stage0[40] ;
					stage1[27:24] <= stage0[55] + stage0[54] + stage0[53] + stage0[52] + stage0[51] + stage0[50] + stage0[49] + stage0[48] ;
					stage1[31:28] <= stage0[63] + stage0[62] + stage0[61] + stage0[60] + stage0[59] + stage0[58] + stage0[57] + stage0[56] ;
					stage1[35:32] <= stage0[71] + stage0[70] + stage0[69] + stage0[68] + stage0[67] + stage0[66] + stage0[65] + stage0[64] ;
					stage1[39:36] <= stage0[79] + stage0[78] + stage0[77] + stage0[76] + stage0[75] + stage0[74] + stage0[73] + stage0[72] ;

					
					stage2[4:0] <= stage1[7 : 4] + stage1[3 : 0] ;
					stage2[9:5] <= stage1[15 : 12] + stage1[11 : 8] ;
					stage2[14:10] <= stage1[23 : 20] + stage1[19 : 16] ;
					stage2[19:15] <= stage1[31 : 28] + stage1[27 : 24] ;
					stage2[24:20] <= stage1[39 : 36] + stage1[35 : 32] ;

					
					stage3[5:0] <= stage2[9 : 5] + stage2[4 : 0] ;
					stage3[11:6] <= stage2[19 : 15] + stage2[14 : 10] ;
					stage3[16:12] <= stage2[24 : 20] ; // changed to 16

					stage4[6:0] <= stage3[11:6] + stage3[5:0];
					stage4[11:7] <=stage3[16:12]; // stage4 for 80 bits
										
                    out_data <= stage4[6:0] + stage4[11:7];
              end // end if reset
            end // end always	
		end else if (ST_DATA_W == 50) begin
            always @(posedge clk or posedge reset) begin
              if (reset) begin
                stage0 <= 'b0;
                stage1[37:0] <= 'b0;
                stage2[25:0] <= 'b0;
                stage3[16:0] <= 'b0;
                stage4[11:0] <= 'b0;
                out_data <= 'b0;
              end else begin
                    stage0 <= in_data;
                    /* simple method */
					stage1[2:0] <= stage0[3] + stage0[2] + stage0[1] + stage0[0] ;
					stage1[5:3] <= stage0[7] + stage0[6] + stage0[5] + stage0[4] ;
					stage1[8:6] <= stage0[11] + stage0[10] + stage0[9] + stage0[8] ;
					stage1[11:9] <= stage0[15] + stage0[14] + stage0[13] + stage0[12] ;
					stage1[14:12] <= stage0[19] + stage0[18] + stage0[17] + stage0[16] ;
					stage1[17:15] <= stage0[23] + stage0[22] + stage0[21] + stage0[20] ;
					stage1[20:18] <= stage0[27] + stage0[26] + stage0[25] + stage0[24] ;
					stage1[23:21] <= stage0[31] + stage0[30] + stage0[29] + stage0[28] ;
					stage1[26:24] <= stage0[35] + stage0[34] + stage0[33] + stage0[32] ;
					stage1[29:27] <= stage0[39] + stage0[38] + stage0[37] + stage0[36] ;
					stage1[32:30] <= stage0[43] + stage0[42] + stage0[41] + stage0[40] ;
					stage1[35:33] <= stage0[47] + stage0[46] + stage0[45] + stage0[44] ;
					stage1[37:36] <= stage0[49] + stage0[48] ;
					
					stage2[3:0] <= stage1[5 : 3] + stage1[2 : 0] ;
					stage2[7:4] <= stage1[11 : 9] + stage1[8 : 6] ;
					stage2[11:8] <= stage1[17 : 15] + stage1[14 : 12] ;
					stage2[15:12] <= stage1[23 : 21] + stage1[20 : 18] ;
					stage2[19:16] <= stage1[29 : 27] + stage1[26 : 24] ;
					stage2[23:20] <= stage1[35 : 33] + stage1[32 : 30] ;
					stage2[25:24] <= stage1[37:36] ;

					stage3[4:0] <= stage2[7 : 4] + stage2[3 : 0] ;
					stage3[9:5] <= stage2[15 : 12] + stage2[11 : 8] ;
					stage3[14:10] <= stage2[23 : 20] + stage2[19 : 16] ;
					stage3[16:15] <= stage2[25:24] ;
					
					stage4[5:0] <= stage3[9:5] + stage3[4:0];
                    stage4[11:6] <= stage3[16:15] + stage3[14:10]; // for 50-bit= 48-bit + 2-bit , add the top 2 bits here
					
                    out_data <= stage4[5:0] + stage4[11:6];
              end // end if reset
            end // end always		
		end else if (ST_DATA_W == 128) begin
            always @(posedge clk or posedge reset) begin
              if (reset) begin
                stage0 <= 'b0;
                stage1[63:0] <= 'b0;
                stage2[39:0] <= 'b0;
                stage3[23:0] <= 'b0;
                stage4[13:0] <= 'b0;
                out_data <= 'b0;
              end else begin
                    stage0 <= in_data;
                    /* simple method */
					stage1[3:0] <= stage0[7] + stage0[6] + stage0[5] + stage0[4] + stage0[3] + stage0[2] + stage0[1] + stage0[0] ;
					stage1[7:4] <= stage0[15] + stage0[14] + stage0[13] + stage0[12] + stage0[11] + stage0[10] + stage0[9] + stage0[8] ;
					stage1[11:8] <= stage0[23] + stage0[22] + stage0[21] + stage0[20] + stage0[19] + stage0[18] + stage0[17] + stage0[16] ;
					stage1[15:12] <= stage0[31] + stage0[30] + stage0[29] + stage0[28] + stage0[27] + stage0[26] + stage0[25] + stage0[24] ;
					stage1[19:16] <= stage0[39] + stage0[38] + stage0[37] + stage0[36] + stage0[35] + stage0[34] + stage0[33] + stage0[32] ;
					stage1[23:20] <= stage0[47] + stage0[46] + stage0[45] + stage0[44] + stage0[43] + stage0[42] + stage0[41] + stage0[40] ;
					stage1[27:24] <= stage0[55] + stage0[54] + stage0[53] + stage0[52] + stage0[51] + stage0[50] + stage0[49] + stage0[48] ;
					stage1[31:28] <= stage0[63] + stage0[62] + stage0[61] + stage0[60] + stage0[59] + stage0[58] + stage0[57] + stage0[56] ;
					stage1[35:32] <= stage0[71] + stage0[70] + stage0[69] + stage0[68] + stage0[67] + stage0[66] + stage0[65] + stage0[64] ;
					stage1[39:36] <= stage0[79] + stage0[78] + stage0[77] + stage0[76] + stage0[75] + stage0[74] + stage0[73] + stage0[72] ;
					stage1[43:40] <= stage0[87] + stage0[86] + stage0[85] + stage0[84] + stage0[83] + stage0[82] + stage0[81] + stage0[80] ;
					stage1[47:44] <= stage0[95] + stage0[94] + stage0[93] + stage0[92] + stage0[91] + stage0[90] + stage0[89] + stage0[88] ;
					stage1[51:48] <= stage0[103] + stage0[102] + stage0[101] + stage0[100] + stage0[99] + stage0[98] + stage0[97] + stage0[96] ;
					stage1[55:52] <= stage0[111] + stage0[110] + stage0[109] + stage0[108] + stage0[107] + stage0[106] + stage0[105] + stage0[104] ;
					stage1[59:56] <= stage0[119] + stage0[118] + stage0[117] + stage0[116] + stage0[115] + stage0[114] + stage0[113] + stage0[112] ;
					stage1[63:60] <= stage0[127] + stage0[126] + stage0[125] + stage0[124] + stage0[123] + stage0[122] + stage0[121] + stage0[120] ;

					stage2[4:0] <= stage1[7 : 4] + stage1[3 : 0] ;
					stage2[9:5] <= stage1[15 : 12] + stage1[11 : 8] ;
					stage2[14:10] <= stage1[23 : 20] + stage1[19 : 16] ;
					stage2[19:15] <= stage1[31 : 28] + stage1[27 : 24] ;
					stage2[24:20] <= stage1[39 : 36] + stage1[35 : 32] ;
					stage2[29:25] <= stage1[47 : 44] + stage1[43 : 40] ;
					stage2[34:30] <= stage1[55 : 52] + stage1[51 : 48] ;
					stage2[39:35] <= stage1[63 : 60] + stage1[59 : 56] ;					

					stage3[5:0] <= stage2[9 : 5] + stage2[4 : 0] ;
					stage3[11:6] <= stage2[19 : 15] + stage2[14 : 10] ;
					stage3[17:12] <= stage2[29 : 25] + stage2[24 : 20] ;
					stage3[23:18] <= stage2[39 : 35] + stage2[34 : 30] ;
					
					stage4[6:0] <= stage3[11:6] + stage3[5:0];
					stage4[13:7] <= stage3[23:18] + stage3[17:12]; // stage4 for 128 bits
										
                    out_data <= stage4[6:0] + stage4[13:7];
              end // end if reset
            end // end always		
        end
    endgenerate
endmodule

module snap_handshake_clock_crosser
#(
    parameter DATA_WIDTH = 8,
    parameter DATA_TO_CTRL_SYNC_DEPTH = 2,
    parameter CTRL_TO_DATA_SYNC_DEPTH = 2
)
(
    input                       reset,
    input                       clr,
    input                       ctrl_clk,
    input                       data_clk,
    input                       snap,
    input      [DATA_WIDTH-1:0] din,
    output reg [DATA_WIDTH-1:0] dout /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=D101" */,
    output                      valid
);

    // Data is guaranteed valid by control signal clock crossing
    // Cut false path between counter and snapped registers

    wire snap_ctrl;
    wire snap_data;
    wire snap_toggle_ctrl_fwd;
    wire snap_toggle_ctrl_rvs;
    wire snap_toggle_data_fwd;
    wire snap_toggle_data_rvs;
    wire snap_ok;

    wire clr_ctrl;
    wire clr_toggle;
    wire clr_sync_toggle;
    wire clr_ok;

    reg clr_reg;
    reg clr_rvs_1st_reg;
    reg clr_rvs_2nd_reg;
    wire reset_counter;

    generate
        if ( (DATA_TO_CTRL_SYNC_DEPTH==0) && (CTRL_TO_DATA_SYNC_DEPTH==0) ) begin
            assign snap_data = snap;
            assign valid = 1'b1;
            assign reset_counter = reset | clr;
        end else begin
            // Prevent back-to-back snap and clr, make them self-clearing
            assign snap_ctrl = snap & valid;
            assign clr_ctrl = clr & valid;
            assign snap_ok = snap_toggle_ctrl_fwd ~^ snap_toggle_ctrl_rvs;
            assign clr_ok = clr_toggle ~^ clr_sync_toggle;
            assign valid = snap_ok & clr_ok;

            pulse_to_toggle p2t_ctrl
            (
                .reset   (reset),
                .clock   (ctrl_clk),
                .in      (snap_ctrl),
                .out     (snap_toggle_ctrl_fwd)
            );

            altera_std_synchronizer
            #(
                .depth   (CTRL_TO_DATA_SYNC_DEPTH)
            ) ctrl_to_data_synchronizer (
                .reset_n (~reset),
                .clk     (data_clk),
                .din     (snap_toggle_ctrl_fwd),
                .dout    (snap_toggle_data_fwd)
            );

            toggle_to_pulse t2p_data
            (
                .reset   (reset),
                .clock   (data_clk),
                .in      (snap_toggle_data_fwd),
                .out     (snap_data)
            );

            pulse_to_toggle p2t_data
            (
                .reset   (reset),
                .clock   (data_clk),
                .in      (snap_data),
                .out     (snap_toggle_data_rvs)
            );

            altera_std_synchronizer
            #(
                .depth   (DATA_TO_CTRL_SYNC_DEPTH)
            ) data_to_ctrl_synchronizer (
                .reset_n (~reset),
                .clk     (ctrl_clk),
                .din     (snap_toggle_data_rvs),
                .dout    (snap_toggle_ctrl_rvs)
            );

            // Reset and clear should asynchronously clear the dout
            // registers without depending on data_clk

            // Synchronize the clr signal to clr_reg to feed async clear port
            // Synchronize the clr_reg signal with 2 stages of registers to indicate
            // the registers are cleared and ready to be read in ctrl_clk domain
            always @ (posedge ctrl_clk or posedge reset) begin
                if (reset) begin
                    clr_reg <= 1'b0;
                    clr_rvs_1st_reg <= 1'b0;
                    clr_rvs_2nd_reg <= 1'b0;
                end else begin
                    clr_reg <= clr_ctrl;
                    clr_rvs_1st_reg <= clr_reg;
                    clr_rvs_2nd_reg <= clr_rvs_1st_reg;
                end
            end

            pulse_to_toggle p2t_clr
            (
                .reset   (reset),
                .clock   (ctrl_clk),
                .in      (clr_ctrl),
                .out     (clr_toggle)
            );

            pulse_to_toggle p2t_clr_sync
            (
                .reset   (reset),
                .clock   (ctrl_clk),
                .in      (clr_rvs_2nd_reg),
                .out     (clr_sync_toggle)
            );

            // clr_reg is synchronous to ctrl_clk but is asynchronous to data_clk
            altera_reset_controller
            #(
                .NUM_RESET_INPUTS        (2),
                .OUTPUT_RESET_SYNC_EDGES ("deassert"),
                .SYNC_DEPTH              (CTRL_TO_DATA_SYNC_DEPTH)
            ) reset_controller (
                .clk        (data_clk),
                .reset_in0  (reset),
                .reset_in1  (clr_reg),
                .reset_in2  (),
                .reset_in3  (),
                .reset_in4  (),
                .reset_in5  (),
                .reset_in6  (),
                .reset_in7  (),
                .reset_in8  (),
                .reset_in9  (),
                .reset_in10 (),
                .reset_in11 (),
                .reset_in12 (),
                .reset_in13 (),
                .reset_in14 (),
                .reset_in15 (),
                .reset_out  (reset_counter)
            );

        end
    endgenerate

    always @(posedge data_clk or posedge reset_counter) begin
      if (reset_counter) begin
          dout <= 'b0;
      end else begin
          if (snap_data) begin
              dout <= din;
          end
      end
    end

endmodule

module pulse_to_toggle
(
    input      reset,
    input      clock,
    input      in,
    output reg out
);
    always @(posedge clock or posedge reset) begin
      if (reset) begin
          out <= 'b0;
      end else begin
          if (in) begin
              out <= ~out;
          end
      end
    end
endmodule

module toggle_to_pulse
(
    input      reset,
    input      clock,
    input      in,
    output     out
);
    reg in_reg = 'b0;

    assign out = in ^ in_reg;

    always @(posedge clock or posedge reset) begin
      if (reset) begin
          in_reg <= 'b0;
      end else begin
          in_reg <= in;
      end
    end

endmodule

module bypass_port
#(
    parameter DATA_W = 40
)
(
    input                       asi_clk,
    input [DATA_W-1 : 0]        asi_data,
    input                       asi_valid,
    output reg                  asi_ready,
    
    //Avalon-ST souce
    output                      aso_clk,
    output reg [DATA_W-1 :0]    aso_data,  
    output reg                  aso_valid,
    input                       aso_ready
);
    assign aso_clk = asi_clk;
    always @(posedge aso_clk) begin
        aso_data <= asi_data;
        aso_valid <= asi_valid;
        asi_ready <= aso_ready;    
    end 
endmodule
