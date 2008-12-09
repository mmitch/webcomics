#!/bin/bash

ls *.jpg | sort | cut -c 3-6 | sed 's/^0*//' | while read STRIPZERO; do

    FILE=$(printf MF%04d.jpg $STRIPZERO)
    echo -e "${FILE}\thttp://www.misfile.com/?page=${STRIPZERO}\t#${STRIPZERO}"

done > index
