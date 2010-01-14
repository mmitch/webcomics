#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{8}.*[gif|jpg|png]' | tail -1 | cut -c 1-8)
if [ -z ${LATEST} ]; then
    LATEST=20050117  # first strip ever
fi

YS=${LATEST:0:4}
MS=${LATEST:4:2}
DS=${LATEST:6:2}

TODAY=$(date +%Y%m%d)
YE=${TODAY:0:4}
ME=${TODAY:4:2}
DE=${TODAY:6:2}

echo reading from ${YS}-${MS}-${DS} up to  ${YE}-${ME}-${DE}

PAGEBASE="http://www.shortpacked.com/d/"
PICBASE="http://www.shortpacked.com/comics/"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

YS=$(echo ${YS} | sed 's/^0*//')
MS=$(echo ${MS} | sed 's/^0*//')
DS=$(echo ${DS} | sed 's/^0*//')

while true; do
    DATE=$(printf %04d%02d%02d ${YS} ${MS} ${DS})

    echo -n "fetching ${DATE}: "

    if [ -e ${DATE}* -a ! -w ${DATE}* ]; then
	echo skipping
    else
	
	HTMLURL="${PAGEBASE}/${DATE}.html"
	FILE=$( \
	    wget -qO- --user-agent="${USERAGENT}" "${HTMLURL}" \
	    | grep "src=\"/comics/" \
	    | sed -e 's|^.*src="/comics/||' -e 's/\.gif".*$/.gif/' -e 's/\.jpg".*$/.jpg/' -e 's/\.png".*$/.png/'
	)
	
	if [ "${FILE:0:8}" != "${DATE}" ] ; then
	    echo nok
	else
	    
	    echo -n "${FILE} "
	    
	    wget --user-agent="${USERAGENT}" --referer=${HTMLURL} -qO${FILE} ${PICBASE}/${FILE}
	    if [ "$(file -bi ${FILE})" = "text/html" ]; then
		rm ${FILE}
	    fi
	    
	    if [ -s ${FILE} ]; then
		echo OK
		chmod -w ${FILE}
		EXITCODE=0
	    else
		test -w ${FILE} && rm ${FILE}
		echo nok
	    fi
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

