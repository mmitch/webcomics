#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{6}.[gif|jpg]' | tail -1 | cut -c 1-8)
if [ -z ${LATEST} ]; then
    LATEST=20050404  # first strip ever
fi

YS=${LATEST:0:4}
MS=${LATEST:4:2}
DS=${LATEST:6:2}

TODAY=$(date +%Y%m%d)
YE=${TODAY:0:4}
ME=${TODAY:4:2}
DE=${TODAY:6:2}

echo reading from ${YS}-${MS}-${DS} up to  ${YE}-${ME}-${DE}

PAGEBASE="http://www.girlgeniusonline.com/comic.php?date="
PICBASE="http://www.girlgeniusonline.com/ggmain/strips"
USERAGENT="Mozilla/4.0 (compatible; MSIE 6.0; Linux) Opera 6.0  [en]"

YS=$(echo ${YS} | sed 's/^0*//')
MS=$(echo ${MS} | sed 's/^0*//')
DS=$(echo ${DS} | sed 's/^0*//')

fetch()
{
    echo -n "fetching ${DATE}: "
    HTMLFILE=${DATE}.html
    FILE=${DATE}.[gjp][inp][fg]

    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else
	wget --user-agent="${USERAGENT}" -qO${HTMLFILE} ${PAGEBASE}${DATE}
	PICURL=`< ${HTMLFILE} sed -ne "s@.*\\(${PICBASE}/ggmain[0-9]\\{8\\}[a-z]*\....\\)[\"'].*@\\1@;T;p"`
#	ENCODING=`< ${HTMLFILE} sed -ne "s@.*content=\"text/html; charset=\\([^\"]*\\).*@\\1@;T;p"`
	test -z "${ENCODING}" && ENCODING="iso-8859-1"
#	TITLE=`iconv -f ${ENCODING} ${HTMLFILE} | sed -ne "s@.*' selected>\\([^<]*\\).*@\\1@;T;p"`
	TITLE=`sed -ne "s@.*' selected>\\([^<]*\\).*@\\1@;T;p" ${HTMLFILE}`
	EXT=${PICURL:(-3)}
	IMGFILE=${DATE}.${EXT}
	TXTFILE=${DATE}.txt
	if [ "${PICURL}" = "" ]; then
	    echo nok: `head -1 ${HTMLFILE}`
	else
	    wget --user-agent="${USERAGENT}" --referer=${PAGEBASE}/${DATE} -qO${IMGFILE} ${PICURL}
	    if [ "$(file -bi ${IMGFILE})" = "text/html" ]; then
	        rm ${IMGFILE}
	    fi

	    if [ -s ${IMGFILE} ]; then
	        echo OK $TITLE
	        chmod -w ${IMGFILE}
	        test -w ${HTMLFILE} && rm ${HTMLFILE}
	        echo $TITLE > ${TXTFILE}
	        EXITCODE=0
	    else
	        test -w ${IMGFILE} && rm ${IMGFILE}
	        echo nok
	    fi
	fi
    fi
}

## fetch just one strip
if [ "$1" ] ; then
    DATE="$1"
    echo fetching only $DATE
    fetch
    exit ${EXITCODE}
fi

while true; do
    DATE=$(printf %04d%02d%02d ${YS} ${MS} ${DS})
    DOW=$(date -d "$DATE" +%w)

    # Slavishly updated monday, wednesday, friday
    if [ "${DOW}" != "" ]; then
        if [ ${DOW} -eq 1 -o \
             ${DOW} -eq 3 -o \
             ${DOW} -eq 5 ]; then
            fetch
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
