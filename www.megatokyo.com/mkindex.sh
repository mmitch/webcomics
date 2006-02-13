#!/bin/bash
# $Id: mkindex.sh,v 1.2 2006-02-13 21:50:27 mitch Exp $

# $Log: mkindex.sh,v $
# Revision 1.2  2006-02-13 21:50:27  mitch
# be more flexible with in-between-strips
#
# Revision 1.1  2002/07/14 10:16:58  mitch
# Initial revision
#

ls *.[gj][ip][fg] | sort | while read FILE; do

    NUMBER=${FILE%jpg}
    NUMBER=${NUMBER%gif}
    read TEXT < ${NUMBER}txt
    echo -e "${FILE}\t${TEXT}"

done > index
