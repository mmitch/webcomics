#!/bin/bash
# $Id: mkindex.sh,v 1.1 2005-03-27 21:06:18 mitch Exp $

ls *.gif *.jpeg | sort | while read FILE; do

    echo -e "${FILE}\t${FILE:4:2}.${FILE:2:2}.${FILE:0:2}"

done > index
