#!/bin/bash

ls *.gif *.jpeg | sort | while read FILE; do

    echo -e "${FILE}\thttp://www.dominic-deegan.com/view.php?date=${FILE:0:4}-${FILE:4:2}-${FILE:6:2}\t${FILE:6:2}.${FILE:4:2}.${FILE:0:4}";

done > index
