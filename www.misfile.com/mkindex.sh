#!/bin/bash

ls *.jpg | sort | while read FILE; do

    STRIPZERO=$(echo ${FILE:2:4} | sed 's/^0*//')
    echo -e "${FILE}\thttp://www.misfile.com/?page=${STRIPZERO}\t#${STRIPZERO}"

done > index
