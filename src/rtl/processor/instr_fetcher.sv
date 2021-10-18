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
import risc_v_isa_pkg::*;

module instr_fetcher (
  // Clock and reset
  input logic clk_in,
  input logic rst_low_in,

  // Instruction ROM Interface
  output logic [INSTRUCTION_ADDR_WIDTH-1:0] instr_addr_out,
  input  logic [                      31:0] instr_in,

  // Interface to rest of processor
  input logic [INSTRUCTION_ADDR_WIDTH-1:0] pc_in,
  input logic                              set_pc_in,

  // Fetched instruction
  output logic [INSTRUCTION_ADDR_WIDTH-1:0] instr_pc_out,
  output instr_u                            instr_out,
  output logic                              instr_valid_out
);

  ////////////////////////////////////////////////////////
  // Signal definitions
  ////////////////////////////////////////////////////////
  logic [INSTRUCTION_ADDR_WIDTH-1:0] pc_r;

  ////////////////////////////////////////////////////////
  // Port Assignments
  ////////////////////////////////////////////////////////
  assign instr_addr_out = pc_r;
  assign instr_out.inst = instr_in;

  ////////////////////////////////////////////////////////
  // Instruction fetcher control logic
  ////////////////////////////////////////////////////////
  always_ff @(posedge clk_in, negedge rst_low_in) begin
    if (!rst_low_in) begin
      pc_r <= '0;

      instr_valid_out <= '0;
      instr_out.inst  <= '0;
      instr_pc_out    <= '0;
    end
    else begin
      // A command from the rest of the processor to set PC
      if (set_pc_in) begin
        instr_valid_out <= '0;
        pc_r <= pc_in;
      end
      // Else output the next instruction and increment the PC
      else begin
        pc_r <= pc_r + DATA_BYTES;

        instr_pc_out    <= pc_r;
        instr_valid_out <= '1;
      end
    end
  end

endmodule