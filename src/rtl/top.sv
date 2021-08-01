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
  input  wire [15:0] sw_in,
  output reg  [15:0] led_out,
  output reg  [6:0]  sseg_out,
  output reg         dp_out,
  output reg  [7:0]  an_out
);

  wire sys_clk;
  reg  [15:0] inter;

//  nexys7_clock clk_manager (
//    .clk_in1         (clk_100_in),
//    .reset           ('0),
//    .locked          (),
//    .sys_clk_450_out (sys_clk)
//  );

  always_ff @(posedge clk_100_in) begin
    inter <= sw_in;
    led_out <= inter;
  end
  
  seven_seg_driver #(
    .ANODES(4)
  ) sseg_drive (
    .clk_in       (clk_100_in),
    .rst_low_in   ('1),
    .data_in      (inter),
    .segments_out (sseg_out),
    .dp_out       (dp_out),
    .an_out       (an_out[3:0])
  ); 
  
  assign an_out[7:4] = '1;
   
endmodule