#!/bin/bash

ls *.[gjp][ipn][fg] | sort -n | while read FILE; do

    NUMBER=${FILE%.jpg}
    NUMBER=${NUMBER%.gif}
    NUMBER=${NUMBER%.png}
    read TEXT < ${NUMBER}.txt
    echo -e "${FILE}\thttp://www.megatokyo.com/strip/${NUMBER}\t${TEXT}"

done > index
