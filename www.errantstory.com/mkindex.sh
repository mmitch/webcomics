#!/bin/bash
# $Id: mkindex.sh,v 1.1 2002-07-14 10:18:06 mitch Exp $

# $Log: mkindex.sh,v $
# Revision 1.1  2002-07-14 10:18:06  mitch
# Initial revision
#

ls *.[gj][ip][fg] | sort | while read FILE; do

    echo -e "${FILE}\t${FILE:6:2}.${FILE:4:2}.${FILE:0:4}"

done > index
