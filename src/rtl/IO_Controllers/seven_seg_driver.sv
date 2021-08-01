`timescale 1ns / 1ps

module seven_seg_driver #(
  parameter ANODES = 8,            // THe number of anodes in the sseg array
  parameter WIDTH  = ANODES * 4,
  parameter CLK_PERIOD = 10,       // The clock period in nano-seconds
  parameter REFRESH_RATE = 100     // The desired refresh rate in Hz
)(
  input  wire              clk_in,
  input  wire              rst_low_in,
  input  wire [WIDTH-1:0]  data_in,
  output reg  [6:0]        segments_out,
  output reg               dp_out,
  output reg  [ANODES-1:0] an_out
);

   
  /* Local Parameter Definitions */

  // Definitions for segments patterns for a given nibble/number
  // The cathode indices are A=0 through G=6 
  //  (i.e. A is the LSB (right) and G is the MSB (left)
  localparam NIBBLE_0 = ~7'b0111111; // Segments ABCDEF
  localparam NIBBLE_1 = ~7'b0000110; // Segments BC
  localparam NIBBLE_2 = ~7'b1011011; // Segments ABDEG
  localparam NIBBLE_3 = ~7'b1001111; // Segments ABCDG
  localparam NIBBLE_4 = ~7'b1100110; // Segments BCFG
  localparam NIBBLE_5 = ~7'b1101101; // Segments ACDFG
  localparam NIBBLE_6 = ~7'b1111101; // Segments ACDEFG
  localparam NIBBLE_7 = ~7'b0000111; // Segments ABC
  localparam NIBBLE_8 = ~7'b1111111; // Segments ABCDEFG
  localparam NIBBLE_9 = ~7'b1101111; // Segments ABCDFG
  localparam NIBBLE_A = ~7'b1110111; // Segments ABCEFG
  localparam NIBBLE_B = ~7'b1111100; // Segments CDEFG
  localparam NIBBLE_C = ~7'b0111001; // Segments ADEF
  localparam NIBBLE_D = ~7'b1011110; // Segments BCDEG
  localparam NIBBLE_E = ~7'b1111001; // Segments ADEFG
  localparam NIBBLE_F = ~7'b1110001; // Segments AEFG
  localparam NIBBLE_INVALID = ~7'b1000000; // Segment G

  // Definitions for the clock divider circuit
  localparam REFRESH_PERIOD = 1000000000 / REFRESH_RATE; // The period of the refresh in nano-seconds
  localparam ANODE_PERIOD   = REFRESH_PERIOD / ANODES;   // The period each anode will be refreshed
  localparam ANODE_CLKS     = ANODE_PERIOD / CLK_PERIOD; // The number of clock cycles per anode period

  /* Signal Definitions */
  
  logic [$clog2(ANODES):0]     anode_index;
  logic [$clog2(ANODE_CLKS):0] clk_count;
  
  /* Logic */

  // Control Logic Circuit
  always_ff @(posedge clk_in, negedge rst_low_in) begin
    if (rst_low_in == '0) begin
      segments_out <= NIBBLE_INVALID;
      dp_out <= '0;
      an_out <= '0;
      
      anode_index <= '0;
      clk_count <= '0;
    end
    else begin
      case (data_in[4*anode_index +: 4]) 
        4'h0 : segments_out <= NIBBLE_0;
        4'h1 : segments_out <= NIBBLE_1;
        4'h2 : segments_out <= NIBBLE_2;
        4'h3 : segments_out <= NIBBLE_3;
        4'h4 : segments_out <= NIBBLE_4;
        4'h5 : segments_out <= NIBBLE_5;
        4'h6 : segments_out <= NIBBLE_6;
        4'h7 : segments_out <= NIBBLE_7;
        4'h8 : segments_out <= NIBBLE_8;
        4'h9 : segments_out <= NIBBLE_9;
        4'hA : segments_out <= NIBBLE_A;
        4'hB : segments_out <= NIBBLE_B;
        4'hC : segments_out <= NIBBLE_C;
        4'hD : segments_out <= NIBBLE_D;
        4'hE : segments_out <= NIBBLE_E;
        4'hF : segments_out <= NIBBLE_F;
        default : segments_out <= 7'b1010101;
      endcase
      
      dp_out <= '0;
      
      an_out <= '1;
      an_out[anode_index] <= 1'b0;
      
      // Handle the refresh rate
      if (clk_count < ANODE_CLKS - 1) begin
        clk_count <= clk_count + 1;
      end
      else begin
        clk_count <= '0;
        if (anode_index < ANODES - 1) begin
          anode_index <= anode_index + 1;
        end
        else begin
          anode_index <= '0;
        end        
      end
      
    end
  end

endmodule
