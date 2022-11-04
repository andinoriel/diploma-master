#!/bin/bash

# =================================================================
#
#   MODULE: utility:utility
#   LOCAL ENTRY POINT: *multiple*
#
#   utility
#   |-- utility.sh *CURRENT*
#
#   COMMENT: common variables, some core functions
#
# =================================================================

export DIALOG=${DIALOG=dialog}

export DIALOG_OK=0
export DIALOG_CANCEL=1
export DIALOG_HELP=2
export DIALOG_EXTRA=3
export DIALOG_ITEM_HELP=4
export DIALOG_ESC=255

export DMENU_OPTION_1=1
export DMENU_OPTION_2=2
export DMENU_OPTION_3=3
export DMENU_OPTION_4=4
export DMENU_OPTION_5=5
export DMENU_OPTION_6=6
export DMENU_OPTION_7=7
export DMENU_OPTION_8=8
export DMENU_OPTION_9=9
export DMENU_OPTION_10=10
export DMENU_OPTION_11=11
export DMENU_OPTION_12=12
export DMENU_OPTION_13=13
export DMENU_OPTION_14=14
export DMENU_OPTION_15=15

# if [ -z $DISPLAY ]
# then
#     export DIALOG=${DIALOG=dialog}
# else
#     export DIALOG=Xdialog
# fi

export RC_OK=0
export RC_ERROR=1

# RESOLVE_FUNC_CALL "$@"
RESOLVE_FUNC_CALL() {
  if declare -f "$1" >/dev/null; then
    "$@"
  else
    echo "'$1' is not a known function name" >&2
    exit $RC_ERROR
  fi
}

CLEAR_EXIT() {
  clear
  exit
}

SUDO_CRED_LOCK_RESET() {
  sudo -k
  faillock --user USER --reset
}
