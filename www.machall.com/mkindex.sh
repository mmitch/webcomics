#!/bin/bash
# $Id: mkindex.sh,v 1.1 2005-02-21 14:22:27 ikari Exp $

# $Log: mkindex.sh,v $
# Revision 1.1  2005-02-21 14:22:27  ikari
# Wenn man nicht geduldig genug testet... Explizite Zahlenbasis fuer
# arithmetische Expansion angegeben
#
# Revision 1.1  2002/07/14 10:05:07  mitch
# Initial revision
#

ls *.jpg | sort | while read FILE; do

    echo -e "${FILE}"

done > index
