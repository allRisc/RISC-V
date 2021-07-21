#!/bin/bash

echo "-> Proc Setup.sh"

CUR_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

case :$PATH: in
  *:"${CUR_DIR}/bin":*) ;;
  *) PATH=${PATH}:${CUR_DIR}/bin ;;
esac
export PATH

case :$PYTHONPATH: in
  *:"${CUR_DIR}/modules":*) ;;
  *) PYTHONPATH=${PYTHONPATH}:${CUR_DIR}/modules
esac
export PYTHONPATH

BOARD_REPO_PATH="$CUR_DIR/boards/repos"
export BOARD_REPO_PATH