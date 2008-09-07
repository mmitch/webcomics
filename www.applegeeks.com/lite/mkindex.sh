#!/bin/bash

ls *.[gj][ip][fg] | sort | while read FILE; do

    NUMBER=${FILE%jpg}
    NUMBER=${NUMBER%gif}
    read TEXT < ${NUMBER}txt
    echo -e "${FILE}\t${TEXT}"

done > index
