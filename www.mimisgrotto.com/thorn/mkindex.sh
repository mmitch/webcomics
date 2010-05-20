#!/bin/bash

ls | egrep '\.(jpg|png|gif)$' | sort | while read FILE; do

    echo -e "${FILE}\thttp://www.mimisgrotto.com/thorn/${FILE:0:3}.html\t#${FILE:0:3}"

done > index
