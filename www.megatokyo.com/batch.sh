#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep '^[0-9]+\.(jpg|gif)$' | sort -n | cut -d . -f 1 | tail -1)
if [ -z ${LATEST} ]; then
    LATEST=0001  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://www.megatokyo.com"
PICBASE="http://www.megatokyo.com/strips"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

while true; do

    echo -n "fetching ${LATEST}: "
    
    HTMLURL="${PAGEBASE}/strip/${LATEST}"

    TITLE=$(wget -qO- "${HTMLURL}" | grep '<div id="title">' | sed -e 's:"</div>.*$::' -e 's/^.*<div id="title">"//')

    FILE="${LATEST}.png"

    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer="${HTMLURL}" -qO"${FILE}" "${PICBASE}/${FILE}"
	
	if [ -s "${FILE}" -a $( stat -c %s "${FILE}" ) -gt 100 ]; then
	    echo OK
	    chmod -w ${FILE}
	    echo "[${LATEST}] ${TITLE}" > "${LATEST}.txt"
	    EXITCODE=0
	else
	    
	    rm "${FILE}"
	    FILE="${LATEST}.jpg"
	    
	    if [ -e ${FILE} -a ! -w ${FILE} ]; then
		echo skipping
	    else
		
		wget --user-agent="${USERAGENT}" --referer="${HTMLURL}" -qO"${FILE}" "${PICBASE}/${FILE}"
	
		if [ -s "${FILE}" -a $( stat -c %s "${FILE}" ) -gt 100 ]; then
		    echo OK
		    chmod -w ${FILE}
		    echo "[${LATEST}] ${TITLE}" > "${LATEST}.txt"
		    EXITCODE=0
		else
		    
		    rm "${FILE}"
		    FILE="${LATEST}.gif"
		    
		    if [ -e ${FILE} -a ! -w ${FILE} ]; then
			echo skipping
		    else
			
			wget --user-agent="${USERAGENT}" --referer="${HTMLURL}" -qO"${FILE}" "${PICBASE}/${FILE}"
			
			if [ -s "${FILE}" -a $( stat -c %s "${FILE}" ) -gt 100 ]; then
			    echo OK
			    chmod -w ${FILE}
			    echo "[${LATEST}] ${TITLE}" > "${LATEST}.txt"
			    EXITCODE=0
			else
			    test -w ${FILE} && rm ${FILE}
			    echo nok
			    exit ${EXITCODE}
			fi
		    fi
		fi
	    fi
	fi
    fi
    
    LATEST=`printf "%04d" $((${LATEST} + 1))`

done

