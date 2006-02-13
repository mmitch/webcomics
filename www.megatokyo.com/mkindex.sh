#!/bin/bash
# $Id: mkindex.sh,v 1.3 2006-02-13 21:51:50 mitch Exp $

ls *.[gj][ip][fg] | sort | while read FILE; do

    NUMBER=${FILE%jpg}
    NUMBER=${NUMBER%gif}
    read TEXT < ${NUMBER}txt
    echo -e "${FILE}\t${TEXT}"

done > index
