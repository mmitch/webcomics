#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep '^[0-9]{6}\.jpg' | tail -n 1 | cut -c 1-6  | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://www.darklegacycomics.com/"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"
TMPFILE=tmp.html

while true; do

    echo -n "fetching ${LATEST}: "
    
    FILE=$(printf %06d.jpg ${LATEST})
    TEXT=$(printf %06d.txt ${LATEST})

    echo -n "${FILE} "

    case ${LATEST} in
	186|209)
	    echo "very special - skipping!"
	    LATEST=$((${LATEST} + 1))
	    continue
	    ;;
    esac

    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else

	HTMLURL=${PAGEBASE}${LATEST}
	wget -qO"${TMPFILE}" --user-agent="${USERAGENT}" ${HTMLURL}

	TITLE="$(grep -A1 '<title>' ${TMPFILE} | tail -n1)"
	SOURCE_FILE="$(grep '<img class="comic-image"' ${TMPFILE} | head -n 1 | sed -e 's/^.*src="//' -e 's/".*//')"

	if [ "${SOURCE_FILE:0:7}" != "http://" ]; then
	    SOURCE_FILE="${PAGEBASE}${SOURCE_FILE}"
	fi

	wget --user-agent="${USERAGENT}" --referer=${HTMLURL} -qO${FILE} "${SOURCE_FILE}"

	if [ -s ${FILE} -a $(file -b --mime-type ${FILE}) != 'text/html' ]; then
	    echo "${TITLE}" > ${TEXT}
	    chmod -w ${FILE}
	    echo OK
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
