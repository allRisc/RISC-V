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

package memory_controller_pkg
  
  localparam ADDR_WIDTH = 32;
  localparam DATA_WIDTH = 32;
  localparam WORD_ALIGN = $clog2(DATA_WIDTH / 8);

  localparam INSTRUCTION_BASE_ADDR = 32'h00000000;
  localparam SCRATCH_RAM_BASE_ADDR = 32'h00001000;
  localparam      SWITCH_BASE_ADDR = 32'h00001004;
  localparam         LED_BASE_ADDR = 32'h00001008;
  localparam        SSEG_BASE_ADDR = 32'h0000100C;

endpackage