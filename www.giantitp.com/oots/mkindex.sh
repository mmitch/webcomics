#!/bin/bash

ls *.gif *.jpg 2>/dev/null | sort | while read FILE; do

    echo -e "${FILE}\thttp://www.giantitp.com/comics/oots${FILE:2:4}.html\t#${FILE:0:6}"

done | sed -e 's/#0*/#/' > index
