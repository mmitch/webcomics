#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{8}.(gif|jpg)' | tail -1 | cut -c 1-8)
if [ -z ${LATEST} ]; then
    LATEST=19981118  # first strip ever
fi

YS=$(echo ${LATEST} | cut -c 1-4)
MS=$(echo ${LATEST} | cut -c 5-6)
DS=$(echo ${LATEST} | cut -c 7-8)

YE=$(date +%Y)
ME=$(date +%m)
DE=$(date +%d)

echo reading from ${YS}-${MS}-${DS} up to ${YE}-${ME}-${DE}

PAGEBASE="http://www.penny-arcade.com/"
PICBASE="http://www.penny-arcade.com/images/"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

YS=$(echo ${YS} | sed 's/^0*//')
MS=$(echo ${MS} | sed 's/^0*//')
DS=$(echo ${DS} | sed 's/^0*//')

while true; do
    DATE=$(printf %04d%02d%02d ${YS} ${MS} ${DS})
    DATE2=$(printf %04d-%02d-%02d ${YS} ${MS} ${DS})

    echo -n "fetching ${DATE}: "

    EXT=gif
    FILE=${DATE}.${EXT}
    wget --user-agent="${USERAGENT}" --referer=${PAGEBASE}view.php?date=${DATE2} -O ${FILE} ${PICBASE}/${YS}/${DATE}h.${EXT} 2> /dev/null

    if [ -s ${FILE} ]; then
	echo OK
	chmod -w ${FILE}
	EXITCODE=0

	EXT=txt
	FILE=${DATE}.${EXT}
	wget --user-agent="${USERAGENT}" --referer=${PAGEBASE} -O - ${PAGEBASE}view.php3?date=${DATE2} 2> /dev/null \
	    | grep '&nbsp;&nbsp;' \
	    | grep '<b><i>.*</i></b>' \
	    | sed -e 's,^.*<b><i>,,' -e 's,</i></b>.*$,,' \
	    > ${FILE}

    else
	test -w ${FILE} && rm ${FILE}
	EXT=jpg
	FILE=${DATE}.${EXT}
        wget --user-agent="${USERAGENT}" --referer=${PAGEBASE}view.php?date=${DATE2} -O ${FILE} ${PICBASE}/${YS}/${DATE}h.${EXT} 2> /dev/null
	if [ -s ${FILE} ]; then
	    echo OK
	    chmod -w ${FILE}
	    EXITCODE=0

	    EXT=txt
	    FILE=${DATE}.${EXT}
	    wget --user-agent="${USERAGENT}" --referer=${PAGEBASE} -O - ${PAGEBASE}view.php3?date=${DATE2} 2> /dev/null \
		| grep '&nbsp;&nbsp;' \
		| grep '<b><i>.*</i></b>' \
		| sed -e 's,^.*<b><i>,,' -e 's,</i></b>.*$,,' \
		> ${FILE}

	else
	    test -w ${FILE} && rm ${FILE}
	    echo nok
	fi
    fi
    
    if [ ${DATE} = ${YE}${ME}${DE} ]; then
	exit ${EXITCODE}
    fi

    DS=$((${DS} + 1))
    if [ ${DS} -gt 31 ]; then
	DS=1
	MS=$((${MS} + 1))
	if [ ${MS} -gt 12 ]; then
	    MS=1
	    YS=$((${YS} + 1))
	fi
    fi

done