#!/bin/sh
# $Id: batch.sh,v 1.2 2001-10-20 16:52:58 mitch Exp $

# $Log: batch.sh,v $
# Revision 1.2  2001-10-20 16:52:58  mitch
# JPG-if-Abfrage war falschrum
#
# Revision 1.1  2001/10/20 16:33:01  mitch
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

REFBASE="http://sexylosers.com/comic.cgi?"
GETBASE="http://sexylosers.com/image.cgi?sl"

for X in `seq $1 $2`; do
    X=`printf "%03d" $X`
    echo -n "fetching $X: "
    wget --use-proxy=off --referer=${REFBASE}${X} -O pic${X}.gif ${GETBASE}$X.gif 2> /dev/null
    if [ -s pic${X}.gif ]; then
	echo "$X is gif --> OK"
    else
	rm pic${X}.gif
	wget --use-proxy=off --referer=${REFBASE}${X} -O pic${X}.jpg ${GETBASE}$X.jpg 2> /dev/null
	if [ -s pic${X}.jpg ]; then
	    echo "$X is jpg --> OK"
	else
	    echo "PROBLEM: $X is neither gif nor jpg --> NOK"
	fi
    fi
done

echo "fini"
