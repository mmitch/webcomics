#!/bin/sh
# $Id: batch.sh,v 1.8 2002-12-24 12:02:00 mitch Exp $

# $Log: batch.sh,v $
# Revision 1.8  2002-12-24 12:02:00  mitch
# --use-proxy=off bei wget entfernt.
#
# Revision 1.7  2002/12/24 11:51:49  mitch
# Ende mit RC=2, wenn kein neues Bild geladen wurde.
#
# Revision 1.6  2002/12/04 16:33:58  mitch
# Umgeschrieben auf Errant Story
# Kopierquelle: Exploitation Now
#
# Revision 1.5  2002/01/12 12:10:58  mitch
# Jetzt werden auch .jpg-Bilder erkannt
#
# Revision 1.4  2001/12/23 10:28:29  mitch
# Cronjob-Fehlermeldung hoffentlich beseitigt
# (warum tritt die Meldung beim händischen Start nicht auf?)
#
# rm: cannot remove `20011222.gif': No such file or directory
#
# Revision 1.3  2001/12/22 12:47:01  mitch
# Fertig geladene Bilder werden scheibgeschützt
#
# Revision 1.2  2001/12/20 18:50:02  mitch
# Lädt automatisch alles ab dem letzten (bzw. ersten) Strip herunter
#
# Revision 1.1  2001/12/20 18:28:31  mitch
# Initial revision
#

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{8}.(gif|jpg)' | tail -1 | cut -c 1-8)
if [ -z ${LATEST} ]; then
    LATEST=20021101  # first strip ever
fi

YS=$(echo ${LATEST} | cut -c 1-4)
MS=$(echo ${LATEST} | cut -c 5-6)
DS=$(echo ${LATEST} | cut -c 7-8)

YE=$(date +%Y)
ME=$(date +%m)
DE=$(date +%d)

echo reading from ${YS}-${MS}-${DS} up to ${YE}-${ME}-${DE}

PAGEBASE="http://www.errantstory.com/d/"
PICBASE="http://www.errantstory.com/comics/es"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

YS=$(echo ${YS} | sed 's/^0*//')
MS=$(echo ${MS} | sed 's/^0*//')
DS=$(echo ${DS} | sed 's/^0*//')

while true; do
    DATE=$(printf %04d%02d%02d ${YS} ${MS} ${DS})

    echo -n "fetching ${DATE}: "
    EXT=gif
    FILE=${DATE}.${EXT}
    wget --user-agent="${USERAGENT}" --referer=${PAGEBASE}${DATE}.html -O ${FILE} ${PICBASE}${DATE}.${EXT} 2> /dev/null

    if [ -s ${FILE} ]; then
	echo OK
	chmod -w ${FILE}
	EXITCODE=0
    else
	test -w ${FILE} && rm ${FILE}
	EXT=jpg
	FILE=${DATE}.${EXT}
	wget --user-agent="${USERAGENT}" --referer=${PAGEBASE}${DATE}.html -O ${FILE} ${PICBASE}${DATE}.${EXT} 2> /dev/null
	if [ -s ${FILE} ]; then
	    echo OK
	    chmod -w ${FILE}
	    EXITCODE=0
	else
	    test -w ${FILE} && rm ${FILE}
	    echo nok
	fi
    fi
    
    if [ ${DATE} = ${YE}${ME}${DE} ]; then
	exit ${EXITCODE}
    fi

    DS=$((${DS} + 1))
    if [ ${DS} -gt 31 ]; then
	DS=1
	MS=$((${MS} + 1))
	if [ ${MS} -gt 12 ]; then
	    MS=1
	    YS=$((${YS} + 1))
	fi
    fi

done
