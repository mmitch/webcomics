#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{3}-.*.[jp][pn]g' | tail -n 1 | cut -c 1-3 | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://xkcd.com/"
PICBASE="http://imgs.xkcd.com/comics/"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"
TMPFILE=./tmp.html

while true; do

    echo -n "fetching ${LATEST}: "
    
    HTMLURL="${PAGEBASE}${LATEST}/"
    if ! wget -q -O"${TMPFILE}" --user-agent="${USERAGENT}" "${HTMLURL}" ; then
	echo nok
	rm -f "$TMPFILE"
	[ "${LATEST}" == 404 ] && LATEST=405 && continue
	exit ${EXITCODE}
    fi
    FILENAME=$(grep "src=\"${PICBASE}" "${TMPFILE}" | sed -e "s|^.*${PICBASE}||" -e 's/\.jpg".*$/.jpg/' -e 's/\.png".*$/.png/' -e 's/\.gif".*$/.gif/')
    LONGTEXT=$(grep "src=\"${PICBASE}" "${TMPFILE}" | sed -e 's/^.*title="//' -e 's/".*$//')
    TITLE=$(grep '<h1>' "${TMPFILE}" | sed -e 's|^.*<h1>||' -e 's|</h1>.*$||')
    
    echo -n "${FILENAME} "
    
    # test for big image (original filename contains "_small")
    if [[ ${FILENAME} == *_small.* ]] ; then
	FILENAME_SHORT="${FILENAME/_small./.}"
	if wget -qO/dev/null "${PICBASE}${FILENAME}" ; then
	    FILENAME="${FILENAME_SHORT}"
	    echo -n "...using big variant... "
	fi
    fi

    FILE="$(printf "%03d-%s" "${LATEST}" "${FILENAME}")"

    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer=${HTMLURL} -qO"${FILE}" "${PICBASE}${FILENAME}"
	
	if [ -s ${FILE} ]; then
	    echo OK
	    chmod -w ${FILE}
	    if [ "${LONGTEXT}" ] ; then 
		echo "${TITLE}<br><br>${LONGTEXT}" > "${FILE%.???}.txt"
		else
		echo "${TITLE}" > "${FILE%.???}.txt"
	    fi
	    EXITCODE=0
	else
	    test -w ${FILE} && rm ${FILE}
	    echo nok
	    exit ${EXITCODE}
	fi
    fi
    
    LATEST=$((${LATEST} + 1))

done

rm -f "$TMPFILE"
