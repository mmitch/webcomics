#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{5}.(gif|jpg)' | tail -1 | cut -c 1-5)
if [ -z ${LATEST} ]; then
    LATEST=0  # first strip ever - 1
fi

X=${LATEST}

BASEURL="http://www.machall.com/"
PICURL1="index.php?do_command=show_strip&strip_id="
PICURL2="&auth=01101-10010-01010-10101-11111"
TMP=deleteme.tmp
CURRENT=$( wget -qO - ${BASEURL} \
         | grep show_strip   \
         | sed -e 's/.*id=//;s/&auth.*//')
CURRENT=$(printf %05d ${CURRENT})
Y=$((10#${X}+1))
Y=$(printf %05d ${Y})

if [ ${Y} -gt ${CURRENT} ]; then
    echo "Up to date. Not fetching anything."
    exit 1
else
    echo "Fetching from ${Y} to ${CURRENT}."
fi

while [ "${CURRENT}" -gt "${X}" ] ; do

    X=$((10#${X}+1))
    Y=$(printf %05d ${X})
    echo -n "getting ${Y}: "
    URL="${BASEURL}?strip_id=${X}"
    PICURL="${BASEURL}${PICURL1}${X}${PICURL2}"
    wget -qO${TMP} --referer=${URL} ${PICURL}
    if [ -s ${TMP} ]; then
        mv ${TMP} ${Y}.jpg
        echo "OK"
        EXITCODE=0
    else
        rm -f ${TMP}
        echo "fetch failed!"
        exit ${EXITCODE}
    fi

done

exit ${EXITCODE}
