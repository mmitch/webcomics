#!/bin/bash
# $Id: mkindex.sh,v 1.1 1997-01-04 02:32:45 mitch Exp $

# $Log: mkindex.sh,v $
# Revision 1.1  1997-01-04 02:32:45  mitch
# Initial source import.
# Kopierbasis: www.errantstory.com/mkindex.sh Rev. 1.1
#

ls *.[gj][ip][fg] | sort | while read FILE; do

    echo -e "${FILE}\t${FILE:6:2}.${FILE:4:2}.${FILE:0:4}"

done > index
