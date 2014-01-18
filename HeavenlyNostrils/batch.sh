#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{8}.gif' | tail -n 1 | cut -c -8)
if [ -z ${LATEST} ]; then
    LATEST=20120422  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://www.gocomics.com/heavenly-nostrils"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"
TMPHTML=./html.tmp
TMPPIC=./pic.tmp

while [[ "${LATEST}" ]] ; do

    echo -n "fetching ${LATEST}: "
    
    HTMLURL="${PAGEBASE}/${LATEST:0:4}/${LATEST:4:2}/${LATEST:6:2}"
    wget -q -O "${TMPHTML}" --user-agent="${USERAGENT}" "${HTMLURL}"
    PICURL=$(grep feature_item "${TMPHTML}" | sed -e 's/^.*src="//' -e 's/".*$//')
    PICEXT=$(HEAD ${PICURL} | grep ^Content-Type: | sed -e 's,^.*/,,')

    case $PICEXT in
	gif)
	    ;;
	*)
	    echo "unknown PICEXT <${PICEXT}>" >&2
	    exit 1
    esac

    FILE="${LATEST}.${PICEXT}"

    echo -n "${FILE} "
    
    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else

	wget --user-agent="${USERAGENT}" --referer=${HTMLURL} -qO"${FILE}" "${PICURL}"
	
	if [ -s ${FILE} ]; then
	    echo OK
	    chmod -w ${FILE}
	    LASTFILENAME="${FILENAME}"
	    EXITCODE=0
	else
	    test -w ${FILE} && rm ${FILE}
	    echo nok
	    rm -f "$TMPFILE"
	    exit ${EXITCODE}
	fi
    fi
    
    LATEST=$(grep 'class="next"' html.tmp | head -n1 | sed -e 's/^.*href="//' -e 's/".*$//' | tr -cd 0-9)

done

rm -f "$TMPFILE"
