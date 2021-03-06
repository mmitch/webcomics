#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep 'AS[0-9]{3}.jpg' | tail -n 1 | cut -c 3-5 | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://www.alpha-shade.com/0Comics"
PICBASE="http://www.alpha-shade.com/1Pages"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

while true; do

    echo -n "fetching ${LATEST}: "
    
    HTMLURL="${PAGEBASE}/pages.php"

    FILE="$(printf "AS%03d.jpg" "${LATEST}")"

    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer=${HTMLURL} -qO"${FILE}" "${PICBASE}/${FILE}"
	
	if [ -s ${FILE} ]; then

	    if [[ ! $(file -b --mime-type ${FILE}) =~ ^image/ ]]; then
		echo EMERGENCY STOP to prevent runaway download
		echo FILE IS NO IMAGE and server is too stupid to send HTTP 404
		rm ${FILE}
		exit ${EXITCODE}
	    fi
	    
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

