#!/bin/bash

BASEURL=http://www.applegeeks.com/lite/

wget -qO - $BASEURL \
| grep '<option value="' \
| sed -e 's:</option>.*$::' \
      -e 's:^.*" >::' \
| ( 
    EXITCODE=2
    while read LINE; do
	DATE=${LINE:0:10}
	TITLE=${LINE:13}
	NR=${DATE:0:4}${DATE:5:2}${DATE:8:2}
	if [ -s ${NR}.[gj][ip][fg] ]; then
	    echo "[$NR] skipped"
	else

	    COMICURL="${BASEURL}index.php?aglitecomic=${DATE}"
	    IDX=$(wget -qO - $COMICURL \
		| grep '<img src="strips/' \
		| sed -e 's:^.*"strips/::' \
		      -e 's:".*$::')

	    echo -n "[$NR]: fetching $DATE $TITLE   "
	    FILE=${NR}.${IDX#*.}
	    TEXT=${NR}.txt
	    wget -qO${FILE} --referer=$COMICURL ${BASEURL}strips/${IDX}
	    if [ -s ${FILE} ]; then
		echo "$DATE $TITLE" > ${TEXT}
		echo "OK"
		EXITCODE=0
	    else
		rm -f ${FILE}
		echo "failed!!!"
	    fi
	fi
    done
    exit ${EXITCODE}
)

EXITCODE=$?

echo "fini"

exit ${EXITCODE}
