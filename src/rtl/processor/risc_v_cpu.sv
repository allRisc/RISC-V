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

import risc_v_isa_pkg::*;
import memory_system_pkg::*;

module risc_v_cpu (
  // Clock and reset
  input logic clk_in,
  input logic rst_low_in,

  // Memory Controller Interface
  output logic [31:0] mem_addr_out,
  output logic [31:0] mem_wr_data_out,
  input  logic [31:0] mem_rd_data_in,
  output logic        mem_we_out,

  // Instruction ROM Interface
  output logic [INSTRUCTION_ADDR_WIDTH-1:0] instr_addr_out,
  input  logic [                      31:0] instr_in
);

  ////////////////////////////////////////////////////////////
  // Instruction Fetcher
  ////////////////////////////////////////////////////////////
  logic         instr_fetch_valid;
  instr_u       instr_fetch;
  logic  [11:0] instr_fetch_pc;

  ////////////////////////////////////////////////////////////
  // Instruction Fetcher
  ////////////////////////////////////////////////////////////
  instr_fetcher instr_fetch_inst (
    .clk_in     (clk_in),
    .rst_low_in (rst_low_in),

    .instr_addr_out (instr_addr_out),
    .instr_in       (instr_in),

    .pc_in     ('0),
    .set_pc_in ('0),

    .instr_pc_out    (instr_fetch_pc),
    .instr_out       (instr_fetch),
    .instr_valid_out (instr_fetch_valid)
  );

  ////////////////////////////////////////////////////////////
  // Decoder
  ////////////////////////////////////////////////////////////
  instr_decoder instr_decoder_inst (
    .clk_in     (clk_in),
    .rst_low_in (rst_low_in),

    .instr_valid_in (instr_fetch_valid),
    .raw_instr_in   (instr_fetch),
    .instr_pc_in    (instr_fetch_pc),

    .dec_instr_out  (),
    .instr_pc_out   ()
  );


  ////////////////////////////////////////////////////////////
  // Register Files
  ////////////////////////////////////////////////////////////
  register_file reg_file_inst (
    .clk_in     (clk_in),
    .rst_low_in (rst_low_in),

    .src1_idx_in   ('0),
    .src1_data_out (),

    .src2_idx_in   ('0),
    .src2_data_out (),

    .dst_idx_in  ('0),
    .dst_data_in ('0),
    .dst_en_in   ('0)
  );

  ////////////////////////////////////////////////////////////
  // ALU
  ////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////
  // Memory Manager
  ////////////////////////////////////////////////////////////


endmodule