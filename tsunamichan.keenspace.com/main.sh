#!/bin/bash
# $Id: main.sh,v 1.3 2003-03-07 21:30:34 mitch Exp $

# $Log: main.sh,v $
# Revision 1.3  2003-03-07 21:30:34  mitch
# Download der Liner's Notes.
#
# Revision 1.2  2003/03/06 19:32:27  mitch
# Angepasst auf tsunamichan
#
# Revision 1.1  2003/03/06 18:52:30  mitch
# Initial source import.
# Kopierbasis: www.penny-arcade.com/batch.sh,v 1.9
#

if [ -z "${INDEXURL}" ]; then
    echo "I am not to be called directly."
    exit 1
fi

EXITCODE=2

if [ -r minimum.year ]; then
    read STOP < minimum.year
else
    STOP=0
fi

wget -O - http://tsunamichan.keenspace.com/archive/${INDEXURL}.html 2>/dev/null \
| perl ../batch.pl \
| (
    while read DATE; do
	read TITLE
	read SPACER
	
	DATE2=${DATE:0:4}-${DATE2:4:2}-${DATE2:6:2}
	YEAR=${DATE:0:4}
	
	if [ ${YEAR} -lt ${STOP} ]; then
	    echo "stopped because of minimum.year"
	    exit ${EXITCODE}
	fi
	
	TEXT=${DATE}.txt

	if [ -s ${DATE}.[gj][ip][fg] ]; then
	    echo "[${DATE}] skipped"
	else
	    echo -n "[${DATE}]: fetching $TITLE   "
	    
	    FILE=${DATE}.jpg
	    wget -O ${FILE} --referer=http://tsunamichan.keenspace.com/d/${DATE}.html\
		http://tsunamichan.keenspace.com/comics/${DATE}.jpg 2>/dev/null
	    if [ -s ${FILE} ]; then
		echo "$TITLE" > ${TEXT}
		echo "OK"
		EXITCODE=0
	    else
		rm -f ${FILE}
 	        # Try .gif
		FILE=${DATE}.gif
		wget -O ${FILE} --referer=http://tsunamichan.keenspace.com/d/${DATE}.html\
		    http://tsunamichan.keenspace.com/comics/${DATE}.gif 2>/dev/null
		if [ -s ${FILE} ]; then
		    echo "$TITLE" > ${TEXT}
		    echo "OK"
		    EXITCODE=0
		else
		    rm -f ${FILE}
		    echo "failed!!!"
		fi
	    fi
	fi

	if [ -e ${TEXT} ]; then
	    HTML=${DATE}.htm

	    if [ ! -s ${HTML} ]; then
		echo -n "[${DATE}]: fetching liner's notes   "
		wget -O - http://tsunamichan.keenspace.com/d/${DATE}.html 2>/dev/null \
		    | perl ../extract.pl ${DATE} > ${HTML}
		if [ -s ${HTML} ]; then
		    echo "OK"
		else
		    rm -f ${HTML}
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
