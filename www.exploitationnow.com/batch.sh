#!/bin/sh
# $Id: batch.sh,v 1.1 2001-12-20 18:28:31 mitch Exp $

# $Log: batch.sh,v $
# Revision 1.1  2001-12-20 18:28:31  mitch
# Initial revision
#
#

if [ -z $1 ]; then
    echo "no DATE" 1>&2
    exit 1
fi
DATE=$1

if [ -z $2 ]; then
    DIR=next
else
    DIR=prev
fi


PAGEBASE="http://www.exploitationnow.com/d/"
PICBASE="http://www.exploitationnow.com/comics/rb"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

echo -n "fetching ${DATE}: "
wget --user-agent="${USERAGENT}" --use-proxy=off --referer=${PAGEBASE}${DATE}.html -O ${DATE}.gif ${PICBASE}${DATE}.gif 2> /dev/null

if [ -s ${DATE}.gif ]; then
    echo OK
else
    echo nok
fi

