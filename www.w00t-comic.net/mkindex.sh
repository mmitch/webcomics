#!/bin/bash
# $Id: mkindex.sh,v 1.1 2004-10-26 21:41:29 mitch Exp $

ls *.[gj][ip][fg] | sort | while read FILE; do

    echo -e "${FILE}\t${FILE:6:2}.${FILE:4:2}.${FILE:0:4}"

done > index
