#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{6}.jpg' | tail -1 | cut -c 1-6)
if [ -z ${LATEST} ]; then
    LATEST=010501  # first strip ever
fi

YS=${LATEST:0:2}
MS=${LATEST:2:2}
DS=${LATEST:4:2}

TODAY=$(date +%y%m%d)
YE=${TODAY:0:2}
ME=${TODAY:2:2}
DE=${TODAY:4:2}

echo reading from ${YS}-${MS}-${DS} up to ${YE}-${ME}-${DE}

PAGEBASE="http://www.nichtlustig.de/html"
PICBASE="http://www.nichtlustig.de/comics/full"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

YS=$(echo ${YS} | sed 's/^0*//')
MS=$(echo ${MS} | sed 's/^0*//')
DS=$(echo ${DS} | sed 's/^0*//')

while true; do
    DATE=$(printf %02d%02d%02d ${YS} ${MS} ${DS})

    echo -n "fetching ${DATE}: "
    EXT=jpg
    FILE=${DATE}.${EXT}

    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer=${PAGEBASE}/${DATE}.html -qO${FILE} ${PICBASE}/${DATE}.${EXT}
	
	if [ -s ${FILE} ]; then
	    echo OK
	    chmod -w ${FILE}
	    EXITCODE=0
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
