#!/bin/bash
# $Id: mkindex.sh,v 1.1 2003-10-04 13:13:14 mitch Exp $

ls *.[gj][ip][fg] | sort | while read FILE; do

    echo -e "${FILE}\t"`echo ${FILE:0:6} | sed 's/^0*//'`

done > index
