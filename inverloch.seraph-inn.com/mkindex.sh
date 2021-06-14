#!/bin/bash

for file in *.jpg; do echo "$file"; done | grep -E '[0-9]{3}.jpg' | sort -n | while read -r FILE; do

    STRIPZERO=$((10#${FILE:0:3}))
    echo -e "${FILE}\\thttp://inverloch.seraph-inn.com/viewcomic.php?page=${STRIPZERO}\\t#${STRIPZERO}"

done > index
