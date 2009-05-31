#!/bin/bash

ls *.jpg | sort -n | while read FILE; do

    NUMBER=${FILE%.jpg}
    read TEXT < ${NUMBER}.txt
    echo -e "${FILE}\thttp://orangebox.wwoec.com/vgbutts/ep/${NUMBER##0*}\t${TEXT}"

done > index
