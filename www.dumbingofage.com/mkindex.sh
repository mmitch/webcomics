#!/bin/bash

ls *.png | sort | while read FILE; do

    NAME=${FILE:11}
    echo -e "${FILE}\t${FILE:8:2}.${FILE:5:2}.${FILE:0:4} ${NAME%.*}"

done > index
