#!/bin/sh
# $Id: batch.sh,v 1.1 2001-12-22 13:14:28 mitch Exp $

# $Log: batch.sh,v $
# Revision 1.1  2001-12-22 13:14:28  mitch
# Initial revision
#

if [ -z $1 ]; then
    echo "no FROM given" 1>&2
    exit 1
fi

if [ -z $2 ]; then
    echo "no TO given" 1>&2
    exit 1
fi

echo "fetching from $1 to $2"

REFBASE="http://www.purrsia.com/freefall"
GETBASE="http://www.purrsia.com/freefall"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

for X in $(seq -f %05g $1 $2); do
    echo -n "fetching $X: "
    FOLDER=ff$(( $( echo $X | cut -c 3 ) +1 ))00
    FILE=pic${X}.gif
    wget --user-agent="${USERAGENT}" --use-proxy=off --referer=${REFBASE}/${FOLDER}/fv${X}.htm -O ${FILE} ${GETBASE}/${FOLDER}/fv${X}.gif # 2> /dev/null
    if [ -s ${FILE} ]; then
	echo "OK"
	chmod -w ${FILE}
    else
	rm -f ${FILE}
	echo "nok"
    fi
done

echo "fini"
