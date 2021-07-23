#**************************************************************************
# Source File for Personal Implementation of RISC-V Processor             *
# Copyright (C) 2021  Benjamin J Davis                                    *
#                                                                         *
# This program is free software: you can redistribute it and/or modify    *
# it under the terms of the GNU General Public License as published by    *
# the Free Software Foundation, either version 3 of the License, or       *
# (at your option) any later version.                                     *
#                                                                         *
# This program is distributed in the hope that it will be useful,         *
# but WITHOUT ANY WARRANTY; without even the implied warranty of          *
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
# GNU General Public License for more details.                            *
#                                                                         *
# You should have received a copy of the GNU General Public License       *
# along with this program.  If not, see <https://www.gnu.org/licenses/>.  *
#**************************************************************************

if {$::argc == 1} {
  set BUILD_DIR [lindex $argv 0]
  puts $BUILD_DIR

  open_checkpoint $BUILD_DIR/pr.dcp
  
  write_debug_probes -force risc_v.ltx
  write_bitstream -force risc_v.bit
  
  write_checkpoint -force $BUILD_DIR/risc_v_final.dcp
} else {
  puts "USAGE: finalize.tcl <build_dir_path>"
}