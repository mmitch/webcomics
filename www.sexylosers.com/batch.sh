#!/bin/sh
# $Id: batch.sh,v 1.15 2002-12-24 12:02:02 mitch Exp $

# $Log: batch.sh,v $
# Revision 1.15  2002-12-24 12:02:02  mitch
# --use-proxy=off bei wget entfernt.
#
# Revision 1.14  2002/12/24 11:58:22  mitch
# Ende mit RC=2, wenn kein neues Bild geladen wurde.
#
# Revision 1.13  2002/12/22 21:40:52  mitch
# Die Einzelbilder werden zusammengebastelt.
#
# Revision 1.12  2002/12/22 21:01:00  mitch
# Keine ###PICPATH###-Platzhalter mehr, stattdessen originale Dateinamen
#
# Revision 1.11  2002/12/22 12:50:16  mitch
# Textblöcke werden in .htm gespeichert, nicht .html
#
# Revision 1.10  2002/12/22 12:48:39  mitch
# Abbruchbedingung eingebaut
#
# Revision 1.9  2002/12/22 12:44:46  mitch
# Auch das neue Format mit den geteilten Bildern stellt kein Problem
# mehr dar :->
#
# Revision 1.8  2002/09/18 11:42:49  mitch
# Keenspace wollte wieder dazwischenfunken, Skript angepasst
#
# Revision 1.7  2002/08/21 21:28:49  mitch
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

EXITCODE=2

X=$(ls | egrep 'pic[0-9]{3}.(gif|jpg)' | tail -1 | cut -c 4-6)
if [ -z ${X} ]; then
    X=000  # first strip ever (1 is added before downloading!)
fi

echo "last fetched: $X"

REFBASE="http://www.sexylosers.com/"
GETBASE="http://www.sexylosers.com/images/sl"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.1  [en]"

while true; do
    X=$( printf %03d $(( 10#$X + 1 )))
    PICTURE=$(
    	wget --user-agent="${USERAGENT}" --referer=${REFBASE} -O - ${REFBASE}${X}.html 2> /dev/null \
    	    | grep sl${X} \
    	    | sed -e 's/^.*SRC="http:/http:/' -e 's/".*$//'
    )

    if [ -z "${PICTURE}" ] ; then

	EXT=htm
	
	echo "fetching ${X}.${EXT}: "

	LINE=$(
	    wget --user-agent="${USERAGENT}" --referer=${REFBASE} --output-document=- ${REFBASE}${X}.html 2> /dev/null \
		| grep -i ^\<TABLE \
		| grep -i \</TABLE\>\$ \
		| grep -i IMG \
		| sed 's/ = /=/g'
	)

	if [ -z "${LINE}" ] ; then
	    echo "${X}.${EXT} --> NOK!  exiting."
	    exit ${EXITCODE}
	fi

	echo ${LINE} \
	    | perl -p -e 's/></>\n</g' \
	    | grep -i ^\<IMG \
	    | sed -e 's/^[^"]*"//' -e 's/"[^"]*//' \
	    | while read URL; do
	    FILE=$(basename $URL) 
	    echo getting partial $URL
	    rm -f ${FILE}
	    wget --user-agent="${USERAGENT}" --referer=${REFBASE}${X}.html -O pic${X}-$FILE ${URL} 2> /dev/null
	done
	
	IMGDIR=$(
	    dirname $(
		echo ${LINE} \
		    | perl -p -e 's/></>\n</g' \
		    | grep -i ^\<IMG \
		    | sed -e 's/^[^"]*"//' -e 's/"[^"]*//' \
		    | head -1
	    )
	)

	echo ${LINE} \
	    | sed -e "s,${IMGDIR}/,pic${X}-,g" \
	    > pic${X}.${EXT}

	echo "combining images"
	./puzzle.pl pic${X}.${EXT}
	rm -f pic${X}-*
	rm -f pic${X}.${EXT}
	mv converted.jpg pic${X}.jpg

	echo "${X}.${EXT} --> OK"
	EXITCODE=0

    else

	EXT=${PICTURE:$(( ${#PICTURE} -3 ))}
    
	echo -n "fetching ${X}.${EXT}: "
	wget --user-agent="${USERAGENT}" --referer=${REFBASE}${X}.html -O pic${X}.${EXT} ${PICTURE} 2> /dev/null
	if [ -s pic${X}.${EXT} ]; then
	    echo "${X}.${EXT} --> OK"
	    EXITCODE=0
	else
	    rm -f pic${X}.${EXT}
	    echo "${X}.${EXT} --> NOK!"
	fi

    fi
done

echo "fini"
