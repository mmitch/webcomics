#!/bin/bash
# $Id: mkindex.sh,v 1.2 2005-06-25 17:20:41 mitch Exp $

ls *.jpeg | sort | while read FILE; do

    echo -e "${FILE}\t${FILE:4:2}.${FILE:2:2}.${FILE:0:2}"

done > index
