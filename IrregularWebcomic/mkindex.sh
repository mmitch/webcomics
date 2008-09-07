#!/bin/bash

ls *.jpeg *.gif 2>/dev/null | sort | while read FILE; do

    NR=$(echo ${FILE:5:4} | sed s/^0+//)
    echo -e "${FILE}\thttp://www.irregularwebcomic.net/${NR}.html\t[${FILE:5:4}]"

done > index
