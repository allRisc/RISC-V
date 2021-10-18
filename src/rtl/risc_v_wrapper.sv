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

import memory_system_pkg::*;

module risc_v_wrapper (
  // Clock and reset signals
  input wire clk_100_in,
  input wire ext_rst_low_in,

  // Generic IO Signals
  input  wire [15:0] sw_in,
  output wire [15:0] led_out,
  output wire [ 6:0] sseg_out,
  output wire        dp_out,
  output wire [ 7:0] an_out
);

  ////////////////////////////////////////////////////////
  // Signal definitions
  ////////////////////////////////////////////////////////
  logic sys_rst_low;
  logic sys_clk;
  logic slow_clk;

  // RAM Interface Signals
  logic [31:0] mem_addr;
  logic [31:0] mem_wr_data;
  logic [31:0] mem_rd_data;
  logic        mem_we;

  // Instruction ROM Signals
  logic [INSTRUCTION_ADDR_WIDTH-1:0] instr_addr;
  logic [                      31:0] instr_data;

  // Misc signals
  logic [31:0] sseg_data;

  ////////////////////////////////////////////////////////
  // Clock reset controller
  ////////////////////////////////////////////////////////
  clk_rst #(
    .INPUT_FREQ    (100.0),
    .CLK_OUT_0_FREQ(200.0),
    .CLK_OUT_1_DIV ( 10  )
  ) clk_rst_inst (
    // Inputs
    .clk_in          (clk_100_in),     // Clock in
    .ext_rst_low_in  (ext_rst_low_in), // Active low reset
    .clk_0_out       (sys_clk),
    .clk_1_out       (slow_clk),
    .var_clk_out     (),
    .sys_rst_low_out (sys_rst_low),
    .var_clk_div_in  ('0)
  );

  ////////////////////////////////////////////////////////
  // Memory Controller
  ////////////////////////////////////////////////////////
  memory_system mem_sys_inst (
    .clk_in     (sys_clk),
    .rst_low_in (sys_rst_low),
    
    .data_addr_in (mem_addr),
    .data_wr_in   (mem_wr_data),
    .data_rd_out  (mem_rd_data),
    .data_we_in   (mem_we),
    
    .instr_addr_in (instr_addr),
    .instr_out     (instr_data),

    .sw_in        (sw_in),
    .led_out      (led_out),
    .sseg_data_out(sseg_data)
  );

  ////////////////////////////////////////////////////////
  // Seven Segment Display Driver
  ////////////////////////////////////////////////////////
  seven_seg_driver #(
    .CLK_PERIOD   (5),
    .REFRESH_RATE (100)
  ) sseg_disp_inst (
    .clk_in       (sys_clk),
    .rst_low_in   (sys_rst_low),

    .data_in      (sseg_data),
    .segments_out (sseg_out),
    .dp_out       (dp_out),
    .an_out       (an_out)
  );

  ////////////////////////////////////////////////////////
  // RISC-V CPU
  ////////////////////////////////////////////////////////
  risc_v_cpu cpu_inst (
    .clk_in    (sys_clk),
    .rst_low_in(sys_rst_low),

    .mem_addr_out    (mem_addr),
    .mem_wr_data_out (mem_wr_data),
    .mem_rd_data_in  (mem_rd_data),
    .mem_we_out      (mem_we),

    .instr_addr_out (instr_addr),
    .instr_in       (instr_data)
  );

  ////////////////////////////////////////////////////////
  // Misc Output Assignments
  ////////////////////////////////////////////////////////
  assign an_out = '0;
  assign dp_out = '0;
  assign sseg_out = '0;

endmodule