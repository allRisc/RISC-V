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

import memory_controller_pkg::*;

module memory_controller (
  // Clock reset
  input  wire         clk_in,
  input  wire         rst_low_in,

  // Memory Interface
  input  logic [31:0] addr_in,
  input  logic [31:0] wr_data_in,
  output logic [31:0] rd_data_out,
  input  logic        we_in,

  // External IO
  input  logic [15:0] sw_in,
  output logic [15:0] led_out,
  output logic [31:0] sseg_data_out
);

  logic [15:0] sw_r;
  logic [15:0] led_r;
  logic [31:0] sseg_data_r;

  logic [31:0] instr_data;

  initial begin
    $display(INSTRUCTION_BASE_ADDR);
    $display(SCRATCH_RAM_BASE_ADDR);
    $display(SWITCH_BASE_ADDR);
    $display(LED_BASE_ADDR);
    $display(SSEG_BASE_ADDR);
  end


  // Read logic
  always_ff @(posedge clk_in, negedge rst_low_in) begin
    if (!rst_low_in) begin
      rd_data_out <= '0;
    end
    else begin
      if (addr_in >= INSTRUCTION_BASE_ADDR && addr_in < SCRATCH_RAM_BASE_ADDR) begin
        rd_data_out <= instr_data;
      end
      else if (addr_in >= SCRATCH_RAM_BASE_ADDR && addr_in < SWITCH_BASE_ADDR) begin
        rd_data_out <= addr_in;
      end
      else if (addr_in == SWITCH_BASE_ADDR) begin
        rd_data_out <= sw_r;
      end
      else if (addr_in == LED_BASE_ADDR) begin
        rd_data_out <= led_r;
      end
      else if (addr_in == SSEG_BASE_ADDR) begin
        rd_data_out <= sseg_data_r;
      end
      else begin
        rd_data_out <= '0;
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
      if (we_in) begin
        case (addr_in)
          LED_BASE_ADDR  : led_r <= wr_data_in[15:0];
          SSEG_BASE_ADDR : sseg_data_r <= wr_data_in; 
        endcase
      end
    end
  end

  assign led_out = led_r;
  assign sseg_data_out = sseg_data_r;

  // Instruction ROM
  instr_rom #(
    .ROM_FILE_NAME("../src/rtl/memory_controller/instr_rom.mem")
  ) instr_rom_inst (
    .clk_in   (clk_in),
    .addr_in  (addr_in[INSTRUCTION_ADDR_WIDTH-1:0]),
    .instr_out(instr_data)
  );

endmodule