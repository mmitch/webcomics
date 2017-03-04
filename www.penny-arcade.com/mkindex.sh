#!/bin/bash

ls *.[gjp][ipn][fg] | sort | while read FILE; do

    LINE="${FILE}\thttps://www.penny-arcade.com/comic/${FILE:0:4}/${FILE:4:2}/${FILE:6:2}/\t${FILE:6:2}.${FILE:4:2}.${FILE:0:4}"

    TITLEFILE=${FILE:0:8}.txt
    if [ -s ${TITLEFILE} ] ; then
	read TEXT < ${TITLEFILE}
	LINE="$LINE: ${TEXT}"
    fi

    echo -e "$LINE"

done > index
