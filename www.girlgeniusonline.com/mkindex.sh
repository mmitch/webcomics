#!/bin/bash
# $Id: mkindex.sh,v 1.1 2006-07-24 10:21:46 mitch Exp $

ls *.[gj][ip][fg] | sort | while read FILE; do

    echo -e "${FILE}\t${FILE:6:2}.${FILE:4:2}.${FILE:0:4}"

done > index
