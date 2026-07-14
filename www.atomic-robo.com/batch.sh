#!/bin/bash

## beware: this script needs 'pup' from https://github.com/ericchiang/pup
# no more string-mangling to parse the HTML

EXITCODE=2

LATEST=$(ls | grep -E '^[0-9]{6}\.url' | tail -n 1 | cut -c 1-6  | sed 's/^0*//')
if [[ -z $LATEST ]]; then
    LATEST=1  # first strip ever
    NEXTURL=https://www.atomic-robo.com/atomicrobo/v1ch1-cover
else
    printf -v LINK %06d.url "$LATEST"
    read -r NEXTURL < "$LINK"
fi

echo "reading from $LATEST"

PAGEBASE=https://www.atomic-robo.com/atomicrobo/
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"
TMPFILE=tmp.html

while true; do

    echo -n "fetching ${LATEST}: "
    
    printf -v FILE %06d.jpg "$LATEST"
    printf -v TEXT %06d.txt "$LATEST"
    printf -v LINK %06d.url "$LATEST"

    PAGEURL=$NEXTURL
    
    echo -ne "$PAGEURL\\t "
    
    wget -qO${TMPFILE} --user-agent="$USERAGENT" "$PAGEURL"

    TITLETEXT=$(pup -f tmp.html 'img#cc-comic attr{title}')
    PICURL=$(pup -f tmp.html 'img#cc-comic attr{src}')
    NEXTURL=$(pup -f tmp.html 'a.cc-next attr{href}')
    
    if [[ -e $FILE && ! -w $FILE ]]; then
	echo skipping
    else

	wget --user-agent="$USERAGENT" --referer="$HTMLURL" -qO"$FILE" "$PICURL"

	if [[ $NEXTURL && -s $FILE && $(file -b --mime-type "$FILE") != text/html ]]; then
	    echo "$TITLETEXT" > "$TEXT"
	    echo "${PAGEURL}" > "$LINK"
	    chmod -w "${FILE}"
	    echo OK
	    EXITCODE=0
	else
	    [[ -w ${FILE} ]] && rm "${FILE}"
	    echo nok
	    rm -f "$TMPFILE"
	    exit ${EXITCODE}
	fi
    fi
    
    if [[ -z $NEXTURL || $NEXTURL = "$PAGEBASE" || $NEXTURL = $PAGEBASE/ ]]; then
	echo at end: stop.
	rm -f "$TMPFILE"
	exit ${EXITCODE}
    fi
    
    LATEST=$(( LATEST + 1))

done

rm -f "$TMPFILE"
