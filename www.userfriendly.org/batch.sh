#!/bin/sh
# $Id: batch.sh,v 1.3 2001-11-08 21:09:40 mitch Exp $

# $Log: batch.sh,v $
# Revision 1.3  2001-11-08 21:09:40  mitch
# wget mit Pfadangabe
#
# Revision 1.2  2001/10/20 17:29:43  mitch
# Meldung bei nicht existenter URL
#
# Revision 1.1  2001/10/20 17:22:17  mitch
# Initial revision
#

WGET=/usr/local/bin/wget

if [ -z ${1} ]; then
    echo "give DATE as [yyyymmdd]" 1>&2
    exit 1
fi

X=$1

echo -n "getting ${X}: "
URL=http://ars.userfriendly.org/cartoons/?id=${X}
PICURL=$(
${WGET} --use-proxy=OFF -O - ${URL} 2>/dev/null | \
grep ${X} | grep "^<a href.*gif" | sed -e 's/gif.*$/gif/' -e 's/^.*src="//'
)
if [ -z ${PICURL} ]; then
    echo "wrong date?"
else
    ${WGET} --use-proxy=OFF -O ${X}.gif --referer=${URL} ${PICURL} 2>/dev/null
    if [ -s ${X}.gif ]; then
	echo "OK"
    else
	rm -f ${X}.gif
	echo "fetch failed!!!"
    fi
fi
