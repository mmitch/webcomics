#!/bin/bash
# $Id: mkindex.sh,v 1.3 2002-12-22 21:41:36 mitch Exp $

# $Log: mkindex.sh,v $
# Revision 1.3  2002-12-22 21:41:36  mitch
# Wieder wie vorher, Teilbilder verhalten sich wie normale.
#
# Revision 1.2  2002/12/22 12:53:52  mitch
# Angepasse an Teilbilder
#
# Revision 1.1  2002/07/14 10:07:42  mitch
# Initial revision
#

ls pic*.[gj][ip][fg] | grep -v '^pic[0-9]*-' | sort | while read FILE; do

    echo -e "${FILE}\t[${FILE:3:3}]"

done > index
