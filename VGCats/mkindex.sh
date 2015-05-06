#!/bin/bash

ls *.jpg *.gif | sort | while read FILE; do

    echo -e "${FILE}\t${FILE:4:2}.${FILE:2:2}.${FILE:0:2}"

done > index
