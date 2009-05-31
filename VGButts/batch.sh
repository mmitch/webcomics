#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep '^[0-9]+\.jpg$' | sort -n | cut -d . -f 1 | sed 's/^0*//' | tail -1)
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://orangebox.wwoec.com/vgbutts/"
PICBASE="http://orangebox.wwoec.com/vgbutts/images/content/"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"
TMPFILE=".tmp"

while true; do

    echo -n "fetching ${LATEST}: "
    
    HTMLURL="${PAGEBASE}/ep${LATEST}"
    wget -qO "${TMPFILE}" --user-agent="${USERAGENT}" "${HTMLURL}"

    if grep -q 'Invalid episode ID' "${TMPFILE}"; then
	rm -f "${TMPFILE}"
	echo nok
	exit ${EXITCODE}
    fi

    TITLE=$(grep /title "${TMPFILE}" | sed -e 's!^\s*!!' -e 's!\s*</title>.*!!')
    FILE=$(grep 'images/content/' "${TMPFILE}" | head -n 1 | sed -e 's!.*images/content/!!' -e 's!".*!!')
    NUMBER=$(printf %06d ${LATEST})
    FNAME=${NUMBER}.jpg

    rm -f "${TMPFILE}"

    if [ -e ${FNAME} -a ! -w ${FNAME} ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer="${HTMLURL}" -qO"${FNAME}" "${PICBASE}/${FILE}"
	
	if [ -s "${FNAME}" -a $( stat -c %s "${FNAME}" ) -gt 100 ]; then
	    echo OK
	    chmod -w ${FNAME}
	    echo "${TITLE}" > "${NUMBER}.txt"
	    EXITCODE=0
	else
	    test -w ${FNAME} && rm ${FNAME}
	    echo nok
	    exit ${EXITCODE}
	fi
    fi
    
    LATEST=$((${LATEST} + 1))

done

