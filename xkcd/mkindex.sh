#!/bin/bash

for file in *.{jpg,png,gif}; do echo "$file"; done | sort -n | sed -e 's/\(\(0*\([0-9]*\).*\)\..*\)/\1 \2 \3/' | while read -r FILE NAME STRIPZERO; do

    echo -e "${FILE}\\thttps://xkcd.com/c${STRIPZERO}.html\\t#${STRIPZERO} $(cat "${NAME}".txt)"

done > index
