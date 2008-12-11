#!/bin/bash

ls |  egrep '\.(jpeg|png|gif)$' | sort | while read FILE; do
    echo -e "${FILE}\thttp://www.countyoursheep.com/d/${FILE:0:8}.html\t[${FILE:6:2}.${FILE:4:2}.${FILE:0:4}]"
done > index
