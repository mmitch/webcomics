#!/bin/bash
# $Id: mkindex.sh,v 1.1 2002-07-14 10:16:58 mitch Exp $

# $Log: mkindex.sh,v $
# Revision 1.1  2002-07-14 10:16:58  mitch
# Initial revision
#

ls *.[gj][ip][fg] | sort | while read FILE; do

    read TEXT < ${FILE:0:3}.txt
    echo -e "${FILE}\t${TEXT}"

done > index
