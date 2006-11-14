#!/bin/bash
# $Id: mkindex.sh,v 1.1 2006-11-14 23:45:24 mitch Exp $

ls *.gif *.jpg | sort | while read FILE; do

    echo -e "${FILE}\t#${FILE:2:4}"

done > index
