#!/bin/bash
# $Id: mkindex.sh,v 1.2 2006-10-15 15:48:56 mitch Exp $

ls *.gif *.jpg | sort | while read FILE; do

    echo -e "${FILE}\t"$(cat ${FILE:0:6}.txt)

done > index
