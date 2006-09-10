#!/bin/bash
# $Id: mkindex.sh,v 1.2 2006-09-10 17:48:38 mitch Exp $

ls *.jpg | sort | while read FILE; do

    echo -e "${FILE}\t$(#(echo ${FILE:0:3} | sed 's/^0*//')) $(cat ${FILE%.???}.txt)"

done > index
