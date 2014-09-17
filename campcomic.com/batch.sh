#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep '^[0-9]{6}\.url' | tail -n 1 | cut -c 1-6  | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
    NEXTURL=http://campcomic.com/comic/dear-mom
else
    LINK=$(printf %06d.url ${LATEST})
    read NEXTURL < ${LINK}
fi

echo reading from ${LATEST}

PAGEBASE=http://campcomic.com/
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"
TMPFILE=tmp.html

while true; do

    echo -n "fetching ${LATEST}: "
    
    FILE=$(printf %06d.jpg ${LATEST})
    TEXT=$(printf %06d.txt ${LATEST})
    LINK=$(printf %06d.url ${LATEST})

    PAGEURL="${NEXTURL}"
    
    wget -qO${TMPFILE} --user-agent="${USERAGENT}" "${PAGEURL}"
    
    TITLETEXT="$(grep -A1 '<div class="comicMeta">' ${TMPFILE} | tail -n 1 | sed -e 's,^.*<h1>,,' -e 's,</h1>.*,,')"
    PICURL="$(grep -A1 '<div id="comic">' ${TMPFILE} | tail -n 1 | sed -e 's,^.*src=",,' -e 's,".*,,')"
    NEXTURL="$(grep '<a class="btn btnNext"' ${TMPFILE} | tail -n 1 | sed -e 's/^.*href="//' -e 's/".*//')"

#    case ${LATEST} in
#	186|209)
#	    echo "very special - skipping!"
#	    LATEST=$((${LATEST} + 1))
#	    continue
#	    ;;
#    esac

    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer=${HTMLURL} -qO${FILE} "${PICURL}"

	if [ -n "${NEXTURL}" -a -s ${FILE} -a $(file -b --mime-type ${FILE}) != 'text/html' ]; then
	    echo "${TITLETEXT}" > ${TEXT}
	    echo "${PAGEURL}" > ${LINK}
	    chmod -w ${FILE}
	    echo OK
	    EXITCODE=0
	else
	    test -w ${FILE} && rm ${FILE}
	    echo nok
	    rm -f "$TMPFILE"
	    exit ${EXITCODE}
	fi
    fi
    
    if [ ${NEXTURL} = ${PAGEBASE} ]; then
	echo at end: stop.
	rm -f "$TMPFILE"
	exit ${EXITCODE}
    fi
    
    LATEST=$((${LATEST} + 1))

done

rm -f "$TMPFILE"
