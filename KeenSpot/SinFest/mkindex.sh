#!/bin/bash

ls | egrep '\.(jpeg|gif)$' | sort | sed -e 's/\(\([0-9]*\)-\([0-9]*\)-\([0-9]*\)-\([0-9]*\)\..*\)/\1 \2 \5.\4.\3/' | while read FILE NR DATE; do

    echo "${FILE}\thttp://www.sinfest.net/archive_page.php?comicID=${NR}\t[${DATE}]"

done > index
