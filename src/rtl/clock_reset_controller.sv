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

/***************************************************************************
 * This block controls the clock-rst release. It follows the following 
 *  process:
 *  1. Wait for ext_rst_low to be stable high for EXT_RST_SETTLE_CLOCKS number
 *        of ext_clk cycles
 *  2. Release the internal clk_rst_low signal
 *  3. Wait for CLK_LOCK_RELEASE cycles after the PLL clock locks before 
 *        releasing a synchronized reset signal
 ***************************************************************************/

`timescale 1ns / 1ps

module clock_reset_controller(
  input  wire ext_clk_100_in,
  input  wire ext_rst_low_in,
  output wire sys_clk_out,
  output wire ddr_clk_out,
  output wire ddr_ref_clk_out,
  output reg  rst_low_out
);

  localparam EXT_RST_SETTLE_CLOCKS = 32; 
  localparam CLOCK_LOCK_RELEASE = 16;

  logic sys_clk;
  logic sys_clk_lock;
  logic clk_rst_low;

  logic [$clog2(EXT_RST_SETTLE_CLOCKS):0] ext_rst_cnt;
  logic [$clog2(CLOCK_LOCK_RELEASE):0] lock_cnt;

  nexys_a7_ddr_clock clk_mmcm (
    .ext_clk_100_in  (ext_clk_100_in),
    .resetn          (ext_rst_low_in),
    .sys_clk_out     (sys_clk),
    .ddr_clk_out     (ddr_clk_out),
    .ddr_ref_clk_out (ddr_ref_clk_out),
    .locked_out      (sys_clk_lock)
  );

  assign sys_clk_out = sys_clk;

  // Handle external reset synchronization
  always_ff @(posedge ext_clk_100_in, negedge ext_rst_low_in) begin
    if (ext_rst_low_in == '0) begin
      clk_rst_low = '0;
      ext_rst_cnt = '0;
    end
    else begin
      if (ext_rst_cnt != EXT_RST_SETTLE_CLOCKS-1) begin
        clk_rst_low <= '0;
        ext_rst_cnt <= ext_rst_cnt + 1;
      end
      else begin
        clk_rst_low <= '1;
      end
    end
  end

  // Handle the clock lock and internal synchronization
  always_ff @(posedge sys_clk, negedge clk_rst_low) begin
    if (clk_rst_low == '0) begin
      rst_low_out <= '0;
      lock_cnt <= '0;
    end
    else begin
      if (sys_clk_lock == '1) begin
        if (lock_cnt != CLOCK_LOCK_RELEASE-1) begin
          rst_low_out <= '0;
          lock_cnt <= lock_cnt + 1;
        end
        else begin
          rst_low_out <= '1;
        end
      end
      else begin
        rst_low_out <= '0;
        lock_cnt <= '0;
      end      
    end
  end

endmodule
