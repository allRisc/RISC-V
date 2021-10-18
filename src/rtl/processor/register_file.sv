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

module register_file(
  // Clock and reset
  input logic clk_in,
  input logic rst_low_in,
  
  // RS1 Interface
  input  logic [ 4:0] src1_idx_in,
  output logic [31:0] src1_data_out,

  // RS2 Interface
  input  logic [ 4:0] src2_idx_in,
  output logic [31:0] src2_data_out,

  // RD Interface
  input  logic [ 4:0] dst_idx_in,
  input  logic [31:0] dst_data_in,
  input  logic        dst_en_in
);

  ////////////////////////////////////////////////////////
  // Signal Definitions
  ////////////////////////////////////////////////////////
  logic [31:0][31:0] reg_r;

  ////////////////////////////////////////////////////////
  // Register control
  ////////////////////////////////////////////////////////
  always_ff @(posedge clk_in, negedge rst_low_in) begin
    if (!rst_low_in) begin
      reg_r <= {32{'0}};
    end
    else begin
      if (dst_en_in && (dst_idx_in != 5'h00)) begin
        reg_r[dst_idx_in] <= dst_data_in;
      end
    end
  end

  ////////////////////////////////////////////////////////
  // Reg Source 1 Output
  ////////////////////////////////////////////////////////
  assign src1_data_out = reg_r[src1_idx_in];

  ////////////////////////////////////////////////////////
  // Reg Source 2 Output
  ////////////////////////////////////////////////////////
  assign src2_data_out = reg_r[src2_idx_in];

endmodule