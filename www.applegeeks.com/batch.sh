#!/bin/sh
# $Id: batch.sh,v 1.1 2003-10-04 13:10:42 mitch Exp $

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{6}.jpg' | tail -n 1 | cut -c 1-6 | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://www.applegeeks.com/comic_archive/view.php?comic="
PICBASE="http://www.applegeeks.com/comics/issue"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

while true; do
    DATE=$(printf %06d ${LATEST})

    echo -n "fetching ${DATE}: "
    EXT=jpg
    FILE=${DATE}.${EXT}

    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer=${PAGEBASE}${LATEST} -qO${FILE} ${PICBASE}${LATEST}.${EXT}
	
	if [ -s ${FILE} ]; then
	    echo OK
	    chmod -w ${FILE}
	    EXITCODE=0
	else
	    test -w ${FILE} && rm ${FILE}
	    echo nok
	    exit ${EXITCODE}
	fi
    fi
    
    LATEST=$((${LATEST} + 1))

done
