#!/bin/bash

find . -name \*.jpg | sed -e 's,^\./,,' | sort -n | while read -r FILE; do

    TSP="${FILE%%-*}"
    printf '%s\t%(%d.%m.%Y)T\n' "$FILE" "$TSP"

done > index
