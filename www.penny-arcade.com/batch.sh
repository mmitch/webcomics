#!/bin/bash
# $Id: batch.sh,v 1.12 2006-01-19 19:13:17 mitch Exp $

EXITCODE=2

if [ -r minimum.year ]; then
    read STOP < minimum.year
else
    STOP=0
fi

USERAGENT=--user-agent="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

wget -qO - "${USERAGENT}" http://www.penny-arcade.com/archive \
| grep -A 1 '<option value=".*"' \
| perl batch.pl \
| (
    while read DATE2; do
	read TITLE
	read SPACER
	
	DATE=${DATE2:6:4}${DATE2:0:2}${DATE2:3:2}
	YEAR=${DATE2:6:4}
	
	if [ ${YEAR} -lt ${STOP} ]; then
	    echo "stopped because of minimum.year"
	    exit ${EXITCODE}
	fi
	
	REFERRER=--referer="http://www.penny-arcade.com/comic/${YEAR}/${DATE2:0:2}/${DATE2:3:2}"

	if [ -s ${DATE}.[gj][ip][fg] ]; then
	    echo "[${DATE}] skipped"
	else
	    echo -n "[${DATE}]: fetching $TITLE   "
	    
	    FILE=${DATE}.jpg
	    TEXT=${DATE}.txt
	    wget -qO ${FILE} "${USERAGENT}" ${REFERRER} http://www.penny-arcade.com/images/${YEAR}/${DATE}h.jpg
	    if file -i ${FILE} | grep -q image ; then
		echo "$TITLE" > ${TEXT}
		echo "OK"
		EXITCODE=0
	    else
		rm -f ${FILE}
 	        # Try .gif
		FILE=${DATE}.gif
		wget -qO ${FILE} "${USERAGENT}" ${REFERRER} http://www.penny-arcade.com/images/${YEAR}/${DATE}h.gif
		if file -i ${FILE} | grep -q image ; then
		    echo "$TITLE" > ${TEXT}
		    echo "OK"
		    EXITCODE=0
		else
		    rm -f ${FILE}
		    echo "failed!!!"
		fi
	    fi
	fi
    done
    
    exit ${EXITCODE}
)

EXITCODE=$?

echo "fini"

exit ${EXITCODE}
