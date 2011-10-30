#!/bin/bash

ls *.[gj][ip][fg] | sort | while read FILE; do

    echo -e "${FILE}\thttp://www.girlgeniusonline.com/comic.php?date=${FILE:0:8}\t${FILE:6:2}.${FILE:4:2}.${FILE:0:4} $(cat ${FILE:0:8}.txt)"

done > index
