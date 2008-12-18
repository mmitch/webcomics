#!/bin/bash

ls | egrep '\.png$' | sort | while read FILE; do

    echo -e "${FILE}\thttp://www.questionablecontent.net/comics/${FILE:0:3}.png\t[${FILE:0:3}]"

done > index
