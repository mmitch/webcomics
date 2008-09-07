#!/bin/bash

ls *.jpg 2>/dev/null | sort | while read FILE; do

    echo -e "${FILE}\thttp://www.ruthe.de/gallery/cpg1410/albums/userpics/10001/strip_${FILE:2:4}.jpg\t#${FILE:2:4}"

done > index
