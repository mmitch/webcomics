#!/bin/bash

ls | grep '\.jpg$' | sort | sed -e 's/^\(MF0*\([0-9]*\)\..*\)/\1 \2/' | while read FILE STRIPZERO; do

    echo -e "${FILE}\thttp://www.misfile.com/?page=${STRIPZERO}\t#${STRIPZERO}"

done > index
