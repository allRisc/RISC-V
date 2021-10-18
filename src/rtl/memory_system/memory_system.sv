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

module memory_system (
  // Clock reset
  input  wire         clk_in,
  input  wire         rst_low_in,

  // Data RAM Interface
  input  logic [31:0] data_addr_in,
  input  logic [31:0] data_wr_in,
  output logic [31:0] data_rd_out,
  input  logic        data_we_in,

  // Instruction ROM Interface
  input  logic [INSTRUCTION_ADDR_WIDTH-1:0] instr_addr_in,
  output logic [                      31:0] instr_out,

  // External IO
  input  logic [15:0] sw_in,
  output logic [15:0] led_out,
  output logic [31:0] sseg_data_out
);

  logic [15:0] sw_r;
  logic [15:0] led_r;
  logic [31:0] sseg_data_r;

  logic [31:0] instr_data;

  // Read logic
  always_ff @(posedge clk_in, negedge rst_low_in) begin
    if (!rst_low_in) begin
      data_rd_out <= '0;
    end
    else begin
      if (data_addr_in >= SCRATCH_RAM_BASE_ADDR && data_addr_in < SWITCH_BASE_ADDR) begin
        data_rd_out <= 'hDEADBEEF;
      end
      else if (data_addr_in == SWITCH_BASE_ADDR) begin
        data_rd_out <= {16'h0000, sw_r};
      end
      else if (data_addr_in == LED_BASE_ADDR) begin
        data_rd_out <= {16'h0000, led_r};
      end
      else if (data_addr_in == SSEG_BASE_ADDR) begin
        data_rd_out <= sseg_data_r;
      end
      else begin
        data_rd_out <= '0;
      end
    end
  end

  // Input Registering logic
  always_ff @(posedge clk_in, negedge rst_low_in) begin
    if (!rst_low_in) begin
      sw_r <= '0;
    end
    else begin
      sw_r <= sw_in;
    end
  end

  // Single Register Write control logic
  always_ff @(posedge clk_in, negedge rst_low_in) begin
    if (!rst_low_in) begin
      led_r       <= '0;
      sseg_data_r <= '0;
    end
    else begin
      if (data_we_in) begin
        case (data_addr_in)
          LED_BASE_ADDR  : led_r       <= data_wr_in[15:0];
          SSEG_BASE_ADDR : sseg_data_r <= data_wr_in; 
        endcase
      end
    end
  end

  assign led_out = led_r;
  assign sseg_data_out = sseg_data_r;

  // Instruction ROM
  instr_rom #(
    .ROM_FILE_NAME("../src/rtl/memory_system/instr_rom.mem")
  ) instr_rom_inst (
    .clk_in   (clk_in),
    .addr_in  (instr_addr_in),
    .instr_out(instr_out)
  );

endmodule