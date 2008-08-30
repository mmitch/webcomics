#!/bin/bash

ls *.gif | sort | while read FILE; do

    echo -e "${FILE}\thttp://www.comics.com/creators/bc/archive/bc-20${FILE:4:6}.html\t[${FILE:8:2}.${FILE:6:2}.20${FILE:4:2}]"

done > index
