#!/bin/bash
# $Id: mkindex.sh,v 1.1 2002-07-14 10:10:14 mitch Exp $

# $Log: mkindex.sh,v $
# Revision 1.1  2002-07-14 10:10:14  mitch
# Initial revision
#

ls pic*.gif | sort | while read FILE; do

    echo -e "${FILE}\t[${FILE:3:5}]"

done > index
