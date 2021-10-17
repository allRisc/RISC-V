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

import memory_controller_pkg::*;

module risc_v_cpu (
  // Clock and reset
  input logic clk_in,
  input logic rst_low_in,

  // Memory Controller Interface
  output logic [31:0] addr_out,
  output logic [31:0] wr_data_out,
  input  logic [31:0] rd_data_in,
  output logic        we_out
);

  typedef enum { 
    INIT      ,
    SW_FETCH  ,
    SW_STORE  ,
    INST_FETCH,
    INST_STORE,
    LED_PUSH  
  } fsmState_e;

  fsmState_e  state_r;
  logic[15:0] sw_data_r;
  logic[15:0] led_data_r;
  logic[31:0] instr_data_r;

  // For now just get the switch value.
  // Then read the corresponding instruction
  // And output the lower 2 bytes of ths instruction to the LEDs
  always_ff @(posedge clk_in, negedge rst_low_in) begin
    if (!rst_low_in) begin
      state_r <= INIT;

      sw_data_r    <= '0;
      led_data_r   <= '0;
      instr_data_r <= '0;

      we_out <= '0;
      addr_out <= '0;
      wr_data_out <= '0;
    end
    else begin
      wr_data_out <= '0;
      we_out      <= '0;

      case (state_r)
        INIT : begin
            state_r <= SW_FETCH;
          end
        SW_FETCH : begin
            addr_out <= SWITCH_BASE_ADDR;
            
            state_r <= SW_STORE;
          end
        SW_STORE : begin
            sw_data_r <= rd_data_in[15:0];
            
            state_r <= INST_FETCH;
          end
        INST_FETCH : begin
            addr_out <= {16'h0000, sw_data_r};
            
            state_r <= INST_STORE;
          end
        INST_STORE : begin
            instr_data_r <= rd_data_in;
            
            state_r <= LED_PUSH;
          end
        LED_PUSH : begin
            addr_out    <= LED_BASE_ADDR;
            wr_data_out <= instr_data_r[15:0];
            we_out      <= '1;
            
            state_r <= SW_FETCH;
          end
        default: begin
            state_r <= INIT;
          end
      endcase
    end
  end

endmodule