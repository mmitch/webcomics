#!/bin/bash

ls *.gif | sort -n | while read FILE; do

    NUMBER=${FILE%.gif}
    PARM="$(echo $NUMBER | sed 's/^0*//')"
    read TEXT < ${NUMBER}.txt
    echo -e "${FILE}\thttp://www.sakurai-cartoons.de/actual.php3?gross=${PARM}\t${TEXT}"

done > index
