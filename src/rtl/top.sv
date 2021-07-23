/***************************************************************************
 * Source File for Personal Implementation of RISC-V Processor             *
 * Copyright (C) 2021  Benjamin J Davis                                    *
 *                                                                         *
 * This program is free software: you can redistribute it and/or modify    *
 * it under the terms of the GNU General Public License as published by    *
 * the Free Software Foundation, either version 3 of the License, or       *
 * (at your option) any later version.                                     *
 *                                                                         *
 * This program is distributed in the hope that it will be useful,         *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 * GNU General Public License for more details.                            *
 *                                                                         *
 * You should have received a copy of the GNU General Public License       *
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.  *
 ***************************************************************************/

module top (
  input  wire       clk_100_in,
  input  wire [0:7] sw,
  output reg  [0:7] led
);

  wire sys_clk;

  nexys7_clock clk_manager (
    .clk_in1         (clk_100_in),
    .reset           ('0),
    .locked          (),
    .sys_clk_450_out (sys_clk)
  );

  always_ff @(posedge sys_clk) begin
    led <= sw;
  end
   
endmodule