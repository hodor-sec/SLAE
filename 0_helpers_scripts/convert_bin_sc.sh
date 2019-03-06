#!/bin/sh

if [ $# -eq 1 ]; then
	objdump -d ./$1 | grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-7 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s | sed 's/.\{64\}/&\n/g' | sed 's/^\\/\"\\/' | sed -e "s|$|\"|"
	else echo "Give a binary program as argument."
fi

