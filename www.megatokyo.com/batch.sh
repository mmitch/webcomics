#!/bin/sh
# $Id: batch.sh,v 1.1 2001-10-20 19:04:50 mitch Exp $

# $Log: batch.sh,v $
# Revision 1.1  2001-10-20 19:04:50  mitch
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
	wget --use-proxy=off -O ${NR}.gif --referer=http://www.megatokyo.com http://www.megatokyo.com/strips/${IDX}.gif 2>/dev/null
	if [ -s ${NR}.gif ]; then
	    echo "[$NR] $DATE $TITLE" > ${NR}.txt
	    echo "OK"
	else
	    echo "failed!!!"
	fi
    fi
done

echo "fini"