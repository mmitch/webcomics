#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{4}.jpg' | tail -n 1 | cut -c 1-4 | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://www.collectedcurios.com/spiderandscorpion.html"
PICBASE="http://www.collectedcurios.com/"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

while true; do

    echo -n "fetching ${LATEST}: "
    
    FILENAME=$(printf SAS_%04d_Small.jpg ${LATEST})
    
    echo -n "${FILENAME} "
    
    FILE=$(printf %04d.jpg ${LATEST})

    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer=${HTMLURL} -qO"${FILE}" "${PICBASE}${FILENAME}"
	
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
