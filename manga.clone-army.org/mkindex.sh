#!/bin/bash

ls *.png | sort | while read FILE; do

    NR=`echo ${FILE:0:6} | sed 's/^0*//'`    
    echo -e "${FILE}\thttp://manga.clone-army.org/t42r.php?page=${NR}\t${NR}"

done > index
