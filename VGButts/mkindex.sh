#!/bin/bash

ls *.jpg | sort -n | while read FILE; do

    NUMBER=${FILE%.jpg}
    NUM=$(( 1${NUMBER} - 1000000 ))
    read TEXT < ${NUMBER}.txt
    echo -e "${FILE}\thttp://orangebox.wwoec.com/vgbutts/ep/${NUM}\t${TEXT}"

done > index
