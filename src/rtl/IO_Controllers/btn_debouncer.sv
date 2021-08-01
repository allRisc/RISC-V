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

`timescale 1ns / 1ps

module btn_debouncer #(
  parameter DEBOUNCE_CLOCKS = 10  // The number of clock cycles to debounce the clock
) (
  input wire clk_in,
  input wire rst_low_in,
  input wire btn_in,
  output reg btn_out
);

  logic [$clog2(DEBOUNCE_CLOCKS):0] db_count;


  always_ff @(posedge clk_in, negedge rst_low_in) begin
    if (rst_low_in == '0) begin
      btn_out <= '0;

      db_count <= '0;
    end
    begin
      if (btn_out == btn_in) begin
        db_count <= '0;
      end
      else begin
        db_count <= db_count + 1;
        if (db_count >= DEBOUNCE_CLOCKS) begin
          btn_out <= btn_in;
        end
      end
    end
  end

endmodule
