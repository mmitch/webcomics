#!/bin/bash
# $Id: mkindex.sh,v 1.1 2002-07-14 10:07:42 mitch Exp $

# $Log: mkindex.sh,v $
# Revision 1.1  2002-07-14 10:07:42  mitch
# Initial revision
#

ls pic*.[gj][ip][fg] | sort | while read FILE; do

    echo -e "${FILE}\t[${FILE:3:3}]"

done > index
