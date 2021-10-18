#*************************************************************************
# Make File for Personal Implementation of RISC-V                      *
# Copyright (C) 2021  Benjamin J Davis                                   *
#                                                                        *
# This program is free software: you can redistribute it and/or modify   *
# it under the terms of the GNU General Public License as published by   *
# the Free Software Foundation, either version 3 of the License, or      *
# (at your option) any later version.                                    *
#                                                                        *
# This program is distributed in the hope that it will be useful,        *
# but WITHOUT ANY WARRANTY; without even the implied warranty of         *
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          *
# GNU General Public License for more details.                           *
#                                                                        *
# You should have received a copy of the GNU General Public License      *
# along with this program.  If not, see <https://www.gnu.org/licenses/>. *
#*************************************************************************/

SIM_TOP  ?= $(DESIGN_NAME)_sim
SIM_LIST ?= $(SIM_DIR)/$(SIM_TOP).sv

SRC_FILE_NAMES  = $(notdir $(RTL_LIST))
SRC_FILE_NAMES += $(notdir $(SIM_LIST))
SIM_FILES = $(addprefix xsim.dir/work/, $(patsubst %.vhd, %.sdb, $(patsubst %.v, %.sdb, $(patsubst %.sv, %.sdb, $(patsubst %.svh, %.sdb, $(SRC_FILE_NAMES))))))

sim : $(SIM_DIR)/top_sim.tcl xsim.dir/top_sim/xsimk
	xsim top_sim -gui -t $<

_compile_sim : xsim.dir/top_sim/xsimk

xsim.dir/work/%.sdb : %.sv
	xvlog --sv $< -i $(INCL_DIR)

xsim.dir/work/%.sdb : %.svh
	xvlog --sv $< -i $(INCL_DIR)

xsim.dir/work/%.sdb : %.v
	xvlog $< -i $(INCL_DIR)

xsim.dir/work/%.sdb : %.vhd
	xvhdl $< -i $(INCL_DIR)

xsim.dir/top_sim/xsimk : $(SIM_FILES)
	xelab --debug typical $(SIM_TOP) -s top_sim -L unisim