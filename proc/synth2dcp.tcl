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

if {$::argc > 1} {
  set DESIGN_TARGET [lindex $argv 0]
  puts "Design Target: $DESIGN_TARGET"

  set_part "xc7a100tcsg324-1"

  for {set i 1} {$i < $argc} {incr i} {
    set dependency [lindex $argv $i]
    set dep_ext [file extension $dependency]
    switch $dep_ext {
      .sv {
        puts "System Verilog Dependency: $dependency"
        read_verilog -sv $dependency
      }
      .v {
        puts "Verilog Dependency: $dependency"
        read_verilog $dependency
      }
      .vhd {
        puts "VHDL Dependency: $dependency"
        read_vhdl $dependency
      }
      .xci {
        puts "IP Dependency: $dependency"
        read_ip $dependency
      }
      .dcp {
        puts "Pre-Synth Checkpoint Dependency: $dependency"
        read_checkpoint $dependency
      }
      .xdc {
        puts "Xilinx Design Constraints Dependency: $dependency"
        read_xdc $dependency
      }
      default {
        puts "WARNING: UNABLE TO RESOLVE FILE TYPE: $dependency"
      }
    }
  }

  # read_verilog ../src/rtl/top.sv
  # read_xdc ../src/constr/top.xdc
  # read_ip ../src/ip/nexys7_clock/nexys7_clock.xci

  
  upgrade_ip [get_ips *]
  generate_target -force {All} [get_ips *]
  synth_ip [get_ips *]

  synth_design -top top

  write_checkpoint -force $DESIGN_TARGET
} else {
  puts "This script accumulates and synthesizes all the source files necessary for "
  puts "USAGE: synth2dcp.tcl <path/design_target.dcp>"
}