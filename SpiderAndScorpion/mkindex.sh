#!/bin/bash

ls *.jpg | sort | while read FILE; do

    STRIPZERO=$(echo ${FILE:0:4} | sed 's/^0*//')
    echo -e "${FILE}\t#${STRIPZERO}"

done > index
