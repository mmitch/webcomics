#!/bin/bash
# $Id: batch.sh,v 1.8 2003-02-16 13:35:10 mitch Exp $

# $Log: batch.sh,v $
# Revision 1.8  2003-02-16 13:35:10  mitch
# Die Datei "minimum.year" kann angelegt werden und stoppt das
# Download-Skript am dort enthaltenen Jahr (damit können dann
# Unterordner pro Jahr realisiert werden -- sonst würde das Skript immer
# alles runterladen)
#
# Revision 1.7  2003/02/16 13:27:44  mitch
# Verzicht auf sed (externer Prozess!) zur Datumsumwandlung
#
# Revision 1.6  2003/02/16 13:24:40  mitch
# .txt-Datei braucht das Datum nicht zu enthalten, ist sonst doppelt
# Runterladen der hochqualitativen Bilder statt der kleinen (h statt l).
#
# Revision 1.5  2003/02/12 13:25:21  ikari
# Bugfix: Versehentlich die falsche Datei committet.
#
# Revision 1.6  2002/12/24 12:02:01  mitch
# --use-proxy=off bei wget entfernt.
#
# Revision 1.5  2002/12/24 11:56:50  mitch
# Ende mit RC=2, wenn kein neues Bild geladen wurde.
#
# Revision 1.4  2002/07/27 17:26:48  mitch
# leere .gif-Dateien werden gelöscht
#
# Revision 1.3  2002/07/14 10:14:12  mitch
# liest jetzt auch die .jpg-Dateien ein
#
# Revision 1.2  2002/01/25 15:43:45  mitch
# Adapted to new Freshmeat page
#
# Revision 1.1  2001/10/20 19:04:50  mitch
# Initial revision
#

EXITCODE=2

if [ -r minimum.year ]; then
    read STOP < minimum.year
else
    STOP=0
fi

wget -O - http://www.penny-arcade.com/search.php 2>/dev/null \
| grep "<option value=\".*</option>" \
| sed -e "s/<\/select>$//" \
     -e "s/<\/option>//" \
| perl batch.pl \
| while read DATE2; do
    read TITLE
    read SPACER

    DATE=${DATE2:0:4}${DATE2:5:2}${DATE2:8:2}
    YEAR=${DATE2:0:4}

    if [ ${YEAR} -lt ${STOP} ]; then
	echo "stopped because of minimum.year"
	exit ${EXITCODE}
    fi

    if [ -s ${DATE}.[gj][ip][fg] ]; then
	echo "[$DATE] skipped"
    else
	echo -n "[$DATE2]: fetching $TITLE   "
	
	FILE=${DATE}.gif
	TEXT=${DATE}.txt
	wget -O ${FILE} --referer=http://www.penny-arcade.com/view.php?date=${DATE2}\
             http://www.penny-arcade.com/images/${YEAR}/${DATE}h.gif 2>/dev/null
	if [ -s ${FILE} ]; then
	    echo "$TITLE" > ${TEXT}
	    echo "OK"
	    EXITCODE=0
	else
	    rm -f ${FILE}
	    # Try .jpg
	    FILE=${DATE}.jpg
	    wget -O ${FILE} --referer=http://www.penny-arcade.com/view.php?date=${DATE2}\
                  http://www.penny-arcade.com/images/${YEAR}/${DATE}h.jpg 2>/dev/null
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
done
 
echo "fini"

exit ${EXITCODE}
