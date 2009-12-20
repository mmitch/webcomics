#!/bin/bash

ls *.jpg | sort -n | while read FILE; do

    DATE=${FILE:0:4}-${FILE:4:2}-${FILE:6:2}
    echo -e "${FILE}\thttp://digitalunrestcomic.com/index.php?date=${DATE}\t${DATE}"

done > index
