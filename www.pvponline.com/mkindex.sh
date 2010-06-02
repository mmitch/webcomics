#!/bin/bash

ls | egrep '\.(gif|png|jpg)$' | sort | while read FILE; do

    echo -e "${FILE}\t${FILE:9:2}.${FILE:7:2}.${FILE:3:4}"

done > index
