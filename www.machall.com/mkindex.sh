#!/bin/bash

ls *.jpg | sort | while read FILE; do

    echo -e "${FILE}\t#${FILE:0:5}"

done > index
