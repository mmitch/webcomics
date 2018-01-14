#!/bin/bash

exec > index

# older stuff -> filename starts with YYYY-MM-DD

find . -name '????-??-??*.jpg' | sed -e 's,^\./,,' | sort | while read -r FILE; do

    printf -v DATE '%s.%s.%s' "${FILE:8:2}" "${FILE:5:2}" "${FILE:0:4}"
    printf '%s\t%s\n' "$FILE" "$DATE"

done


# newer stuff -> filename starts with Unix-Timestamp

find . -name '????[0-9]*.jpg' | sed -e 's,^\./,,' | sort -n | while read -r FILE; do

    TSP="${FILE%%-*}"
    printf '%s\t%(%d.%m.%Y)T\n' "$FILE" "$TSP"

done
