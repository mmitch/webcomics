#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{3}[0-9]?-.*.[jp][pn]g' | sort -n | tail -n 1 | cut -f 1 -d - | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="https://xkcd.com/"
PICBASE="//imgs.xkcd.com/comics/"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"
TMPFILE=./tmp.html

while true; do

    # SKIP VERY SPECIAL COMICS
    case ${LATEST} in
	1350|1416|1525|1608|1663|2198)
	    echo "skipping ${LATEST}..."
	    LATEST=$((${LATEST} + 1))
	    continue
	    ;;
    esac

    echo -n "fetching ${LATEST}: "
    
    HTMLURL="${PAGEBASE}${LATEST}/"
    if ! wget -q -O"${TMPFILE}" --user-agent="${USERAGENT}" "${HTMLURL}" ; then
	echo nok
	rm -f "$TMPFILE"
	[ "${LATEST}" == 404 ] && LATEST=405 && continue
	exit ${EXITCODE}
    fi
    FILENAME=$(grep "src=\"${PICBASE}" "${TMPFILE}" | sed -e "s|^.*src=\"${PICBASE}||" -e 's/\.jpg".*$/.jpg/' -e 's/\.png".*$/.png/' -e 's/\.gif".*$/.gif/' | head -n 1)
    LONGTEXT=$(grep "src=\"${PICBASE}" "${TMPFILE}" | sed -e 's/^.*title="//' -e 's/".*$//' | head -n 1)
    TITLE=$(grep '<div.*id="ctitle".*>' "${TMPFILE}" | sed -e 's|^.*id="ctitle">||' -e 's|</div.*$||')
    
    echo -n "${FILENAME} "
    
    # test for big image (original filename contains "_small")
    if [[ ${FILENAME} == *_small.* ]] ; then
	FILENAME_SHORT="${FILENAME/_small./.}"
	if wget -qO/dev/null https:"${PICBASE}${FILENAME}" ; then
	    FILENAME="${FILENAME_SHORT}"
	    echo -n "...using big variant... "
	fi
    fi

    # remove path, if present (e.g. comic #1331)
    FILE="${FILENAME##*/}"

    FILE="$(printf "%03d-%s" "${LATEST}" "${FILE}")"

    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer=${HTMLURL} -qO"${FILE}" https:"${PICBASE}${FILENAME}"
	
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
