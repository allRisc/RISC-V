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

module risc_v_wrapper_sim ();

  logic clk_100;
  logic ext_rst;
  
  logic [15:0] switches;
  logic [15:0] leds;
  logic [ 6:0] sseg_segments;
  logic        sseg_dp;
  logic [ 7:0] sseg_an;

  initial begin
    clk_100  = '0;
    ext_rst  = '0;
    switches = '0;

    #20 ext_rst <= '1;
  end

  always begin
    #5 clk_100 <= ~clk_100;
  end

  always begin
    #50 switches <= switches + 1;
  end

  risc_v_wrapper risc_v_dut (
    .clk_100_in     (clk_100),
    .ext_rst_low_in (ext_rst),

    .sw_in    (switches),
    .led_out  (leds),
    .sseg_out (sseg_segments),
    .dp_out   (sseg_dp),
    .an_out   (sseg_an)
  );

endmodule