#!/bin/bash

ls | egrep '\.(jpg|png|gif)$' | sort | while read FILE; do

    echo -e "${FILE}\thttp://upevil.com/index.php?date=${FILE:0:4}-${FILE:4:2}-${FILE:6:2}\t${FILE:6:2}.${FILE:4:2}.${FILE:0:4}"

done > index
