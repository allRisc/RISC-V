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

module asynch_fifo #(
  parameter DEPTH = 8,
  parameter WIDTH = 8
) (
  input logic dst_clk_in,
  input logic src_clk_in,
  input logic rst_low_in,

  input  logic [WIDTH-1:0] src_data_in,
  input  logic             src_data_valid_in,
  output logic             src_fifo_ready_out,

  output logic [WIDTH-1:0] dst_data_out,
  output logic             dst_data_valid_out,
  input  logic             dst_ready_in
);

  localparam DEPTH_WIDTH = $clog2(DEPTH);

  logic [WIDTH-1:0] data_r [DEPTH-1:0];

  logic [DEPTH_WIDTH:0] n_wraddr;
  logic [DEPTH_WIDTH:0] wraddr_r;
  logic [DEPTH_WIDTH:0] wraddr_gray_r;
  logic [DEPTH_WIDTH:0] wraddr_gray_synch_r;
  logic [DEPTH_WIDTH:0] wraddr_gray_synch_rr;
  logic [DEPTH_WIDTH:0] n_rdaddr;
  logic [DEPTH_WIDTH:0] rdaddr_r;
  logic [DEPTH_WIDTH:0] rdaddr_gray_r;
  logic [DEPTH_WIDTH:0] rdaddr_gray_synch_r;
  logic [DEPTH_WIDTH:0] rdaddr_gray_synch_rr;

  logic fifo_full;
  
  // Write Address logic
  assign n_wraddr = wraddr_r + 1;

  always_ff @(posedge src_clk_in, negedge rst_low_in) begin
    if (!rst_low_in) begin
      wraddr_r <= '0;
      wraddr_gray_r <= '0;
    end
    else begin
      if (!fifo_full) begin
        if (src_data_valid_in) begin
          wraddr_r <= n_wraddr;
          wraddr_gray_r <= (n_wraddr >> 1) ^ n_wraddr;
        end
      end
    end
  end

  // CDC from src to dst
  always_ff @(posedge dst_clk_in, negedge rst_low_in) begin
    if (!rst_low_in) begin
      wraddr_gray_synch_r <= '0;
      wraddr_gray_synch_rr <= '0;
    end
    else begin
      wraddr_gray_synch_r <= wraddr_gray_r;
      wraddr_gray_synch_rr <= wraddr_gray_synch_r;
    end
  end

  // Read Address logic
  assign n_rdaddr = rdaddr_r + 1;

  always_ff @(posedge dst_clk_in, negedge rst_low_in) begin
    if (!rst_low_in) begin
      rdaddr_r <= '0;
      rdaddr_gray_r <= '0;
    end
    else begin
      if (!fifo_empty) begin
        if (dst_ready_in) begin
          rdaddr_r <= n_rdaddr;
          rdaddr_gray_r <= (n_rdaddr >> 1) ^ n_rdaddr;
        end
      end
    end
  end

  // CDC from dst to src
  always_ff @(posedge src_clk_in, negedge rst_low_in) begin
    if (!rst_low_in) begin
      rdaddr_gray_synch_r <= '0;
      rdaddr_gray_synch_rr <= '0;
    end
    else begin
      rdaddr_gray_synch_r <= rdaddr_gray_r;
      rdaddr_gray_synch_rr <= rdaddr_gray_synch_r;
    end
  end

  // Read and Write Logic
  always_ff @(posedge src_clk_in, negedge rst_low_in) begin
    if (!rst_low_in) begin
      data_r <= '{ DEPTH{'0}};
    end
    else begin
      if (src_data_valid_in && !fifo_full) begin
        data_r[wraddr_r[DEPTH_WIDTH-1:0]] <= src_data_in;
      end
    end
  end

  always_comb begin
    dst_data_out = data_r[rdaddr_r[DEPTH_WIDTH-1:0]];
  end

  assign fifo_full = ((wraddr_gray_r[DEPTH_WIDTH] != rdaddr_gray_synch_rr[DEPTH_WIDTH]) && 
                      (wraddr_gray_r[DEPTH_WIDTH-1:0] == rdaddr_gray_synch_rr[DEPTH_WIDTH-1:0]));
  assign fifo_empty = (wraddr_gray_synch_rr == rdaddr_gray_r);

  assign dst_data_valid_out = !fifo_empty;
  assign src_fifo_ready_out = !fifo_full;

endmodule