#!/bin/bash

ls | egrep '\.(jpeg|gif)$' | sort | while read FILE; do
    echo -e "${FILE}\thttp://www.sinfest.net/archive_page.php?comicID=${FILE:0:4}\t[${FILE:13:2}.${FILE:10:2}.${FILE:5:4}]"

done > index
