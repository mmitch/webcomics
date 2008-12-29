#!/bin/bash

ls | grep \.jpg$ | sort | sed -e 's/^\(\(0*\([0-9]*\)\)\..*$\)/\1 \2 \3/' | while read FILE NR STRIPZERO; do

    echo -e "${FILE}\thttp://darthsanddroids.net/episodes/${NR:2}.html\tEpisode ${STRIPZERO}: $( cat ${FILE}.text)"

done > index
