#!/bin/sh
# $Id: batch.sh,v 1.2 2002-01-25 15:43:45 mitch Exp $

# $Log: batch.sh,v $
# Revision 1.2  2002-01-25 15:43:45  mitch
# Adapted to new Freshmeat page
#
# Revision 1.1  2001/10/20 19:04:50  mitch
# Initial revision
#

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
    if [ -s ${NR}.gif ]; then
	echo "[$NR] skipped"
    else
	echo -n "[$NR]: fetching $DATE $TITLE   "
	FILE=${NR}.gif
	TEXT=${NR}.txt
	wget --use-proxy=off -O ${FILE} --referer=http://www.megatokyo.com http://www.megatokyo.com/strips/${IDX}.gif 2>/dev/null
	if [ -s ${FILE} ]; then
	    echo "[$NR] $DATE $TITLE" > ${TEXT}
	    echo "OK"
	else
	    rm -f ${FILE}
	    echo "failed!!!"
	fi
    fi
done

echo "fini"