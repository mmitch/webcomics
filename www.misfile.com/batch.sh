#!/bin/bash
# $Id: batch.sh,v 1.1 2007-08-25 09:30:47 ranma Exp $

EXITCODE=2

LATEST=$(ls | egrep 'MF[0-9]{3}.jpg' | tail -n 1 | cut -c 3-5 | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://www.misfile.com/"
PICBASE="http://www.misfile.com/overlay.php?pageCalled="
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

while true; do

    echo -n "fetching ${LATEST}: "
    
    HTMLURL="${PAGEBASE}"

    echo -n "${FILENAME} "
    
    FILE="$(printf "MF%03d.jpg" "${LATEST}")"

    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer=${HTMLURL} -qO"${FILE}" "${PICBASE}${LATEST}"
	
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

