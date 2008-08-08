#!/bin/bash

ls *.jpg | sort | while read FILE; do

    STRIPZERO=$(echo ${FILE:0:4} | sed 's/^0*//')
    echo -e "${FILE}\thttp://www.collectedcurios.com/sequentialart.php?s=${STRIPZERO}\t#${STRIPZERO}"

done > index
