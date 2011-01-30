#!/bin/bash

ls *.png | sort -n | while read FILE; do

    DATE=${FILE:0:8}
    echo -e "${FILE}\t${DATE:6:2}.${DATE:4:2}.${DATE:0:4} $(cat "${FILE}.txt")"

done > index
