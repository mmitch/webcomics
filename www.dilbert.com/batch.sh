#!/bin/bash
# $Id: batch.sh,v 1.4 2005-02-21 22:27:56 mitch Exp $

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{8}.(gif|jpg)' | tail -1 | cut -c 1-8)
if [ -z ${LATEST} ]; then
    # only the last month's archive is online!
    LATEST=$(date +%Y%m%d -d "1 month ago")
fi

X=${LATEST}
BASEURL="http://www.dilbert.com/comics/dilbert/archive/"
CURRENT=$(date +%Y%m%d)

echo "Fetching from ${LATEST} to ${CURRENT}."

while [ "${CURRENT}" -gt "${X}" ] ; do

    X=$(date -d "${X} + 1 day" +%Y%m%d)

    echo -n "getting ${X}: "


    PAGEURL=${BASEURL}dilbert-${X}.html
    PICNAME=$(
	wget -qO- ${PAGEURL} |
	grep 'ALT="Today' | 
	sed -e 's,^.*IMG SRC="*/comics/dilbert/archive/images/,,' -e 's," .*$,,'
    )
    PICURL=${BASEURL}images/${PICNAME}
    EXT=$( echo ${PICNAME} | sed 's/^.*\.//' )
    wget -qO${X}.${EXT} --referer=${PAGEURL} ${PICURL}
    if [ -s ${X}.${EXT} ]; then
        echo "OK"
        EXITCODE=0
    else
        rm -f ${X}.{$EXT}
        echo "fetch failed!!!"
        exit ${EXITCODE}
    fi

done

exit ${EXITCODE}
