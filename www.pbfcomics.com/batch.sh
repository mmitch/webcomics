#!/bin/sh
# $Id: batch.sh,v 1.3 2006-11-20 22:28:34 mitch Exp $

STARTURL=http://www.pbfcomics.com

wget -qO- ${STARTURL} \
| egrep '<!--bold[0-9]+-->' \
| sed -e 's/^.*href="//' -e 's:</a>.*::' -e 's/#/ /' -e 's/">/ /' -e 's:?cid=:/archive/:' \
| tac \
| ( 
    EXITCODE=2
    while read URL NUMBER TITLE; do
	NUMBER=$(printf %04d $NUMBER)
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
