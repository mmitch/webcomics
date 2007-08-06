#!/bin/sh
# $Id: batch.sh,v 1.9 2007-08-06 19:13:35 mitch Exp $
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


    if [ \( -e 000${DATE}.gif -a ! -w 000${DATE}.gif \) -o \( -e 000${DATE}.jpg -a ! -w 000${DATE}.jpg \) ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer=${HTML} -qO${FILE} ${PICBASE}${DATE}${ANNEX}.${EXT}
	
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
    
    # ___ Überschrift besorgen ___
    LANG=C lynx --dump ${HTML} \
	| perl -ne 's/^\s+//;if(! /^\[/){s/^\s+//;print}' \
	| iconv -f iso8859-1 -t utf8 \
	| (
	TITLE=
	read LINE

	if [ "${LINE}" ] ; then
	    while [ "${LINE:2:1}" != '.' -o "${LINE:5:3}" != '.20' ]; do
		TITLE="${TITLE}${LINE} "
		read LINE
	    done
	fi
	
	if [ "${TITLE}" ]; then
	    TITLE="${LINE} - ${TITLE}"
	else
	    TITLE="${LINE}"
	fi
	echo ${TITLE} > ./000${DATE}.txt
    )
    # ^^^ Ende Überschrift ^^^


    
    LATEST=$((${LATEST} + 1))

done
