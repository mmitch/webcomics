#!/bin/bash
# $Id: mkindex.sh,v 1.1 2003-07-28 10:34:54 mitch Exp $

ls *.[gj][ip][fg] | sort | while read FILE; do

    echo -e "${FILE}\t${FILE:4:2}.${FILE:2:2}.20${FILE:0:2}"

done > index
