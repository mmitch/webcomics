#!/bin/sh
# $Id: batch.sh,v 1.7 2002-12-24 13:53:07 mitch Exp $

# $Log: batch.sh,v $
# Revision 1.7  2002-12-24 13:53:07  mitch
# `wget -q' statt `wget 2>/dev/null'
#
# Revision 1.6  2002/12/24 13:34:24  mitch
# Ordentliche Abbruchbedingung
#
# Revision 1.5  2002/12/24 13:18:50  mitch
# Holt automatisch alle Comics ab Beginn
#
# Revision 1.4  2002/07/27 17:40:13  mitch
# Funktioniert wieder -- fester Pfad für wget war böse
#
# Revision 1.3  2001/11/08 21:09:40  mitch
# wget mit Pfadangabe
#
# Revision 1.2  2001/10/20 17:29:43  mitch
# Meldung bei nicht existenter URL
#
# Revision 1.1  2001/10/20 17:22:17  mitch
# Initial revision
#

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{8}.(gif|jpg)' | tail -1 | cut -c 1-8)
if [ -z ${LATEST} ]; then
    LATEST=19971116  # first strip ever - 1
fi

X=${LATEST}
TODAY=$(date +%Y%m%d)

while [ "${TODAY}" -gt "${X}" ] ; do

    X=$(date -d "${X} + 1 day" +%Y%m%d)

    echo -n "getting ${X}: "
    URL="http://ars.userfriendly.org/cartoons/?mode=classic&id=${X}"
    PICURL=$(
	wget -qO - ${URL} | \
	    grep ${X} | \
	    grep "^<a href.*gif" |\
	    sed -e 's/gif.*$/gif/' -e 's/^.*src="//'
    )
    if [ -z ${PICURL} ]; then
	echo "wrong date?"
	exit ${EXITCODE}
    else
	wget -qO${X}.gif --referer=${URL} ${PICURL}
	if [ -s ${X}.gif ]; then
	    echo "OK"
	    EXITCODE=0
	else
	    rm -f ${X}.gif
	    echo "fetch failed!!!"
	    exit ${EXITCODE}
	fi
    fi

done

exit ${EXITCODE}
