#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{8}.(gif|jpg)' | tail -1 | cut -c 1-8)
if [ -z ${LATEST} ]; then
	# first strip online (at time of writing)
	LATEST=19981231
fi

X=${LATEST}
BASEURL="http://www.dilbert.com"
CURRENT=$(date +%Y%m%d)
TMP=pic.tmp

echo "Fetching from ${LATEST} to ${CURRENT}."

while [ "${CURRENT}" -gt "${X}" ] ; do

    X=$(date -d "${X:0:4}-${X:4:2}-${X:6:2} +1 day" +%Y%m%d)

    echo -n "getting ${X}: "

    PAGEURL=${BASEURL}/fast/${X:0:4}-${X:4:2}-${X:6:2}/
    IMGTAG=$(
	wget -qO- ${PAGEURL} |
	    grep '<img.* class="img-responsive'
       )
    PICURL=$(
	echo $IMGTAG |
	    sed -e 's,^.* src=",,' -e 's," .*$,,'
	  )
    ALTTEXT=$(
	echo $IMGTAG |
	    sed -e 's,^.* alt=",,' -e 's," .*$,,'
	  )
    if [ "$PICURL" = '/dyn/str_strip/default_th.gif' ] ; then
	echo "new picture not ready yet"
	exit ${EXITCODE}
    fi
    EXT=gif
    wget -qO${TMP} --referer=${PAGEURL} ${PICURL}
    if [ -s ${TMP} ]; then
	mv ${TMP} ${X}.${EXT}
	echo "$ALTTEXT" > ${X}.txt
        echo "OK"
        EXITCODE=0
    else
        rm -f ${TMP}
        echo "fetch failed!!!"
        exit ${EXITCODE}
    fi

done

exit ${EXITCODE}
