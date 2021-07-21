# RTL Synthesis-Implementation Makefile

# Set makefile info
VERSION=v0.1-Beta

# Set the default values 
BOARD ?= Nexys-A7-100T
TOOL ?= vivado
COMPILE_FILE ?= $(BASE_DIR)/src/src.compile

help :
	@echo "This makefile is used to manage the build and sim process of of design"
	@echo "  managed under RSI"
	@echo "COMMANDS:"
	@echo "  clean - Cleans the current working directory"

version :
	@echo "$(VERSION)"

clean :
	rm *.mk
	rm *.tcl

init_run : init.tcl
	init_run --tool $(TOOL) --board $(BOARD) -d

# Check if a filelist has been generated in the past
#		This is used to determine the jsons to check for the filelist generating jsons
ifneq ("$(wildcard node_json_list.mk)", "")
include ./node_json_list.mk
else
node_json_list=
endif

filelist : init.tcl filelist.tcl

filelist.tcl : $(node_json_list)
	build_filelist --tool $(TOOL) --board $(BOARD) $(COMPILE_FILE) -d