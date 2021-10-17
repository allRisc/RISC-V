#**************************************************************************
# Source File for Personal Implementation of switch_debouncer             *
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

if {$::argc == 2} {
  set DESIGN_NAME [lindex $argv 0]
  set PR_CHECKPOINT [lindex $argv 1]
  
  puts $DESIGN_NAME

  open_checkpoint $PR_CHECKPOINT
  
  write_debug_probes -force ${DESIGN_NAME}.ltx
  write_bitstream -force ${DESIGN_NAME}.bit
  
  write_checkpoint -force ${DESIGN_NAME}_final.dcp
} else {
  puts "USAGE: finalize.tcl <DESIGN_NAME> <PLACE-ROUTE CHECKPOINT>"
}