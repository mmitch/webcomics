#!/bin/bash
# $Id: batch.sh,v 1.2 2005-02-21 22:07:30 mitch Exp $

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{8}.(gif|jpg)' | tail -1 | cut -c 1-8)
if [ -z ${LATEST} ]; then
    # only the last month's archive is online!
    # this will probably break with non-GNU-date
    LATEST=$(date +%Y%m%d -d "1 month ago")
fi

X=${LATEST}
BASEURL="http://www.dilbert.com/comics/dilbert/archive/"
CURRENT=$(date +%Y%m%d)

echo "Fetching from ${LATEST} to ${CURRENT}."

while [ "${CURRENT}" -gt "${X}" ] ; do

    X=$((10#${X}+1))
    Y=$(printf %05d ${X})
    echo -n "getting ${Y}: "
    URL="${BASEURL}?strip_id=${Y}"
    PICURL="${BASEURL}${PICURL1}${Y}${PICURL2}"
    wget -qO${Y}.jpg --referer=${URL} ${PICURL}
    if [ -s ${Y}.jpg ]; then
        echo "OK"
        EXITCODE=0
    else
        rm -f ${Y}.jpg
        echo "fetch failed!!!"
        exit ${EXITCODE}
    fi

done

exit ${EXITCODE}
