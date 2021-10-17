/**************************************************************************
 * Source File for Personal Implementation of RISC-V                      *
 * Copyright (C) 2021  Benjamin J Davis                                   *
 *                                                                        *
 * This program is free software: you can redistribute it and/or modify   *
 * it under the terms of the GNU General Public License as published by   *
 * the Free Software Foundation, either version 3 of the License, or      *
 * (at your option) any later version.                                    *
 *                                                                        *
 * This program is distributed in the hope that it will be useful,        *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of         *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          *
 * GNU General Public License for more details.                           *
 *                                                                        *
 * You should have received a copy of the GNU General Public License      *
 * along with this program.  If not, see <https://www.gnu.org/licenses/>. *
 **************************************************************************/

`timescale 1ns/1ps

module clk_rst #(
  parameter INPUT_FREQ     = 100.0,
  parameter CLK_OUT_0_FREQ = 200.0,
  parameter CLK_OUT_1_DIV  = 10
) (
  // Inputs
  input  wire clk_in,     // Clock in
  input  wire ext_rst_low_in, // Active low reset

  output wire clk_0_out,
  output wire clk_1_out,
  output wire var_clk_out,

  output logic sys_rst_low_out,

  input  logic [7:0] var_clk_div_in
);

  // Local Param Generation
  localparam PLL_MULT      = 10;
  localparam CLK_IN_PERIOD = 1000.0 / INPUT_FREQ;
  localparam CLK0_DIV      = (PLL_MULT * INPUT_FREQ) / CLK_OUT_0_FREQ;

  // Reset Control Definitions
  logic [5:0] locked_cnt_r;
  logic       sys_rst_low_r;

  // Clock Signal Defintions
  logic ext_rst_high;

  logic feedback_clk;
  logic locked;

  // IO Assignment
  assign ext_rst_high = !ext_rst_low_in;

  // PLL Defitions
  MMCME2_BASE #(
    .CLKFBOUT_MULT_F(PLL_MULT),
    .CLKIN1_PERIOD(CLK_IN_PERIOD),
    
    .CLKOUT0_DIVIDE_F(CLK0_DIV),
    .CLKOUT1_DIVIDE  (CLK_OUT_1_DIV)
  ) pll_inst (
    // Input Clocks
    .CLKIN1(clk_in),
    
    // Output Clocks
    .CLKOUT0(clk_0_out),
    .CLKOUT1(clk_1_out),

    // PLL Feedback
    .CLKFBOUT(feedback_clk),
    .CLKFBIN (feedback_clk),

    // Locked
    .LOCKED (locked),

    // PLL Reset
    .RST (ext_rst_high),

    // Constant
    .PWRDWN ('0)
  );

  // Reset controller
  assign sys_rst_low_out = sys_rst_low_r;

  always_ff @(posedge clk_0_out, negedge ext_rst_low_in) begin
    if (!ext_rst_low_in) begin
      locked_cnt_r  <= '0;
      sys_rst_low_r <= '0;
    end
    else begin
      if (!locked) begin
        locked_cnt_r <= '0;
        sys_rst_low_r <= '0;
      end
      else begin
        if (locked_cnt_r != '0) begin
          locked_cnt_r <= locked_cnt_r + 1;
          sys_rst_low_r <= '0;
        end
        else begin
          sys_rst_low_r <= '1;
        end
      end
    end
  end

  // Variable clock divider
  clk_divider #(
    .MAX_DIVIDER(200)
  ) clk_div_inst (
    .clk_in (clk_0_out),
    .rst_low_in(sys_rst_low_out),

    .div_in(var_clk_div_in),
    .div_clk_out(var_clk_out)
  );

endmodule
