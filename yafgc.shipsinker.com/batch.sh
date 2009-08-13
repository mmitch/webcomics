#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep '^[0-9]+\.jpg$' | sort -n | cut -d . -f 1 | sed 's/^0*//' | tail -1)
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://yafgc.shipsinker.com/index.php?strip_id"
PICBASE="http://yafgc.shipsinker.com/istrip_files/strips"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"
TMPFILE=".tmp"

while true; do

    echo -n "fetching ${LATEST}: "
    
    HTMLURL="${PAGEBASE}=${LATEST}"
    wget -qO "${TMPFILE}" --user-agent="${USERAGENT}" "${HTMLURL}"

    if ! grep -q "^Strip $LATEST:" "${TMPFILE}"; then
	rm -f "${TMPFILE}"
	echo nok
	exit ${EXITCODE}
    fi

    TITLE=$(grep "^Strip $LATEST:" .tmp | sed -e "s/^Strip ${LATEST}: //" -e 's!</font.*!!')
    FILE=$(grep "^<img src=\"istrip_files/strips/" .tmp | sed -e 's!^.*/strips/!!' -e 's/".*//')
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

