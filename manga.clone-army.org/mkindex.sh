#!/bin/bash

ls *.png | sort | while read FILE; do

    echo -e "${FILE}\t"`echo ${FILE:0:6} | sed 's/^0*//'`

done > index
