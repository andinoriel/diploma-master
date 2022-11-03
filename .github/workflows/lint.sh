#!/bin/bash

set -eu

is_bash() {
    [[ $1 == *.sh ]] && return 0
    [[ $1 == */bash-completion/* ]] && return 0
    [[ $(file -b --mime-type "$1") == text/x-shellscript ]] && return 0
    return 1
}

# ??? - not all paths ?
while IFS= read -r -d $'' file; do
    if is_bash "$file"; then
        shellcheck -e SC1090 -W0 -s bash "$file"
    fi
done < <(find . -type f \! -path "./.git/*" -print0)
