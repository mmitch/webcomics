#!/bin/bash

ls | grep '\.jpg$' | sort | sed -e 's/\(0*\([0-9]*\)\.jpg\)/\1 \2/' | while read FILE STRIPZERO; do

    STRIPZERO=$(echo ${FILE:0:3} | sed 's/^0*//')
    echo -e "${FILE}\thttp://requiem.seraph-inn.com/viewcomic.php?page=${STRIPZERO}\t#${STRIPZERO}"

done > index
