#!/bin/bash

ls *.gif | sort | while read FILE; do

    echo -e "${FILE}\t${FILE:4:2}.${FILE:2:2}.20${FILE:0:2}"

done > index
