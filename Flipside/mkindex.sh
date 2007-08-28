#!/bin/bash
ls -rt *.gif *.jpeg | sort | while read FILE; do

    echo -e "${FILE}\t${FILE%.*}"

done > index
