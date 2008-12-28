#!/bin/bash

ls | grep \.png$ | sort | sed -e 's/^\(0*\([0-9]*\)\..*$\)/\1 \2/' | while read FILE NR; do

    echo -e "${FILE}\thttp://www.mezzacotta.net/garfield/?comic=${NR}\t${NR}: $( cat ${FILE}.text)"

done > index
