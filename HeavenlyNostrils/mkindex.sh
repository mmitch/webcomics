#!/bin/bash

ls *.gif | sort | while read FILE; do

    echo -e "${FILE}\thttp://www.gocomics.com/heavenly-nostrils/${FILE:0:4}/${FILE:4:2}/${FILE:6:2}\t${FILE:6:2}.${FILE:4:2}.${FILE:0:4}"

done > index
