#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep '^[0-9]{8}\.png$' | sort -n | cut -d . -f 1 | sed 's/^0*//' | tail -1)
if [ -z ${LATEST} ]; then
    LATEST=20080328  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://c.urvy.org/?date"
PICBASE="http://c.urvy.org/c"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

X=${LATEST}
TODAY=$(date +%Y%m%d)

if [ $(date -d "${X:0:4}-${X:4:2}-${X:6:2} + 7 day" +%Y%m%d) -gt ${TODAY} ] ; then
    # weekly comics, don't download when last comic is not at least 7 days old
    exit 0
fi


while [ "${TODAY}" -ge "${X}" ] ; do

    echo -n "fetching ${X}: "
    
    HTMLURL="${PAGEBASE}=${LATEST}"
    FNAME=${X}.png

    if [ -e ${FNAME} -a ! -w ${FNAME} ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer="${HTMLURL}" -qO"${FNAME}" "${PICBASE}/${X}.png"
	
	if [ -s "${FNAME}" -a $( stat -c %s "${FNAME}" ) -gt 100 ]; then
	    echo OK
	    chmod -w ${FNAME}
	    EXITCODE=0
	else
	    test -w ${FNAME} && rm ${FNAME}
	    echo nok
	fi
    fi

    X=$(date -d "${X:0:4}-${X:4:2}-${X:6:2} + 1 day" +%Y%m%d)
    
done

