#!/bin/bash
ls -rt *.gif *.jpeg | while read FILE; do

    echo -e "${FILE}\t${FILE%.*}"

done > index
