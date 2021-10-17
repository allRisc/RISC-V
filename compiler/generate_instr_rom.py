#! /usr/bin/python3.9

import argparse
from riscv_assembler.convert import AssemblyConverter

def main ():
  # Handle the arguments
  parser = argparse.ArgumentParser()
  parser.add_argument("asm_file", type=str, help="The file to assemble")
  parser.add_argument("--output_file", "-o", type=str, help="The file to output the memory to")

  args = parser.parse_args()

  cnv = AssemblyConverter(output_type='r', hexMode=True)
  machine_code = cnv.convert(args.asm_file)


  if (args.output_file is None) :
    args.output_file = args.asm_file[:-2] + ".mem"

  with open(args.output_file, "w") as mFile : 
    mFile.write(FILE_HEADER)

    for i in range(0, 1024) :
      if (len(machine_code) > i) :
        mFile.write(f"{machine_code[i][2:]}\n")
      else :
        mFile.write(f"00000000\n")


FILE_HEADER = """//*************************************************************************
// Source File for Personal Implementation of RISC-V                      *
// Copyright (C) 2021  Benjamin J Davis                                   *
//                                                                        *
// This program is free software: you can redistribute it and/or modify   *
// it under the terms of the GNU General Public License as published by   *
// the Free Software Foundation, either version 3 of the License, or      *
// (at your option) any later version.                                    *
//                                                                        *
// This program is distributed in the hope that it will be useful,        *
// but WITHOUT ANY WARRANTY; without even the implied warranty of         *
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          *
// GNU General Public License for more details.                           *
//                                                                        *
// You should have received a copy of the GNU General Public License      *
// along with this program.  If not, see <https://www.gnu.org/licenses/>. *
//*************************************************************************/
"""

if __name__=="__main__" :
  main()