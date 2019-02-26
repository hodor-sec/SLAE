#!/bin/sh

if [ $# -eq 1 ]; then
            ndisasm ./$1 -b 32 | awk '{printf "%s\t# %s %s #\n", $2, $3, $4;}' | sed 's/[0-9A-F]\{2\}/\\x&/g' | sed 's/^/\"/g' | sed 's/\t/\"&/' | column -t
            else echo "Give a binary program as argument."
fi
