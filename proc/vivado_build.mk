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


build : $(DESIGN_NAME).bit $(DESIGN_NAME)_final.dcp 

$(DESIGN_NAME).bit $(DESIGN_NAME)_final.dcp : finalize.tcl pr.dcp
	vivado -mode batch -nojournal -source $< -tclargs $(DESIGN_NAME) pr.dcp

pr.dcp : place_route.tcl synth.dcp 
	vivado -mode batch -nojournal -log pr.log -source $< -tclargs $@ synth.dcp

synth.dcp : synth.tcl $(RTL_LIST) $(XDC_LIST) $(IP_LIST)
	vivado -mode batch -nojournal -log synth.log -source $< -tclargs $(DESIGN_NAME) $@ $(RTL_LIST) $(IP_LIST) $(XDC_LIST)