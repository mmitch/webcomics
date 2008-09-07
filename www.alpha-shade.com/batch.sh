#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep 'AS[0-9]{3}.jpg' | tail -n 1 | cut -c 3-5 | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://www.alpha-shade.com/www/picPages/"
PICBASE="http://www.alpha-shade.com/www/ASpages/"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

while true; do

    echo -n "fetching ${LATEST}: "
    
    HTMLURL="${PAGEBASE}HPages.htm"

    FILE="$(printf "AS%03d.jpg" "${LATEST}")"

    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer=${HTMLURL} -qO"${FILE}" "${PICBASE}${FILE}"
	
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

