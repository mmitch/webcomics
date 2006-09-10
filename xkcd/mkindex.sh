#!/bin/bash
# $Id: mkindex.sh,v 1.1 2006-09-10 17:34:39 mitch Exp $

ls *.jpg | sort | while read FILE; do

    echo -e "${FILE}\t$(#(echo ${FILE:0:3} | sed 's/^0*//')) $(cat ${FILE%.jpg}.txt)"

done > index
