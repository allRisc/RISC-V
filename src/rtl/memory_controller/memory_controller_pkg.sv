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

package memory_controller_pkg;
  
  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;
  parameter DATA_BYTES = DATA_WIDTH / 8;
  parameter WORD_ALIGN = $clog2(DATA_BYTES);

  parameter INSTRUCTION_BASE_ADDR  = 32'h00000000;
  parameter INSTRUCTION_ADDR_WIDTH = 12; // 4KB
  parameter INSTRUCTION_BLOCK_SIZE = 2**INSTRUCTION_ADDR_WIDTH;
  
  parameter SCRATCH_RAM_BASE_ADDR  = INSTRUCTION_BASE_ADDR + INSTRUCTION_BLOCK_SIZE;
  parameter SCRATCH_RAM_ADDR_WIDTH = 12; // 4KB
  parameter SCRATCH_RAM_BLOCK_SIZE = 2**SCRATCH_RAM_ADDR_WIDTH;
  
  parameter      SWITCH_BASE_ADDR  = SCRATCH_RAM_BASE_ADDR + SCRATCH_RAM_BLOCK_SIZE;
  parameter         LED_BASE_ADDR  = SWITCH_BASE_ADDR + DATA_BYTES;
  parameter        SSEG_BASE_ADDR  = LED_BASE_ADDR + DATA_BYTES;

endpackage