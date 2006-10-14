#!/bin/bash
# $Id: mkindex.sh,v 1.1 2006-10-14 15:35:30 mitch Exp $

ls *.gif *.jpg | sort | while read FILE; do

    echo -e "${FILE}\t"`echo ${FILE:0:6} | sed 's/^0*//'`

done > index
