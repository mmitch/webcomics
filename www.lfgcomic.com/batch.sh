#!/bin/bash

EXITCODE=2

LATEST=$(find . -maxdepth 1 -type f -regex '.*\.\(gif\|jpg\)' | cut -c 3- | sort -n | tail -n 1 | cut -d- -f 1  | sed 's/^0*//')
if [ -z "${LATEST}" ]; then
    LATEST=1  # first strip ever
fi

echo "reading from ${LATEST}"

PAGEBASE="https://www.lfg.co/read/comic/"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

while true; do

    echo -n "fetching ${LATEST}: "
    
    FILEPREFIX=$(printf %03d-lfg%04d "${LATEST}" "${LATEST}")

    if [ -e "${FILEPREFIX}".gif ] && ! [ -w "${FILEPREFIX}".gif ]; then
	echo "skipping ${FILEPREFIX}.gif"
    elif [ -e "${FILEPREFIX}".jpg ] && ! [ -w "${FILEPREFIX}".jpg ]; then
	echo "skipping ${FILEPREFIX}.jpg"
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
	SOURCE_FILE="$(wget -qO- --user-agent="${USERAGENT}" "${HTMLURL}" | grep -A1 '<div id="comic-img">' | tail -n 1 | sed -e 's/^.*src="//' -e 's/".*//')"
	
	echo -n "${SOURCE_FILE##*/} "
	
	EXTENSION=${SOURCE_FILE##*.}
	FILE="${FILEPREFIX}.${EXTENSION}"
	wget --user-agent="${USERAGENT}" --referer="${HTMLURL}" -q -O"${FILE}" "${SOURCE_FILE}"

	if [ -s "${FILE}" ] && [ "$(file -b --mime-type "${FILE}")" != 'text/html' ]; then
	    echo OK
	    chmod -w "${FILE}"
	    EXITCODE=0
	else
	    test -w "${FILE}" && rm "${FILE}"
	    echo nok
	    exit ${EXITCODE}
	fi
    fi

    LATEST=$(( LATEST + 1 ))
    
done

