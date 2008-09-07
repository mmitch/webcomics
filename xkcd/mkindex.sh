#!/bin/bash

ls *.jpg *.png | sort | while read FILE; do

    STRIPZERO=$(echo ${FILE:0:3} | sed 's/^0*//')
    echo -e "${FILE}\thttp://xkcd.com/c${STRIPZERO}.html\t#${STRIPZERO} $(cat ${FILE%.???}.txt)"

done > index
