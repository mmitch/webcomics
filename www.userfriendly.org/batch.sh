#!/bin/sh
# $Id: batch.sh,v 1.1 2001-10-20 17:22:17 mitch Exp $

# $Log: batch.sh,v $
# Revision 1.1  2001-10-20 17:22:17  mitch
# Initial revision
#


if [ -z $1 ]; then
    echo "give DATE as [yyyymmdd]" 1>&2
    exit 1
fi

X=$1

echo -n "getting $X: "
URL=http://ars.userfriendly.org/cartoons/?id=${X}
PICURL=$(
wget --use-proxy=OFF -O - ${URL} 2>/dev/null | \
grep $X | grep "^<a href.*gif" | sed -e 's/gif.*$/gif/' -e 's/^.*src="//'
)
wget --use-proxy=OFF -O ${X}.gif --referer=${URL} ${PICURL} 2>/dev/null
if [ -s ${X}.gif ]; then
    echo "OK"
else
    rm -f ${X}.gif
    echo "failed!!!"
fi
