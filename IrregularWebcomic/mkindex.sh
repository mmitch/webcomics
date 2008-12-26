#!/bin/bash

ls | egrep '\.(jpeg|gif)$' | sort | sed -e 's/^\([^0-9]*0*\([0-9]*\).*\)$/\1 \2/' | while read FILE NR; do

    echo -e "${FILE}\thttp://www.irregularwebcomic.net/${NR}.html\t[${NR}]"

done > index
