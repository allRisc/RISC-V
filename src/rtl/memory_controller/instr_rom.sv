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

module instr_rom #(
  parameter ROM_FILE_NAME = ""
) (
  input  wire         clk_in,
  input  logic [ 9:0] addr_in,
  output logic [31:0] instr_out
);

  // Signals
  logic [31:0] rom [1023:0];

  // Intialize the ROM
  initial begin
    if (ROM_FILE_NAME != "") begin
      $readmemh(ROM_FILE_NAME, rom);
    end
    else begin
      rom <= '{'0};
    end
  end

  // Handle the reading
  always_ff @(posedge clk_in) begin
    instr_out <= rom[addr_in];
  end


endmodule