#!/bin/bash

echo "============================"
echo "Setup Script"
echo "============================"

BASE_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo "BASE_DIR=${BASE_DIR}"
export BASE_DIR

PROJ_TITLE="RISC-V"
export PROJ_TITLE

for D in *; do
  if [ -f "${D}/setup.sh" ]; then
    source "${D}/setup.sh"
  fi
done
  
