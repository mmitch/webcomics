#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep 'MF[0-9]{4}.jpg' | tail -n 1 | cut -c 3-6 | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://www.misfile.com/"
PICBASE="http://www.misfile.com/overlay.php?pageCalled="
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

# get current strip ID
MAXID="$(
    wget --user-agent="${USERAGENT}" -qO- "${PAGEBASE}" \
    | grep pageCalled= \
    | sed -e 's/^.*pageCalled=//' -e 's/[^0-9].*//'
    )"

while [ ${LATEST} -le ${MAXID} ]; do

    echo -n "fetching ${LATEST}: "
    
    HTMLURL="${PAGEBASE}"

    FILE="$(printf "MF%04d.jpg" "${LATEST}")"

    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer=${HTMLURL} -qO"${FILE}" "${PICBASE}${LATEST}"
	TYPE=$(file -bi "${FILE}")
	
	if [ -s "${FILE}" -a \
	     \( "${TYPE}" = "image/jpeg" -o \
	       "${TYPE}" = "image/png" \) -a \
	     $( stat -c %s "${FILE}" ) -gt 100 ]; then
	    echo OK
	    chmod -w ${FILE}
	    EXITCODE=0
	else
	    test -w ${FILE} && rm ${FILE}
	    echo nok
	fi
    fi
    
    LATEST=$((${LATEST} + 1))

done

exit ${EXITCODE}
