#!/bin/sh
# $Id: batch.sh,v 1.18 2003-07-17 16:15:00 mitch Exp $

EXITCODE=2

X=$(ls | egrep 'pic[0-9]{3}.(gif|jpg)' | tail -1 | cut -c 4-6)
if [ -z ${X} ]; then
    X=000  # first strip ever (1 is added before downloading!)
fi

echo "last fetched: $X"

REFBASE="http://www.sexylosers.com/"
GETBASE="http://www.sexylosers.com/images/sl"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.1  [en]"

while true; do
    X=$( printf %03d $(( 10#$X + 1 )))
    PICTURE=$(
    	wget --user-agent="${USERAGENT}" --referer=${REFBASE} -qO- ${REFBASE}${X}.html \
    	    | grep sl${X} \
    	    | sed -e 's/^.*SRC.\?=.\?"http:/http:/' -e 's/".*$//'
    )

    if [ -z "${PICTURE}" ] ; then

	EXT=htm
	
	echo "fetching ${X}.${EXT}: "

	LINE=$(
	    wget --user-agent="${USERAGENT}" --referer=${REFBASE} -qO- ${REFBASE}${X}.html \
		| grep -i ^\<TABLE \
		| grep -i \</TABLE\>\$ \
		| grep -i IMG \
		| sed -e 's,</td><tr>,</td></tr><tr>,gi' \
		| sed 's/ = /=/g'
	)

	if [ -z "${LINE}" ] ; then
	    echo "${X}.${EXT} --> NOK!  exiting."
	    exit ${EXITCODE}
	fi

	echo ${LINE} \
	    | perl -p -e 's/></>\n</g' \
	    | grep -i ^\<IMG \
	    | sed -e 's/^[^"]*"//' -e 's/"[^"]*//' \
	    | while read URL; do
	    FILE=$(basename $URL) 
	    echo getting partial $URL
	    rm -f ${FILE}
	    wget --user-agent="${USERAGENT}" --referer=${REFBASE}${X}.html -qO pic${X}-$FILE ${URL}
	done
	
	IMGDIR=$(
	    dirname $(
		echo ${LINE} \
		    | perl -p -e 's/></>\n</g' \
		    | grep -i ^\<IMG \
		    | sed -e 's/^[^"]*"//' -e 's/"[^"]*//' \
		    | head -1
	    )
	)

	echo ${LINE} \
	    | sed -e "s,${IMGDIR}/,pic${X}-,g" \
	    > pic${X}.${EXT}

	echo "combining images"
	./puzzle.pl pic${X}.${EXT}
	rm -f pic${X}-*
	rm -f pic${X}.${EXT}
	mv converted.jpg pic${X}.jpg

	echo "${X}.${EXT} --> OK"
	EXITCODE=0

    else

	EXT=${PICTURE:$(( ${#PICTURE} -3 ))}
    
	echo -n "fetching ${X}.${EXT}: "
	wget --user-agent="${USERAGENT}" --referer=${REFBASE}${X}.html -qOpic${X}.${EXT} ${PICTURE}
	if [ -s pic${X}.${EXT} ]; then
	    echo "${X}.${EXT} --> OK"
	    EXITCODE=0
	else
	    rm -f pic${X}.${EXT}
	    echo "${X}.${EXT} --> NOK!"
	fi

    fi
done

echo "fini"
