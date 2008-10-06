#!/bin/sh

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{6}.(gif|jpg)' | tail -n 1 | cut -c 1-6 | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://www.giantitp.com/comics/"
PICBASE="http://www.giantitp.com/comics/images/"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"
export USERAGENT

while true; do
    DATE=$(printf %04d ${LATEST})

    echo -n "fetching ${DATE}: "
    HTML="${PAGEBASE}erf${DATE}.html"

    if [ \( -e 00${DATE}.gif -a ! -w 00${DATE}.gif \) -o \( -e 00${DATE}.jpg -a ! -w 00${DATE}.jpg \) ]; then
	echo skipping
    else

	export HTML

	FILENAME="$(
	    wget --user-agent="${USERAGENT}" -qO- "${HTML}" \
		| fgrep 'src="/comics/images' \
		| sed -e 's,^.*/comics/images/,,' -e 's,".*$,,'
	    )"
	
	FILE="00${DATE}.${FILENAME#*.}"

	wget --user-agent="${USERAGENT}" --referer="${HTML}" -qO"${FILE}" "${PICBASE}${FILENAME}"
	
	if [ -s ${FILE} ]; then
	    echo OK
	    chmod -w ${FILE}
	    EXITCODE=0
	else
	    test -w ${FILE} && rm ${FILE}
	    echo nok
	    exit ${EXITCODE}
	fi
    fi
    
    LATEST=$((${LATEST} + 1))

done

