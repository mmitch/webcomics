#!/bin/bash

ls *.png | sort | while read FILE; do

    NR=`echo ${FILE:0:6} | sed 's/^0*//'`
    NR=${NR:-0}
    echo -e "${FILE}\thttp://manga.clone-army.org/jis.php?page=${NR}\t${NR}"

done > index
