#!/bin/sh
# $Id: batch.sh,v 1.3 2007-06-26 20:53:51 mitch Exp $
# needs lynx

EXITCODE=2

PAGEBASE="http://www.ruthe.de"
PICBASE="$PAGEBASE/gallery/cpg1410/albums/userpics/10001/strip_"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

LATEST=$(ls | egrep '[0-9]{6}.(gif|jpg)' | tail -n 1 | cut -c 1-6 | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

MAXIMUM=$( wget --user-agent="${USERAGENT}" -qO- ${PAGEBASE}/ | \
    egrep 'alt="strip_[0-9]+\.jpg' | \
    sed -e 's:^.*alt="strip_0*::' -e 's/.jpg.*//' \
)

echo reading from ${LATEST} to ${MAXIMUM}

[ -z ${MAXIMUM} ] && echo ruthe.batch: getting maximum failed && exit 1

while [ ${LATEST} -le ${MAXIMUM} ] ; do
    DATE=$(printf %04d ${LATEST})

    echo -n "fetching ${DATE}: "
    EXT=jpg
    FILE=00${DATE}.${EXT}
    ANNEX=
    HTML=${PAGEBASE}/gallery/cpg1410/displayimage.php

    if [ \( -e 00${DATE}.gif -a ! -w 00${DATE}.gif \) -o \( -e 00${DATE}.jpg -a ! -w 00${DATE}.jpg \) ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer=${HTML} -qO${FILE} ${PICBASE}${DATE}.${EXT}
	
	if [ -s ${FILE} ]; then
	    echo OK
	    chmod -w ${FILE}
	    EXITCODE=0

	else
	    test -w ${FILE} && rm ${FILE}

	    EXT=gif
	    FILE=00${DATE}.${EXT}

	    wget --user-agent="${USERAGENT}" --referer=${HTML} -qO${FILE} ${PICBASE}${DATE}.${EXT}
	
	    if [ -s ${FILE} ]; then
		echo OK
		chmod -w ${FILE}
		EXITCODE=0
	    else
		test -w ${FILE} && rm ${FILE}
		echo nok
		exit ${EXITCODE}
	    fi
	fi
    fi
    
    LATEST=$((${LATEST} + 1))

done
