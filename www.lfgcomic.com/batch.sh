#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{3}[0-9]*-lfg[0-9]{4}.gif' | tail -n 1 | cut -d- -f 1  | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://www.lfgcomic.com/page/"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

while true; do

    echo -n "fetching ${LATEST}: "
    
    FILENAME=$(printf lfg%04d.gif ${LATEST})

    echo -n "${FILENAME} "

    FILE=$(printf %03d-lfg%04d.gif ${LATEST} ${LATEST})

    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else

	# WTF - jumping page numbers?!
	case ${LATEST} in
	    647)
		NUMBER=2967
		;;
	    *)
		NUMBER=${LATEST}
		;;
	esac

	HTMLURL=${PAGEBASE}${NUMBER}/
	SOURCE_FILE="$(wget -qO- --user-agent="${USERAGENT}" ${HTMLURL} | grep -A1 '<div id="comic">' | tail -n 1 | sed -e 's/^.*src="//' -e 's/".*//')"
	wget --user-agent="${USERAGENT}" --referer=${HTMLURL} -qO${FILE} "${SOURCE_FILE}"

	if [ -s ${FILE} -a $(file -b --mime-type ${FILE}) != 'text/html' ]; then
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

