#!/bin/bash

ls *.jpg | sort -n | while read FILE; do

    DATE=${FILE:0:8}
    TEXT=${FILE:9}
    TEXT=${TEXT%.jpg}
    TEXT=${TEXT//-/ }
    echo -e "${FILE}\t${DATE:6:2}.${DATE:4:2}.${DATE:0:4} ${TEXT}"

done > index
