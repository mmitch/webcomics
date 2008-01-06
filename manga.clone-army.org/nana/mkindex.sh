#!/bin/bash
# $Id: mkindex.sh,v 1.2 2005/07/06 19:25:25 mitch Exp $

ls *.jpg | sort | while read FILE; do

    echo -e "${FILE}\t"`echo ${FILE:10:3} | sed 's/^0*//'`

done > index
