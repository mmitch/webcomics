#!/bin/bash

find . -maxdepth 1 -type f -regex '.*\.\(gif\|jpg\)' | cut -c 3- | sort -n | while read -r FILE; do

    STRIPZERO=$(sed 's/^0*//' <<< "${FILE%-*}")
    echo -e "${FILE}\thttp://www.lfgcomic.com/page/${STRIPZERO}\t#${STRIPZERO}"

done > index
