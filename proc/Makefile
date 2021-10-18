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

DESIGN_NAME ?= risc_v_wrapper

SRC_FOLDER ?= ${BASE_DIR}/src

INCL_DIR ?= $(SRC_FOLDER)/rtl/memory_system

RTL_LIST ?= $(SRC_FOLDER)/rtl/support/clk_divider.sv \
						$(SRC_FOLDER)/rtl/support/clk_rst.sv \
						$(SRC_FOLDER)/rtl/generic_io/seven_seg_driver.sv \
						$(SRC_FOLDER)/rtl/memory_system/instr_rom.sv \
						$(SRC_FOLDER)/rtl/memory_system/memory_system_pkg.sv \
						$(SRC_FOLDER)/rtl/memory_system/memory_system.sv \
						$(SRC_FOLDER)/rtl/processor/risc_v_isa_pkg.sv \
						$(SRC_FOLDER)/rtl/processor/instr_fetcher.sv \
						$(SRC_FOLDER)/rtl/processor/instr_decoder.sv \
						$(SRC_FOLDER)/rtl/processor/register_file.sv \
						$(SRC_FOLDER)/rtl/processor/risc_v_cpu.sv \
						$(SRC_FOLDER)/rtl/$(DESIGN_NAME).sv

IP_LIST ?= 

XDC_LIST ?= $(SRC_FOLDER)/constr/$(DESIGN_NAME).xdc

# Setup the file structure environment
SIM_DIR = ${BASE_DIR}/sim
RTL_DIR = ${BASE_DIR}/src/rtl

VPATH  = .
VPATH += $(RTL_DIR)
VPATH += $(RTL_DIR)/support
VPATH += $(RTL_DIR)/processor
VPATH += $(RTL_DIR)/memory_system
VPATH += $(RTL_DIR)/generic_io
VPATH += $(SIM_DIR)

all : build

include ${BASE_DIR}/proc/vivado_build.mk
include ${BASE_DIR}/proc/vivado_sim.mk

.PHONY : clean
clean : 
	rm -f *.dcp *.log *.jou  \
				*.html *.xml *.bit \
				*.str *.rpt *.txt  \
				*.pb *.wdb
	rm -f -r .Xil xsim.dir