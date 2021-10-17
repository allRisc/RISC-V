#!/bin/bash

# This file needs to be sourced prior to building to setup some useful environment variables

echo "============================"
echo "Setup Script"
echo "============================"

BASE_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo "BASE_DIR=${BASE_DIR}"
export BASE_DIR

alias rbuild="make -f ${BASE_DIR}/proc/Makefile -C ${BASE_DIR}/build"
alias rsim="make -f ${BASE_DIR}/proc/Makefile -C ${BASE_DIR}/build sim"
alias rclean="make -f ${BASE_DIR}/proc/Makefile -C ${BASE_DIR}/build clean"