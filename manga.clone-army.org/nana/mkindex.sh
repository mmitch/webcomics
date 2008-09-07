#!/bin/bash

ls *.jpg | sort | while read FILE; do

    echo -e "${FILE}\t"`echo ${FILE:10:3} | sed 's/^0*//'`

done > index
