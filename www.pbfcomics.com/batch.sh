#!/bin/sh
# $Id: batch.sh,v 1.6 2007-12-03 21:31:32 mitch Exp $

STARTURL=http://www.pbfcomics.com

wget -qO- ${STARTURL} \
| fgrep 'href="?cid=' \
| sed -e 's/^.*href="//' -e 's:</a>.*::' -e 's/#/ /' -e 's/">/ /' -e "s,?cid=,${STARTURL}/archive_b/," \
| tac \
| ( 
    EXITCODE=2
    while read URL TITLE; do
	NUMBER=$(printf %04d $( echo ${URL:38:3} | sed -e 's/^0*//') )
	FILENAME="${URL#*-}"
	FILE=${NUMBER}-${FILENAME}
	if [ -s "$FILE" ]; then
	    echo "[$NUMBER] skipped"
	else
	    echo -n "[$NUMBER]: fetching $TITLE   "
	    TEXT=${NUMBER}-${FILENAME%.*}.txt
	    wget -qO${FILE} --referer=${STARTURL} "${URL}"
	    if [ -s "${FILE}" ]; then
		echo "$URL [$NUMBER] $TITLE" > ${TEXT}
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
