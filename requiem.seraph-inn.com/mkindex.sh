#!/bin/bash

ls *.jpg | sort | while read FILE; do

    STRIPZERO=$(echo ${FILE:0:3} | sed 's/^0*//')
    echo -e "${FILE}\thttp://requiem.seraph-inn.com/viewcomic.php?page=${STRIPZERO}\t#${STRIPZERO}"

done > index
