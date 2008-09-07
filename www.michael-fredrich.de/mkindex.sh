#!/bin/bash

ls *.gif *.jpg | sort | while read FILE; do

    echo -e "${FILE}\thttp://www.michael-fredrich.de/Cartoons/${FILE:3:3}.htm\t"$(cat ${FILE:0:6}.txt)

done > index
