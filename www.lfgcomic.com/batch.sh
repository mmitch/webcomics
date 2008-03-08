#!/bin/bash
# $Id: batch.sh,v 1.2 2007-08-24 18:30:53 mitch Exp $

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{3}-.*.gif' | tail -n 1 | cut -c 1-3 | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://www.lfgcomic.com/page/"
PICBASE="http://archive.lfgcomic.com/"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"
TMPFILE=./tmp.html
LASTFILENAME=$(ls $(printf %03d $LATEST)-*.gif | cut -c 5-)

while true; do

    echo -n "fetching ${LATEST}: "
    
    HTMLURL="${PAGEBASE}${LATEST}"
    if ! wget -q -O"${TMPFILE}" --user-agent="${USERAGENT}" "${HTMLURL}" ; then
	echo nok
	rm -f "$TMPFILE"
	exit ${EXITCODE}
    fi
    FILENAME=$(grep "src=\"${PICBASE}" "${TMPFILE}" | sed -e "s|^.*${PICBASE}||" -e 's/\.jpg".*$/.jpg/' -e 's/\.png".*$/.png/' -e 's/\.gif".*$/.gif/')
    
    echo -n "${FILENAME} "
    
    FILE="$(printf "%03d-%s" "${LATEST}" "${FILENAME}")"

    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else

	if [ "${LASTFILENAME}" = "${FILENAME}" ] ; then
	    echo "abort, filename unchanged (prevent endless download)"
	    exit ${EXITCODE}
	fi

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
