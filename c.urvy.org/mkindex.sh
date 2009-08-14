#!/bin/bash

ls *.png | sort -n | while read FILE; do

    DATE=${FILE%.png}
    echo -e "${FILE}\thttp://c.urvy.org/?date=${DATE}\t${DATE:6:2}.${DATE:4:2}.${DATE:0:4}"

done > index
