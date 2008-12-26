#!/bin/bash

ls | grep '\.gif$' | sort -n | sed -e 's/^\(\(0*\([0-9]*\)\)\..*\)/\1 \2 \3/' | while read FILE NUMBER PARM; do

    read TEXT < ${NUMBER}.txt
    echo -e "${FILE}\thttp://www.sakurai-cartoons.de/actual.php3?gross=${PARM}\t${TEXT}"

done > index
