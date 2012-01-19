#!/bin/bash

ls | egrep '\.(jpg|png|gif)$' | sort -n | sed -e 's/\(\(0*\([0-9]*\).*\)\..*\)/\1 \2 \3/' | while read FILE NAME STRIPZERO; do

    echo -e "${FILE}\thttp://xkcd.com/c${STRIPZERO}.html\t#${STRIPZERO} $(cat ${NAME}.txt)"

done > index
