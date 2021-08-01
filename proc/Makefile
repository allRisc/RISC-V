
BUILD_DIR ?= $(BASE_DIR)/build
PROC_DIR ?= $(BASE_DIR)/proc

FILE_LIST ?= ../src/rtl/top.sv ../src/constr/top.xdc ../src/ip/nexys7_clock/nexys7_clock.xci

all : risc_v.bit risc_v_final.dcp

risc_v.bit risc_v_final.dcp : $(BUILD_DIR)/pr.dcp
	vivado -mode batch -nojournal -source $(PROC_DIR)/finalize.tcl -tclargs $(BUILD_DIR)

$(BUILD_DIR)/pr.dcp : $(BUILD_DIR)/synth.dcp $(PROC_DIR)/place_route.tcl
	vivado -mode batch -nojournal -source $(PROC_DIR)/place_route.tcl -tclargs $(BUILD_DIR)

$(BUILD_DIR)/synth.dcp : $(PROC_DIR)/synth2dcp.tcl $(FILE_LIST)
	vivado -mode batch -nojournal -source $(PROC_DIR)/synth2dcp.tcl -tclargs $@ $(FILE_LIST)

# %.dcp : %.xci $(PROC_DIR)/xci2dcp.tcl
# 	vivado -mode batch -nojournal -source $(PROC_DIR)/xci2dcp.tcl -tclargs $<

.PHONY : clean
clean : 
	rm -f \
		$(BUILD_DIR)/*.dcp  \
		$(BUILD_DIR)/*.log  \
		$(BUILD_DIR)/*.jou  \
		$(BUILD_DIR)/*.html \
		$(BUILD_DIR)/*.xml  \
		$(BUILD_DIR)/*.bit  \
		$(BUILD_DIR)/*.str
	rm -f -r \
		$(BUILD_DIR)/.Xil