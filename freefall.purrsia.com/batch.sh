#!/bin/sh
# $Id: batch.sh,v 1.6 2002-12-24 11:50:51 mitch Exp $

# $Log: batch.sh,v $
# Revision 1.6  2002-12-24 11:50:51  mitch
# Ende mit RC=2, wenn kein neues Bild geladen wurde.
#
# Revision 1.5  2002/12/04 16:14:50  mitch
# Neue URL eingebaut
#
# Revision 1.4  2002/08/21 21:23:18  mitch
# Automatisches Herunter aller noch nicht geladenen Bilder auf einen Schlag
#
# Revision 1.3  2001/12/22 13:34:39  mitch
# $FOLDER-Berechnung korrigiert
#
# Revision 1.2  2001/12/22 13:15:10  mitch
# STDERR von wget ausgeschaltet
#
# Revision 1.1  2001/12/22 13:14:28  mitch
# Initial revision
#

EXITCODE=2

X=$(ls | egrep 'pic[0-9]{5}.gif' | tail -1 | cut -c 4-8)
if [ -z ${X} ]; then
    X=0  # first strip ever
fi

echo "last fetched is $X"

REFBASE="http://freefall.purrsia.com"
GETBASE="http://freefall.purrsia.com"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

while true ; do
    X=$(printf %05d $(( 10#$X + 1)))
    FOLDER=ff$( echo $(( $( echo ${X} | sed 's/^0*//') +99 )) | cut -c 1 )00
    FILE=pic${X}.gif
    echo -n "fetching $X: "
    wget --user-agent="${USERAGENT}" --use-proxy=off --referer=${REFBASE}/${FOLDER}/fv${X}.htm -O ${FILE} ${GETBASE}/${FOLDER}/fv${X}.gif 2> /dev/null
    if [ -s ${FILE} ]; then
	echo "OK"
	chmod -w ${FILE}
	EXITCODE=0
    else
	rm -f ${FILE}
	echo "nok"
	exit ${EXITCODE}
    fi
done
