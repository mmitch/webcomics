#!/bin/bash
# $Id: mkindex.sh,v 1.3 2006-11-19 16:01:22 mitch Exp $

ls *.gif *.jpg | sort | while read FILE; do

    echo -e "${FILE}\thttp://www.michael-fredrich.de/Cartoons/${FILE:3:3}.htm\t"$(cat ${FILE:0:6}.txt)

done > index
