#!/bin/sh
# $Id: batch.sh,v 1.4 2006-10-15 15:48:56 mitch Exp $
# needs lynx

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{6}.(gif|jpg)' | tail -n 1 | cut -c 1-6 | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://www.michael-fredrich.de/Cartoons/"
PICBASE="$PAGEBASE"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

while true; do
    DATE=$(printf %03d ${LATEST})

    echo -n "fetching ${DATE}: "
    EXT=jpg
    FILE=000${DATE}.${EXT}
    ANNEX=
    HTML=${PAGEBASE}${DATE}.htm

    # blöde Sonderfälle
    if [ "$DATE" = "112" ]; then
	ANNEX=o
    fi
    if [ "$DATE" = "328" ]; then
	ANNEX=a
	# MÖÖP - hier gibt's zusätzlich b und c!!! TODO TODO TODO keine Lust
    fi


    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else

        # Überschrift besorgen
	LANG=C lynx --dump ${HTML} \
	    | perl -ne 's/^\s+//;if(! /^\[/){s/^\s+//;print}' \
	    | iconv -f iso8859-1 -t utf8 \
	    | (
	    read LINE1
	    read LINE2
	    TITLE=

	    while [ "${LINE2}" != 'References' ]; do
		TITLE="${TITLE} ${LINE1}"
		LINE1="${LINE2}"
		read LINE2
	    done
	    
	    if [ "${TITLE}" ]; then
		TITLE="${LINE1} - ${TITLE}"
	    else
		TITLE="${LINE1}"
	    fi
	    echo ${TITLE} > ./000${DATE}.txt
	)

	wget --user-agent="${USERAGENT}" --referer={$HTML} -qO${FILE} ${PICBASE}${DATE}${ANNEX}.${EXT}
	
	if [ -s ${FILE} ]; then
	    echo OK
	    chmod -w ${FILE}
	    EXITCODE=0
	else
	    test -w ${FILE} && rm ${FILE}

	    EXT=gif
	    FILE=000${DATE}.${EXT}

	    wget --user-agent="${USERAGENT}" --referer=${HTML} -qO${FILE} ${PICBASE}${DATE}${ANNEX}.${EXT}
	
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
