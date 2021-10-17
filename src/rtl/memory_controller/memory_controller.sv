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

import memory_controller_pkg::*

module memory_controller (
  // Clock reset
  input  wire         clk_in,
  input  wire         rst_low_in,

  // Memory Interface
  input  logic [31:0] addr_in,
  input  logic [31:0] wr_data_in,
  output logic [31:0] rd_data_out,
  input  logic        we_in

  // External IO
  input  logic [16:0] sw_in,
  output logic 
);

endmodule