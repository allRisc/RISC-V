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



if { $::argc == 1 } {
  set_part "xc7a100tcsg324-1"

  read_ip  [lindex $argv 0]
    
  upgrade_ip [get_ips *]
  generate_target -force {All} [get_ips *]
  synth_ip [get_ips *]

  write_checkpoint -force "[file rootname [lindex $argv 0]].dcp"
} else {
    puts "USAGE: source xci2dcp.tcl <path/filename.xci>"
}