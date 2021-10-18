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

import risc_v_isa_pkg::*;

module instr_decoder (
  // Clock and reset
  input logic clk_in,
  input logic rst_low_in,

  // Instruction Inputs
  input logic          instr_valid_in,
  input instr_u        raw_instr_in,
  input logic   [11:0] instr_pc_in,

  // Decoded outputs
  output instrInfo_s        dec_instr_out,
  output logic       [11:0] instr_pc_out
);

  ////////////////////////////////////////////////////////
  // Signal Definitions
  ////////////////////////////////////////////////////////
  aluOp_e alu_op;

  instrType_e iType_r;
  instrCmd_u  iCmd_r;

  // Useful aliases
  rInstr_s r_instr_in;
  iInstr_s i_instr_in;
  sInstr_s s_instr_in;
  bInstr_s b_instr_in;
  uInstr_s u_instr_in;
  jInstr_s j_instr_in;

  assign r_instr_in = raw_instr_in.r_type;
  assign i_instr_in = raw_instr_in.i_type;
  assign s_instr_in = raw_instr_in.s_type;
  assign b_instr_in = raw_instr_in.b_type;
  assign u_instr_in = raw_instr_in.u_type;
  assign j_instr_in = raw_instr_in.j_type;

  ////////////////////////////////////////////////////////
  // Port assignments
  ////////////////////////////////////////////////////////
  assign dec_instr_out.i_type = iType_r;
  assign dec_instr_out.cmd    = iCmd_r;

  ////////////////////////////////////////////////////////
  // Handle the Decoding
  ////////////////////////////////////////////////////////
  always_ff @(posedge clk_in, negedge rst_low_in) begin
    if (!rst_low_in) begin
      instr_pc_out <= '0;

      // Reset to NOP
      iType_r <= ALU;
      iCmd_r.alu_cmd.alu_op        <= ADD;
      iCmd_r.alu_cmd.use_immediate <= '1;
      iCmd_r.alu_cmd.rd            <= '0;
      iCmd_r.alu_cmd.rs1           <= '0;
      iCmd_r.alu_cmd.rs2           <= '0;
      iCmd_r.alu_cmd.imm           <= '0;
    end
    else begin
      // Keep instr_pc_out in alignment with instr_pc_in
      instr_pc_out <= instr_pc_in;

      // If the instruction is not valid insert a NOP
      if (!instr_valid_in) begin
        iType_r <= ALU;
        iCmd_r.alu_cmd.alu_op        <= ADD;
        iCmd_r.alu_cmd.use_immediate <= '1;
        iCmd_r.alu_cmd.rd            <= '0;
        iCmd_r.alu_cmd.rs1           <= '0;
        iCmd_r.alu_cmd.rs2           <= '0;
        iCmd_r.alu_cmd.imm           <= '0;
      end
      // Otherwise decode the instruction
      else begin
        case (r_instr_in.opcode)
          OP : begin
            iType_r <= ALU;

            iCmd_r.alu_cmd.alu_op        <= alu_op;
            iCmd_r.alu_cmd.use_immediate <= '0;
            iCmd_r.alu_cmd.rd            <= r_instr_in.rd;
            iCmd_r.alu_cmd.rs1           <= r_instr_in.rs1;
            iCmd_r.alu_cmd.rs2           <= r_instr_in.rs2;
            iCmd_r.alu_cmd.imm           <= '0;
          end
          OP_IMM : begin
            iType_r <= ALU;

            iCmd_r.alu_cmd.alu_op        <= alu_op;
            iCmd_r.alu_cmd.use_immediate <= '1;
            iCmd_r.alu_cmd.rd            <= i_instr_in.rd;
            iCmd_r.alu_cmd.rs1           <= i_instr_in.rs1;
            iCmd_r.alu_cmd.rs2           <= '0;
            iCmd_r.alu_cmd.imm           <= i_instr_in.imm;            
          end
          LOAD : begin
            iType_r <= MEM;

            iCmd_r.mem_cmd.load_op     <= '1;
            iCmd_r.mem_cmd.op_size     <= memSize_e'(i_instr_in.funct3);
            iCmd_r.mem_cmd.addr_reg    <= i_instr_in.rs1;
            iCmd_r.mem_cmd.src_dst_reg <= i_instr_in.rd;
            iCmd_r.mem_cmd.addr_offset <= i_instr_in.imm;
          end
          STORE : begin
            iType_r <= MEM;

            iCmd_r.mem_cmd.load_op     <= '0;
            iCmd_r.mem_cmd.op_size     <= memSize_e'(s_instr_in.funct3);
            iCmd_r.mem_cmd.addr_reg    <= s_instr_in.rs1;
            iCmd_r.mem_cmd.src_dst_reg <= s_instr_in.rs2;
            iCmd_r.mem_cmd.addr_offset <= {s_instr_in.imm_high, s_instr_in.imm_low};
          end
          BRANCH : begin
            iType_r <= BRN;

            iCmd_r.brn_cmd.brn_type <= brnType_e'(b_instr_in.funct3);
            iCmd_r.brn_cmd.rs1      <= b_instr_in.rs1;
            iCmd_r.brn_cmd.rs2      <= b_instr_in.rs2;
            iCmd_r.brn_cmd.imm      <= {b_instr_in.imm_12, b_instr_in.imm_11, b_instr_in.imm_10_5, b_instr_in.imm_4_1, 1'b0};
          end
          JAL : begin
            iType_r <= JMP;

            iCmd_r.jmp_cmd.use_src_reg <= '0;
            iCmd_r.jmp_cmd.dst_reg     <= j_instr_in.rd;
            iCmd_r.jmp_cmd.src_reg     <= '0;
            iCmd_r.jmp_cmd.imm         <= {j_instr_in.imm_20, 
                                           j_instr_in.imm_19_12,
                                           j_instr_in.imm_11,
                                           j_instr_in.imm_10_1,
                                           1'b0};
          end
          JALR : begin
            iType_r <= JMP;

            iCmd_r.jmp_cmd.use_src_reg <= '1;
            iCmd_r.jmp_cmd.dst_reg     <= i_instr_in.rd;
            iCmd_r.jmp_cmd.src_reg     <= i_instr_in.rs1;
            iCmd_r.jmp_cmd.imm         <= {18'h0, i_instr_in.imm};
          end
          LUI : begin
            iType_r <= LUP;

            iCmd_r.lup_cmd.incr_pc <= '0;
            iCmd_r.lup_cmd.rd      <= u_instr_in.rd;
            iCmd_r.lup_cmd.imm     <= u_instr_in.imm;
          end
          AUIPC : begin
            iType_r <= LUP;

            iCmd_r.lup_cmd.incr_pc <= '1;
            iCmd_r.lup_cmd.rd      <= i_instr_in.rd;
            iCmd_r.lup_cmd.imm     <= i_instr_in.imm;
          end
          SYSTEM : begin
            iType_r <= ENV;

            iCmd_r.env_cmd.is_call  <= (i_instr_in.imm == 12'h0);
            iCmd_r.env_cmd.is_break <= (i_instr_in.imm == 12'h1);
          end
          // Default to NOP
          default : begin
            iType_r <= ALU;
            iCmd_r.alu_cmd.alu_op        <= ADD;
            iCmd_r.alu_cmd.use_immediate <= '1;
            iCmd_r.alu_cmd.rd            <= '0;
            iCmd_r.alu_cmd.rs1           <= '0;
            iCmd_r.alu_cmd.rs2           <= '0;
            iCmd_r.alu_cmd.imm           <= '0;
          end 
        endcase
      end

    end
  end

  ////////////////////////////////////////////////////////
  // Handle the Decoding of the ALU OP
  ////////////////////////////////////////////////////////
  always_comb begin
    case ({r_instr_in.funct3, r_instr_in.funct7})
      { ADD_FUNCT3,  ADD_FUNCT7} : alu_op = ADD;
      { SUB_FUNCT3,  SUB_FUNCT7} : alu_op = SUB;
      { XOR_FUNCT3,  XOR_FUNCT7} : alu_op = XOR;
      {  OR_FUNCT3,   OR_FUNCT7} : alu_op = OR;
      { AND_FUNCT3,  AND_FUNCT7} : alu_op = AND;
      { SLL_FUNCT3,  SLL_FUNCT7} : alu_op = SLL;
      {  SR_FUNCT3,  SRL_FUNCT7} : alu_op = SRL;
      {  SR_FUNCT3,  SRA_FUNCT7} : alu_op = SRA;
      { SLT_FUNCT3,  SLT_FUNCT7} : alu_op = SLT;
      {SLTU_FUNCT3, SLTU_FUNCT7} : alu_op = SLTU;
    endcase
  end

endmodule