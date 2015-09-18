#!/bin/bash

ls *.[jg][pi][gf] |
    sort |
    while read FILE; do

	TEXTFILE=${FILE:0:8}.txt
	if [ -r $TEXTFILE ] ; then
	    read TEXT < $TEXTFILE
	    TEXT=" ${TEXT/- Dilbert by Scott Adams}"
	    TEXT="${TEXT% }"
	else
	    TEXT=''
	fi
	echo -e "${FILE}\thttp://www.dilbert.com/fast/${FILE:0:4}-${FILE:4:2}-${FILE:6:2}/\t${FILE:6:2}.${FILE:4:2}.${FILE:0:4}${TEXT}"

    done > index
