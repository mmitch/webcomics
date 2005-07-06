#!/bin/sh
# $Id: batch.sh,v 1.2 2005-07-06 19:24:38 mitch Exp $

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{6}.png' | tail -n 1 | cut -c 1-6 | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://manga.clone-army.org/t42r.php?page="
PICBASE="http://manga.clone-army.org/t42r//tomoyo"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

while true; do
    DATE=$(printf %03d ${LATEST})

    echo -n "fetching ${DATE}: "
    EXT=png
    FILE=000${DATE}.${EXT}

    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer=${PAGEBASE}${LATEST} -qO${FILE} ${PICBASE}${DATE}.${EXT}
	
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
