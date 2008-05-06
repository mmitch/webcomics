#!/bin/bash

ls *.[jg][pi][gf] | sort | while read FILE; do

    echo -e "${FILE}\thttp://www.dilbert.com/fast/${FILE:0:4}-${FILE:4:2}-${FILE:6:2}/\t${FILE:6:2}.${FILE:4:2}.${FILE:0:4}"

done > index
