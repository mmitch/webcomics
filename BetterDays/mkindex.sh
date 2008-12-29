#!/bin/bash

ls | grep '\.gif$' | sed -e 's/^\(BD\([0-9]*\).*$\)/\2 \1/' | sort -n | while read NR FILE; do

    echo -e "${FILE}\t#${NR}"

done > index
