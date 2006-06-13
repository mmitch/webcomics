#!/bin/bash
# $Id: mkindex.sh,v 1.1 2006-06-13 11:11:46 mitch Exp $

ls *.[gj][ip][fg] | sort | while read FILE; do

    NUMBER=${FILE%jpg}
    NUMBER=${NUMBER%gif}
    read TEXT < ${NUMBER}txt
    echo -e "${FILE}\t${TEXT}"

done > index
