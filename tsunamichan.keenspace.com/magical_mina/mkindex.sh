#!/bin/bash
# $Id: mkindex.sh,v 1.1 2003-03-06 19:14:48 mitch Exp $

# $Log: mkindex.sh,v $
# Revision 1.1  2003-03-06 19:14:48  mitch
# Initial source import.
# Kopierbasis: www.penny-arcade.com/mkindex.sh,v 1.3
#

ls *.[gj][ip][fg] | sort | while read FILE; do

    TITLEFILE=${FILE:0:8}.txt
    if [ -s ${TITLEFILE} ] ; then
	read TEXT < ${TITLEFILE}
	echo -e "${FILE}\t${FILE:6:2}.${FILE:4:2}.${FILE:0:4}: ${TEXT}"
    else
	echo -e "${FILE}\t${FILE:6:2}.${FILE:4:2}.${FILE:0:4}"
    fi

done > index
