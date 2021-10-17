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

module clk_divider #(
  parameter MAX_DIVIDER = 10
) (
  input  logic clk_in,
  input  logic rst_low_in,

  input  logic [$clog2(MAX_DIVIDER)-1:0] div_in,

  output logic div_clk_out
);

  logic [$clog2(MAX_DIVIDER)-1:0] pos_cnt_r;
  logic [$clog2(MAX_DIVIDER)-1:0] neg_cnt_r;

  always_ff @(posedge clk_in, negedge rst_low_in) begin
    if (!rst_low_in) begin
      pos_cnt_r <= '0;
    end
    else begin
      if (pos_cnt_r >= div_in - 1)
        pos_cnt_r <= '0;
      else 
        pos_cnt_r <= pos_cnt_r + 1;
    end
  end

  always_ff @(negedge clk_in, negedge rst_low_in) begin
    if (!rst_low_in) begin
      neg_cnt_r <= '0;
    end
    else begin
      neg_cnt_r <= pos_cnt_r;
    end
  end

  always_comb begin
    if (div_in[$clog2(MAX_DIVIDER)-1:1] == '0) begin
      div_clk_out = clk_in;
    end
    else if(!div_in[0]) begin
      div_clk_out = (pos_cnt_r >= (div_in >> 1));
    end
    else begin
      div_clk_out = (pos_cnt_r > (div_in >> 1)) | (neg_cnt_r > (div_in >> 1));
    end
  end

endmodule