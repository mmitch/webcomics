#!/bin/sh
# $Id: batch.sh,v 1.8 2003-01-13 17:51:49 mitch Exp $

# $Log: batch.sh,v $
# Revision 1.8  2003-01-13 17:51:49  mitch
# BufFix EXITCODE (Variable wurde in Subshell gesetzt -_-;)
#
# Revision 1.7  2002/12/24 13:53:05  mitch
# `wget -q' statt `wget 2>/dev/null'
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

wget -qO - http://www.megatokyo.com \
| grep "^<option value='.*</select>" \
| sed -e "s/<\/select>$//" \
      -e "s/<\/option>/\\
/g" \
| perl batch.pl \
| ( 
    EXITCODE=2
    while read IDX; do
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
	    wget -qO${FILE} --referer=http://www.megatokyo.com http://www.megatokyo.com/strips/${IDX}.gif
	    if [ -s ${FILE} ]; then
		echo "[$NR] $DATE $TITLE" > ${TEXT}
		echo "OK"
		EXITCODE=0
	    else
		rm -f ${FILE}
	        # Try .jpg
		FILE=${NR}.jpg
		wget -qO${FILE} --referer=http://www.megatokyo.com http://www.megatokyo.com/strips/${IDX}.jpg
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
    exit ${EXITCODE}
)

EXITCODE=$?

echo "fini"

exit ${EXITCODE}
