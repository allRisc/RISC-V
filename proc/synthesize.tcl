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

set_part "xc7a100tcsg324-1"

read_verilog ../src/rtl/top.sv

read_xdc ../src/constr/top.xdc

generate_target all [get_ips]

synth_design -top top

write_checkpoint -force ../build/synth.dcp