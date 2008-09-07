#!/bin/bash

ls | egrep '\.(gif|jpg)$' | sort | while read FILE; do

    read URL TEXT < "${FILE%.*}.txt"
    echo -e "${FILE}\t${URL}\t${TEXT}"

done > index
