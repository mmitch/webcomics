#!/bin/sh
# $Id: batch.sh,v 1.7 2002-08-21 21:28:49 mitch Exp $

# $Log: batch.sh,v $
# Revision 1.7  2002-08-21 21:28:49  mitch
# Automatisches Herunter aller noch nicht geladenen Bilder auf einen Schlag
#
# Revision 1.6  2002/02/17 20:34:33  mitch
# Läuft wieder nach Umzug zu keenspace
#
# Revision 1.5  2001/12/20 17:25:22  mitch
# Tarnung: "wget" wird nicht mehr als User-Agent akzeptiert, wir sind
#          jetzt "Opera"
#
# Revision 1.4  2001/10/29 20:31:15  mitch
# Es bleiben keine leeren Dateien mehr übrig
#
# Revision 1.3  2001/10/20 17:25:06  mitch
# printf gespart (wir haben GNU seq)
#
# Revision 1.2  2001/10/20 16:52:58  mitch
# JPG-if-Abfrage war falschrum
#
# Revision 1.1  2001/10/20 16:33:01  mitch
# Initial revision
#

X=$(ls | egrep 'pic[0-9]{3}.(gif|jpg)' | tail -1 | cut -c 4-6)
if [ -z ${X} ]; then
    X=000  # first strip ever (1 is added before downloading!)
fi

echo "last fetched: $X"

REFBASE="http://sexylosers.keenspace.com/"
GETBASE="http://sexylosers.keenspace.com/images/sl"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

while true; do
    X=$( printf %03d $(( 10#$X + 1 )))
    echo -n "fetching $X: "
    wget --user-agent="${USERAGENT}" --use-proxy=off --referer=${REFBASE}${X}.html -O pic${X}.gif ${GETBASE}$X.gif 2> /dev/null
    if [ -s pic${X}.gif ]; then
	echo "$X is gif --> OK"
    else
	rm -f pic${X}.gif
	wget --user-agent="${USERAGENT}" --use-proxy=off --referer=${REFBASE}${X}.html -O pic${X}.jpg ${GETBASE}$X.jpg 2> /dev/null
	if [ -s pic${X}.jpg ]; then
	    echo "$X is jpg --> OK"
	else
	    rm -f pic${X}.jpg
	    echo "PROBLEM: $X is neither gif nor jpg --> NOK"
	    exit 0
	fi
    fi
done

echo "fini"
