#!/bin/sh
# $Id: batch.sh,v 1.0 2003/12/23 00:22:02 Psycorama

# Taken the original script of Freefall from mitch
# modded some bit an now it works for Dorktower
# no versionnumbers, no updates(only if neccesary)


EXITCODE=2

X=$(ls | egrep 'dorktower[0-9]{3}.jpg' | tail -1 | cut -c 10-12)
if [ -z ${X} ]; then
    X=000  # first strip ever
fi

echo "last fetched is $X"

GETBASE="http://www.gamespy.com/comics/dorktower/images/comics"

while true ; do
    X=$(printf %03d $(( 10#$X + 1)))
    FILE=gamespy${X}.jpg
    NEWFILE=dorktower${X}.jpg
    echo -n "fetching $X: "

    wget -c -q ${GETBASE}/${FILE}

    if [ -s ${FILE} ]; then
	echo "OK"
	mv ${FILE} ${NEWFILE}	
	chmod -w ${NEWFILE}
	EXITCODE=0
    else
	rm -f ${FILE}
	rm -f ${NEWFILE}
	echo "nok"
	# skip known bad
	if [ $X = 031 ] ; then
	    :
	else
	    exit ${EXITCODE}
	fi
    fi
done

