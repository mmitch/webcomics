#!/bin/bash
# $Id: mkindex.sh,v 1.2 1997-01-04 06:55:06 mitch Exp $

# $Log: mkindex.sh,v $
# Revision 1.2  1997-01-04 06:55:06  mitch
# Titel übernehmen, wenn vorhanden
#
# Revision 1.1  1997/01/04 02:32:45  mitch
# Initial source import.
# Kopierbasis: www.errantstory.com/mkindex.sh Rev. 1.1
#

ls *.[gj][ip][fg] | sort | while read FILE; do

    TITLEFILE=${FILE:0:8}.txt
    if [ -s ${TITLEFILE} ] ; then
	read TEXT < ${TITLEFILE}
	echo -e "${FILE}\t${TEXT}"
    else
	echo -e "${FILE}\t${FILE:6:2}.${FILE:4:2}.${FILE:0:4}"
    fi

done > index
