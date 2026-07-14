#!/bin/bash

find . -maxdepth 1 -type f -name '*.jpg' | sort | while read -r FILE; do

    NUMBER0=${FILE:2:6}
    NUMBER=${NUMBER0##*0}

    URLFILE=$NUMBER0.url

    [[ -r $URLFILE ]] || continue

    read -r URL < "$URLFILE"

    TITLEFILE=$NUMBER0.txt
    if [[ -s ${TITLEFILE} ]] ; then
	read -r TEXT < "$TITLEFILE"
    else
	TEXT=$NUMBER
    fi

    echo -e "$FILE\t$URL\t$TEXT"

done > index
