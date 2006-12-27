#!/bin/sh
# $Id: batch.sh,v 1.2 2006-12-27 21:29:17 mitch Exp $

EXITCODE=2

LATEST=$(ls | egrep '^[0-9]{4}-[0-9]{4}-[0-9]{2}-[0-9]{2}.gif$' | tail -n 1 | cut -c 1-4 | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://sinfest.net/archive_page.php?comicID="
PICBASE="http://sinfest.net/comikaze/comics/"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

while true; do

    FILENAME=$(wget -qO- "$PAGEBASE$LATEST" \
	| grep "$PICBASE" \
	| sed -e "s,^.*src=\"${PICBASE},," -e 's/".*$//' \
	)

    echo -n "fetching ${LATEST} / ${FILENAME:0:10}: "
    FILE="$(printf %04d $LATEST)-$FILENAME"

    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer="${PAGEBASE}${LATEST}" -qO"${FILE}" "${PICBASE}${FILENAME}"
	
	if [ -s ${FILE} ]; then
	    echo OK
	    chmod -w ${FILE}
	    EXITCODE=0
	else
	    test -w ${FILE} && rm ${FILE}
	    echo nok
	    # skip known broken comics
	    if [ ${LATEST} != 669 ] ; then
		exit ${EXITCODE}
	    fi
	fi
    fi
    
    LATEST=$((${LATEST} + 1))

done
