#!/bin/bash

# =================================================================
#
#   TOP-MODULE: greetings:greetings
#   LOCAL ENTRY POINT: dialog_greetings
#
#   modules
#   |-- greetings.sh *CURRENT*
#
#   COMMENT: greetings user DIALOG with copyright and disclaimer
#
# =================================================================

source $PROJ_ROOT_DIR/utility/utility.sh

dialog_greetings() {
  hello="
    Master diploma project designed to interactively demonstrate the key
    aspects of modern encryption algorithms with an assessment of their
    effectiveness.

    ----------------- 2022 Mykola Symon - Copyright (c) ----------------
  "
  disclaimer="
    THIS SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
  "

  if $DIALOG --title "$APP_NAME" --msgbox "$hello" 12 80 3>&1 1>&2 2>&3; then
    if $DIALOG --title "DISCLAIMER" --msgbox "$disclaimer" 14 85 3>&1 1>&2 2>&3; then
      return
    else
      CLEAR_EXIT
    fi
  else
    CLEAR_EXIT
  fi

}

RESOLVE_FUNC_CALL $@
