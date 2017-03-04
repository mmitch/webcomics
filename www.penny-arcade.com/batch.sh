#!/bin/sh

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

PAGEBASE="https://www.penny-arcade.com/comic/"
PICBASE="https://art.penny-arcade.com/photos/"
PICBASE2="https://www.penny-arcade.com/images/"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

YS=$(echo ${YS} | sed 's/^0*//')
MS=$(echo ${MS} | sed 's/^0*//')
DS=$(echo ${DS} | sed 's/^0*//')

TMPFILE=pennyarcade.tmp

while true; do

    DATE=$(printf %04d%02d%02d ${YS} ${MS} ${DS})
    URLDATE=$(printf %04d/%02d/%02d/ ${YS} ${MS} ${DS})

    echo -n "fetching ${DATE}: "

    if ! wget --max-redirect 0 --user-agent="${USERAGENT}" -qO${TMPFILE} ${PAGEBASE}${URLDATE}; then
	echo 'nok (no comic)'
    else

	PATTERN="src=\"https://(art\\.)?penny-arcade(\\.smugmug)?\\.com/(photos|Comics/Pa-comics)/"
	STRIPTITLE=$(grep -E "${PATTERN}" ${TMPFILE} | sed -e 's/^.*alt="//' -e 's/".*$//')
	FILENAME=$(grep -E "${PATTERN}" ${TMPFILE} | sed -e 's/^.*src="//' -e 's/".*$//')
	FULLURL=${PICBASE}${FILENAME}

	if [ -z ${FILENAME} ] ; then
	    PATTERN="src=\"${PICBASE2}"
	    STRIPTITLE=$(grep -E "${PATTERN}" ${TMPFILE} | sed -e 's/^.*alt="//' -e 's/".*$//')
	    FILENAME=$(grep -E "${PATTERN}" ${TMPFILE} | sed -e 's/^.*src="//' -e 's/".*$//')
	    if [[ $FILENAME =~ ^http ]] ; then
		FULLURL=${FILENAME}
	    else
		FULLURL=${PICBASE2}${FILENAME}
	    fi
	fi
	EXT=${FILENAME##*.}
	FILE=${DATE}.${EXT}

	if [ -e ${FILE} -a ! -w ${FILE} ]; then
	    echo skipping
	elif [ -z "${EXT}" ]; then
	    echo 'nok (no extension)'
	else

	    wget --user-agent="${USERAGENT}" --referer=${PAGEBASE}${URLDATE} -qO${FILE} ${FULLURL}
	
	    if [ -s ${FILE} ]; then
		echo OK
		echo "$STRIPTITLE" > ${DATE}.txt
		chmod -w ${FILE}
		EXITCODE=0
	    else
		test -w ${FILE} && rm ${FILE}
		echo 'nok (no image)'
	    fi
	fi
    fi
    
    if [ ${DATE} = ${YE}${ME}${DE} ]; then
	rm ${TMPFILE}
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
