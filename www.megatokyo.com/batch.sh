#!/bin/sh
# $Id: batch.sh,v 1.9 2006-02-13 21:51:50 mitch Exp $

wget -qO - http://www.megatokyo.com \
| grep "^<option value='.*</select>" \
| sed -e "s/<\/select>$//" \
      -e "s/<\/option>/\\
/g" \
| perl batch.pl \
| ( 
    EXITCODE=2
    while read IDX; do
	read DATE
	read NR
	read TITLE
	read SPACER
	if [ -s ${NR}.[gj][ip][fg] ]; then
	    echo "[$NR] skipped"
	else
	    echo -n "[$NR]: fetching $DATE $TITLE   "
	    FILE=${NR}.gif
	    TEXT=${NR}.txt
	    wget -qO${FILE} --referer=http://www.megatokyo.com http://www.megatokyo.com/strips/${IDX}.gif
	    if [ -s ${FILE} ]; then
		echo "[$NR] $DATE $TITLE" > ${TEXT}
		echo "OK"
		EXITCODE=0
	    else
		rm -f ${FILE}
	        # Try .jpg
		FILE=${NR}.jpg
		wget -qO${FILE} --referer=http://www.megatokyo.com http://www.megatokyo.com/strips/${IDX}.jpg
		if [ -s ${FILE} ]; then
		    echo "[$NR] $DATE $TITLE" > ${TEXT}
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
