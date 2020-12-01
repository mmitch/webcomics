#!/bin/bash

EXITCODE=2

LATEST=$(ls | grep -E '^[0-9]{6}\.url' | tail -n 1 | cut -c 1-6  | sed 's/^0*//')
if [ -z "${LATEST}" ]; then
    LATEST=1  # first strip ever
    NEXTURL=http://oglaf.com/cumsprite/
else
    LINK=$(printf %06d.url ${LATEST})
    read -r NEXTURL < "${LINK}"
fi

echo reading from ${LATEST}

PAGEBASE=http://oglaf.com
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"
TMPFILE=tmp.html

while true; do

    echo -n "fetching ${LATEST}: "
    
    FILE=$(printf %06d.jpg ${LATEST})
    TEXT=$(printf %06d.txt ${LATEST})
    LINK=$(printf %06d.url ${LATEST})

    PAGEURL="${NEXTURL}"
    TITLENAME="$(echo "$PAGEURL" | cut -d / -f 4,5 | sed -e 's,/$,,')"
    
    echo -ne "${PAGEURL}\\t "
    
    wget -qO${TMPFILE} --user-agent="${USERAGENT}" "${PAGEURL}"
    
    ALTTEXT="$(grep '^\s*alt=' ${TMPFILE} | cut -d \" -f 2)"
    TITLETEXT="$(grep '^\s*title=' ${TMPFILE} | cut -d \" -f 2)"
    PICURL="$(grep -F '<img id="strip"' ${TMPFILE} | sed -e 's/^.*<img id="strip"//' | cut -d \" -f 2)"
    NEXTURL="${PAGEBASE}$(sed 's/<a /\n<a /g'  ${TMPFILE} | grep '<a[^>]*rel="next"' | sed -e 's/^.*href="//' -e 's/".*$//')"

#    case ${LATEST} in
#	186|209)
#	    echo "very special - skipping!"
#	    LATEST=$((${LATEST} + 1))
#	    continue
#	    ;;
#    esac

    if [ -e "${FILE}" ] && [ ! -w "${FILE}" ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer="${HTMLURL}" -qO"${FILE}" "${PICURL}"

	if [ -n "${NEXTURL}" ] && [ -s "${FILE}" ] && [ "$(file -b --mime-type "${FILE}")" != 'text/html' ]; then
	    echo "${TITLENAME}<br><small>${TITLETEXT}<br><small>${ALTTEXT}</small></small>" > "${TEXT}"
	    echo "${PAGEURL}" > "${LINK}"
	    chmod -w "${FILE}"
	    echo OK
	    EXITCODE=0
	else
	    test -w "${FILE}" && rm "${FILE}"
	    echo nok
	    rm -f "$TMPFILE"
	    exit ${EXITCODE}
	fi
    fi
    
    if [ "{NEXTURL}" = ${PAGEBASE} ]; then
	echo at end: stop.
	rm -f "$TMPFILE"
	exit ${EXITCODE}
    fi
    
    LATEST=$(( LATEST + 1))

done

rm -f "$TMPFILE"
