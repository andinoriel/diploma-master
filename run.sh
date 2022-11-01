#!/bin/bash

# =================================================================
#
#   TOP-LEVEL: run:run
#   LOCAL ENTRY POINT: .
#
#   ./
#   |-- utility
#   |-- run.sh *CURRENT*
#
#   COMMENT: application entry point
#
# =================================================================

: ${PROJ_ROOT_DIR=$PWD}
: ${APP_NAME="diploma-master"}

source $PROJ_ROOT_DIR/utility/utility.sh

if [ "$EUID" -eq 0 ]; then
  echo "Running as root is not allowed"
  exit $RC_ERROR
fi

export DIALOGRC=$PROJ_ROOT_DIR/utility/.default.dialogrc

app_cleanup() {
  # ...

  unset DIALOGRC
}

# handle interruption
ctrl_c() {
  app_cleanup
  CLEAR_EXIT
}
trap ctrl_c INT
trap ctrl_c QUIT
trap ctrl_c TSTP

# say hello
source $PROJ_ROOT_DIR/modules/greetings.sh dialog_greetings

ctrl_c

