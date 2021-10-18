/**************************************************************************
 * Source File for Personal Implementation of RISC-V                      *
 * Copyright (C) 2021  Benjamin J Davis                                   *
 *                                                                        *
 * This program is free software: you can redistribute it and/or modify   *
 * it under the terms of the GNU General Public License as published by   *
 * the Free Software Foundation; either version 3 of the License; or      *
 * (at your option) any later version.                                    *
 *                                                                        *
 * This program is distributed in the hope that it will be useful;        *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of         *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          *
 * GNU General Public License for more details.                           *
 *                                                                        *
 * You should have received a copy of the GNU General Public License      *
 * along with this program.  If not; see <https://www.gnu.org/licenses/>. *
 **************************************************************************/

`timescale 1ns/1ps

// Package for RV32I Base Instructions
package risc_v_isa_pkg;

  ////////////////////////////////////////////////////////
  // Instruction Information
  ////////////////////////////////////////////////////////
  typedef enum logic [6:0] {
    OP     = 7'b0110011,
    OP_IMM = 7'b0010011,

    LOAD   = 7'b0000011,
    STORE  = 7'b0100011,

    BRANCH = 7'b1100011,
    JAL    = 7'b1101111,
    JALR   = 7'b1100111,

    LUI    = 7'b0110111,
    AUIPC  = 7'b0010111,

    SYSTEM = 7'b1110011
  } opcode_e;

  // FUNCT3 and FUNCT7 definitions for OP and OP-IMM opcodes
  parameter ADD_FUNCT3  = 3'h0;
  parameter SUB_FUNCT3  = 3'h0;
  parameter XOR_FUNCT3  = 3'h4;
  parameter OR_FUNCT3   = 3'h6;
  parameter AND_FUNCT3  = 3'h7;
  parameter SLL_FUNCT3  = 3'h1;
  parameter SR_FUNCT3   = 3'h5;
  parameter SLT_FUNCT3  = 3'h2;
  parameter SLTU_FUNCT3 = 3'h3;
  
  parameter ADD_FUNCT7  = 7'h00;
  parameter SUB_FUNCT7  = 7'h20;
  parameter XOR_FUNCT7  = 7'h00;
  parameter OR_FUNCT7   = 7'h00;
  parameter AND_FUNCT7  = 7'h00;
  parameter SLL_FUNCT7  = 7'h00;
  parameter SRL_FUNCT7  = 7'h00;
  parameter SRA_FUNCT7  = 7'h20;
  parameter SLT_FUNCT7  = 7'h00;
  parameter SLTU_FUNCT7 = 7'h00;

  // FUNCT3 definitions for LOAD and STORE opcodes
  parameter BYTE_FUNCT3   = 3'h0;
  parameter HALF_FUNCT3   = 3'h1;
  parameter WORD_FUNCT3   = 3'h2;
  parameter BYTE_U_FUNCT3 = 3'h4;
  parameter HALF_U_FUNCT3 = 3'h5;

  // FUNCT3 definitions for BRANCH opcodes
  parameter BEQ_FUNCT3  = 3'h0;
  parameter BNE_FUNCT3  = 3'h1;
  parameter BLT_FUNCT3  = 3'h4;
  parameter BGE_FUNCT3  = 3'h5;
  parameter BLTU_FUNCT3 = 3'h6;
  parameter BGEU_FUNCT3 = 3'h7;

  // FUNCT3 Definition for JALR opcode
  parameter JALR_FUNCT3 = 3'h0;

  // FUNCT3 and IMM Definition for SYSTEM opcodes
  parameter ENV_FUNCT3 = 3'h0;
  
  parameter ECALL_IMM  = 'h0;
  parameter EBREAK_IMM = 'h1;

  ////////////////////////////////////////////////////////
  // Instruction Formats
  ////////////////////////////////////////////////////////
  typedef struct packed {
    logic [6:0] funct7;
    logic [4:0] rs2;
    logic [4:0] rs1;
    logic [2:0] funct3;
    logic [4:0] rd;
    opcode_e    opcode;
  } rInstr_s;

  typedef struct packed {
    logic [11:0] imm;
    logic [ 4:0] rs1;
    logic [ 2:0] funct3;
    logic [ 4:0] rd;
    logic [ 6:0] opcode;
  } iInstr_s;

  typedef struct packed {
    logic [6:0] imm_high;
    logic [4:0] rs2;
    logic [4:0] rs1;
    logic [2:0] funct3;
    logic [4:0] imm_low;
    opcode_e    opcode;
  } sInstr_s;

  typedef struct packed {
    logic       imm_12;
    logic [5:0] imm_10_5;
    logic [4:0] rs2;
    logic [4:0] rs1;
    logic [2:0] funct3;
    logic [3:0] imm_4_1;
    logic       imm_11;
    opcode_e    opcode;
  } bInstr_s;

  typedef struct packed {
    logic [31:12] imm;
    logic [ 4: 0] rd;
    logic [ 6: 0] opcode;
  } uInstr_s;

  typedef struct packed {
    logic       imm_20;
    logic [9:0] imm_10_1;
    logic       imm_11;
    logic [7:0] imm_19_12;
    logic [4:0] rd;
    opcode_e    opcode;
  } jInstr_s;

  // Instruction Union
  typedef union {
    logic    [31:0] inst;
    rInstr_s        r_type;
    iInstr_s        i_type;
    sInstr_s        s_type;
    bInstr_s        b_type;
    uInstr_s        u_type;
    jInstr_s        j_type;
  } instr_u;

  ////////////////////////////////////////////////////////
  // Decoded Instructions Format
  ////////////////////////////////////////////////////////
  
  // ALU Command info
  typedef enum logic[3:0] {
    ADD,
    SUB,
    XOR,
    OR,
    AND,
    SLL,
    SRL,
    SRA,
    SLT,
    SLTU
  } aluOp_e;

  typedef struct packed {
    aluOp_e        alu_op;
    logic          use_immediate;
    logic   [ 4:0] rd;
    logic   [ 4:0] rs1;
    logic   [ 4:0] rs2;
    logic   [11:0] imm;
  } aluCmd_s;

  // MEM access Command Info
  typedef enum logic[2:0] {
    BYTE  = BYTE_FUNCT3,
    HALF  = HALF_FUNCT3,
    WORD  = WORD_FUNCT3,
    UBYTE = BYTE_U_FUNCT3,
    UHALF = HALF_U_FUNCT3
  } memSize_e;

  typedef struct packed {
    logic            load_op;
    memSize_e        op_size;
    logic     [ 4:0] addr_reg;
    logic     [ 4:0] src_dst_reg;
    logic     [11:0] addr_offset;
    logic     [ 5:0] RESERVED; // To keep struct at 32-bit
  } memCmd_s;

  // Branch Command Info
  typedef enum logic[2:0] {
    EQ  = BEQ_FUNCT3,
    NE  = BNE_FUNCT3,
    LT  = BLT_FUNCT3,
    GE  = BGE_FUNCT3,
    LTU = BLTU_FUNCT3,
    GEU = BGEU_FUNCT3
  } brnType_e;

  typedef struct packed {
    brnType_e        brn_type;
    logic     [ 4:0] rs1;
    logic     [ 4:0] rs2;
    logic     [12:0] imm;
    logic     [ 5:0] RESERVED; // To keep struct at 32-bit
  } brnCmd_s;

  // Jump Command Info
  typedef struct packed {
    logic        use_src_reg;
    logic [ 4:0] dst_reg;
    logic [ 4:0] src_reg;
    logic [20:0] imm;
  } jmpCmd_s;

  // Load Upper Command Info
  typedef struct packed {
    logic        incr_pc;
    logic [ 4:0] rd;
    logic [19:0] imm;
    logic [ 5:0] RESERVED; // To keep struct at 32-bit
  } lupCmd_s;

  // Environment command info
  typedef struct packed {
    logic         is_call;
    logic         is_break;
    logic [ 29:0] RESERVED; // To keep struct at 32-bit
  } envCmd_s;

  // Single type to represent decoded instruction
  typedef union packed {
    aluCmd_s alu_cmd;
    memCmd_s mem_cmd;
    brnCmd_s brn_cmd;
    jmpCmd_s jmp_cmd;
    lupCmd_s lup_cmd;
    envCmd_s env_cmd;
  } instrCmd_u;

  typedef enum {
    ALU,
    MEM, 
    BRN,
    JMP,
    LUP,
    ENV
  } instrType_e;

  typedef struct packed {
    instrCmd_u  cmd;
    instrType_e i_type;
  } instrInfo_s;

endpackage