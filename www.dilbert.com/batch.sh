#!/bin/bash
# $Id: batch.sh,v 1.1 2005-02-21 21:58:42 mitch Exp $

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{5}.(gif|jpg)' | tail -1 | cut -c 1-5)
if [ -z ${LATEST} ]; then
    LATEST=0  # first strip ever - 1
fi

X=${LATEST}

BASEURL="http://www.machall.com/"
PICURL1="index.php?do_command=show_strip&strip_id="
PICURL2="&auth=01101-10010-01010-10101-11111"

CURRENT=$( wget -qO - ${BASEURL} \
         | grep show_strip   \
         | sed -e 's/.*id=//;s/&auth.*//')
CURRENT=$(printf %05d ${CURRENT})
Y=$((10#${X}+1))
Y=$(printf %05d ${Y})

echo "Fetching from ${Y} to ${CURRENT}."

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
