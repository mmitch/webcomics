#!/bin/sh
# $Id: batch.sh,v 1.5 2002-12-24 11:56:50 mitch Exp $

# $Log: batch.sh,v $
# Revision 1.5  2002-12-24 11:56:50  mitch
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

wget --use-proxy=off -O - http://www.megatokyo.com 2>/dev/null \
| grep "^<option value='.*</select>" \
| sed -e "s/<\/select>$//" \
      -e "s/<\/option>/\\
/g" \
| perl batch.pl \
| while read IDX; do
    read DATE
    read NR
    read TITLE
    read SPACER
    if [ -s ${NR}.[gj][ip][fg] ]; then
	echo "[$NR] skipped"
    else
	echo -n "[$NR]: fetching $DATE $TITLE   "
	FILE=${NR}.gif
	TEXT=${NR}.txt
	wget --use-proxy=off -O ${FILE} --referer=http://www.megatokyo.com http://www.megatokyo.com/strips/${IDX}.gif 2>/dev/null
	if [ -s ${FILE} ]; then
	    echo "[$NR] $DATE $TITLE" > ${TEXT}
	    echo "OK"
	    EXITCODE=0
	else
	    rm -f ${FILE}
	    # Try .jpg
	    FILE=${NR}.jpg
	    wget --use-proxy=off -O ${FILE} --referer=http://www.megatokyo.com http://www.megatokyo.com/strips/${IDX}.jpg 2>/dev/null
	    if [ -s ${FILE} ]; then
		echo "[$NR] $DATE $TITLE" > ${TEXT}
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
