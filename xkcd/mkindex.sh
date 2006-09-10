#!/bin/bash
# $Id: mkindex.sh,v 1.3 2006-09-10 17:49:17 mitch Exp $

ls *.jpg *.png | sort | while read FILE; do

    echo -e "${FILE}\t$(#(echo ${FILE:0:3} | sed 's/^0*//')) $(cat ${FILE%.???}.txt)"

done > index
