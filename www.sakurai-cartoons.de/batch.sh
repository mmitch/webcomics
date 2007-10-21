#!/bin/bash
# $Id: batch.sh,v 1.2 2007-10-21 08:21:59 mitch Exp $

EXITCODE=2

LATEST=$(ls | egrep '^[0-9]{5}.*gif$' | tail -n 1 | cut -c 1-5 | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

STOP=$(wget -qO- www.sakurai-cartoons.de/actual.php3 | fgrep 'href=actual.php3?gross=' | head -1 | sed -e 's/^.*gross=//' -e 's/>.*$//')

echo reading from ${LATEST} up to ${STOP}

PAGEBASE="http://www.sakurai-cartoons.de/actual.php3?gross="
PICBASE="http://www.sakurai-cartoons.de/"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

while [ ${LATEST} -le ${STOP} ] ; do

    echo -n "fetching ${LATEST}: "
    
    HTMLURL="${PAGEBASE}${LATEST}"

    LINE="$(wget -qO- "${HTMLURL}" | fgrep '<body ' | recode l1..utf8)"
    DATE="$(echo $LINE | sed -e 's|^.*<h1>||' -e 's|</h1>.*||' )"
    TITLE="$(echo $LINE | sed -e 's|^.*<font size=+1>||' -e 's|</font>.*||' )"
    IMAGE="$(echo $LINE | sed -e 's|^.*<img src=||' -e 's| .*||' )"
    
    FILE="$(printf "%05d.gif" "${LATEST}")"

    if [ -e "${FILE}" -a ! -w "${FILE}" ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer=${HTMLURL} -qO"${FILE}" "${PICBASE}${IMAGE}"
	
	if [ -s "${FILE}" -a $( stat -c %s "${FILE}" ) -gt 100 ]; then
	    echo OK
	    chmod -w ${FILE}
	    echo "$DATE $TITLE" > ${FILE%.gif}.txt
	    chmod -w ${FILE%.gif}.txt
	    EXITCODE=0
	else
	    test -w ${FILE} && rm ${FILE}
	    echo nok
	fi
    fi
    
    LATEST=$((${LATEST} + 1))

done

