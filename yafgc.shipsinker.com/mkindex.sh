#!/bin/bash

ls *.jpg | sort -n | while read FILE; do

    NUMBER=${FILE%.jpg}
    NUM=$(( 1${NUMBER} - 1000000 ))
    read TEXT < ${NUMBER}.txt
    echo -e "${FILE}\thttp://yafgc.shipsinker.com/index.php?strip_id=${NUM}\tStrip ${NUM}: ${TEXT}"

done > index
