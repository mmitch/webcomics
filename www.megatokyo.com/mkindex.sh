#!/bin/bash
# $Id: mkindex.sh,v 1.4 2007-05-22 17:27:10 mitch Exp $

ls *.[gj][ip][fg] | sort -n | while read FILE; do

    NUMBER=${FILE%jpg}
    NUMBER=${NUMBER%gif}
    read TEXT < ${NUMBER}txt
    echo -e "${FILE}\t${TEXT}"

done > index
