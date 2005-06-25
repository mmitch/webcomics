#!/bin/bash
# $Id: mkindex.sh,v 1.1 2005-06-25 15:09:39 mitch Exp $

ls *.jpg *.gif *.jpeg | sort | while read FILE; do

    echo -e "${FILE}\t${FILE:4:2}.${FILE:2:2}.${FILE:0:2}"

done > index
