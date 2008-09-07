#!/bin/bash

ls dorktower*.jpg | sort | while read FILE; do

    echo -e "${FILE}\t[${FILE:9:3}]"

done > index
