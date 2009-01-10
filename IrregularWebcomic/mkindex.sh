#!/bin/bash

ls | egrep '\.(jpeg|gif|png)$' | sort | sed -e 's/^\([^0-9]*0*\([0-9a-zA-Z]*\).*\)$/\1 \2/' | while read FILE NR; do

    echo -e "${FILE}\thttp://www.irregularwebcomic.net/${NR}.html\t[${NR}]"

done > index
