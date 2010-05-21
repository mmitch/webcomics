#!/bin/bash

ls | egrep '\.jpeg$' | sort | while read FILE; do

    echo -e "${FILE}\t${FILE:8:2}.${FILE:5:2}.${FILE:0:4}"

done > index
