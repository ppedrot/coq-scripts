#!/usr/bin/env bash

set -e

# e.g., "Warning\|Error"
warnerr="$1"
curerr=""

file_line_char_warn_regex='^File "\([^ "]\+\)", line \([0-9]\+\), characters \([0-9]\+-[0-9]\+\):\s*\(%0A\s*\)\?\('"$warnerr"'\):\s*'

function process() {
    if echo "$1" | grep -q "${file_line_char_warn_regex}"; then
        echo "$1" | sed "s~${file_line_char_warn_regex}~"'::error file=\1,line=\2,col=\3,severity=\5::~g; s~^\(::[^:]*\)::\(.*\)\[\([^,]\+\),\([^]]\+\)\]\s*$~\1,code=\3%2C\4::\2~g'
    else
        echo "$1" | sed 's/%0A/\n/g'
    fi
}

while read i
do
    # ^File \"([^ \"]+)\", line (\\d+), characters (\\d+-\\d+):
    if [[ "$i" == "File "*:* ]]; then # first line of error
        if [ ! -z "$curerr" ]; then
            process "$curerr"
        fi
        curerr="$i"
    elif [ ! -z "$curerr" ]; then
        curerr+="%0A$i"
    else # not part of a recognized error
        echo "$i"
    fi
done
if [ ! -z "$curerr" ]; then
    process "$curerr"
fi
