#!/bin/bash
# $Id: mkindex.sh,v 1.1 2006-11-20 22:20:00 mitch Exp $

ls | egrep '\.(gif|jpg)$' | sort | while read FILE; do

    read URL TEXT < "${FILE%.*}.txt"
    echo -e "${FILE}\t${URL}\t${TEXT}"

done > index
