#!/bin/bash

ls *.jpg | sort | while read FILE; do

    NR=`echo ${FILE:10:3} | sed 's/^0*//'`    
    echo -e "${FILE}\thttp://manga.clone-army.org/nana.php?page=${NR}\t${NR}"

done > index
