#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{3}.jpg' | tail -n 1 | cut -c 1-3 | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://inverloch.seraph-inn.com/viewcomic.php?page="
PICBASE="http://inverloch.seraph-inn.com/pages/"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

while true; do

    echo -n "fetching ${LATEST}: "
    
    HTMLURL="${PAGEBASE}${LATEST}"

    FILE="$(printf "%03d.jpg" "${LATEST}")"

    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer=${HTMLURL} -qO"${FILE}" "${PICBASE}${LATEST}.jpg"
	
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

