#!/bin/bash
# $Id: mkindex.sh,v 1.2 2002-12-22 12:53:52 mitch Exp $

# $Log: mkindex.sh,v $
# Revision 1.2  2002-12-22 12:53:52  mitch
# Angepasse an Teilbilder
#
# Revision 1.1  2002/07/14 10:07:42  mitch
# Initial revision
#

ls pic*.[gjh][ipt][fgm] | grep -v '^pic[0-9]*-' | sort | while read FILE; do

    echo -e "${FILE}\t[${FILE:3:3}]"

done > index
