

all : risc_v.bit risc_v_final.dcp

risc_v.bit risc_v_final.dcp : ../build/pr.dcp
	vivado -mode batch -nojournal -source ../proc/finalize.tcl

../build/pr.dcp : ../build/synth.dcp ../proc/place_route.tcl
	vivado -mode batch -nojournal -source ../proc/place_route.tcl

../build/synth.dcp : ../src/rtl/top.sv
	vivado -mode batch -nojournal -source ../proc/synthesize.tcl