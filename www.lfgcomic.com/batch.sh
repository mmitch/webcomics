#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{3}-lfg[0-9]{4}.gif' | tail -n 1 | cut -c 1-3 | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://www.lfgcomic.com/page/"
PICBASE="http://www.lfgcomic.com/uploads/comics/"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

while true; do

    echo -n "fetching ${LATEST}: "
    
    FILENAME=$(printf lfg%04d.gif ${LATEST})

    echo -n "${FILENAME} "

    FILE=$(printf %03d-lfg%04d.gif ${LATEST} ${LATEST})

    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else
	SOURCE_FILE=`lynx --dump ${PAGEBASE}${LATEST}|grep .gif|perl -p -e s'/[\[\] ]//g'`
	wget --user-agent="${USERAGENT}" --referer=${HTMLURL} -qO"${FILE}" "${PICBASE}${SOURCE_FILE}"

	if [ -s ${FILE} ]; then
	    echo OK
	    chmod -w ${FILE}
	    LASTFILENAME="${FILENAME}"
	    EXITCODE=0
	else
	    test -w ${FILE} && rm ${FILE}
	    echo nok
	    rm -f "$TMPFILE"
	    exit ${EXITCODE}
	fi
    fi
    
    LATEST=$((${LATEST} + 1))

done

rm -f "$TMPFILE"
