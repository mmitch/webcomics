#!/bin/sh
# $Id: batch.sh,v 1.19 2003-09-09 20:58:02 mitch Exp $

EXITCODE=2

X=$(ls | egrep 'pic[0-9]{3}.(gif|jpg)' | tail -1 | cut -c 4-6)
if [ -z ${X} ]; then
    X=000  # first strip ever (1 is added before downloading!)
fi

echo "last fetched: $X"

REFBASE="http://www.sexylosers.com/"
GETBASE="http://www.sexylosers.com/comics/sl"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.1  [en]"

while true; do
    X=$( printf %03d $(( 10#$X + 1 )))

    echo -n "fetching ${X}: "

    EXT=jpg
    wget --user-agent="${USERAGENT}" --referer=${REFBASE}${X}.html -qOpic${X}.${EXT} ${GETBASE}${X}.${EXT}
    
    if [ -s pic${X}.${EXT} ] ; then
	echo "${X}.${EXT} --> OK"
	EXITCODE=0
    else

	rm -f pic${X}.${EXT}
	EXT=gif
	wget --user-agent="${USERAGENT}" --referer=${REFBASE}${X}.html -qOpic${X}.${EXT} ${GETBASE}${X}.${EXT}
	
	if [ -s pic${X}.${EXT} ] ; then
	    echo "${X}.${EXT} --> OK"
	    EXITCODE=0
	else
	    rm -f pic${X}.${EXT}
	    echo "${X}.${EXT} --> NOK!"
	    exit 1
	fi
	
    fi
done

echo "fini"
