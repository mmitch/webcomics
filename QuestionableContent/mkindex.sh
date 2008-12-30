#!/bin/bash

ls | grep \.png$ | sort | sed -e 's/^\(0*\([0-9]*\)\..*$\)/\1 \2/' | while read FILE STRIPZERO; do

    echo -e "${FILE}\thttp://questionablecontent.net/view.php?comic=${STRIPZERO}\t#${STRIPZERO}"

done > index
