#!/bin/sh
# $Id: batch.sh,v 1.2 2002-12-24 13:53:05 mitch Exp $

# $Log: batch.sh,v $
# Revision 1.2  2002-12-24 13:53:05  mitch
# `wget -q' statt `wget 2>/dev/null'
#
# Revision 1.1  2002/12/24 12:59:57  mitch
# Initial revision.
#
#

EXITCODE=2

LATEST=$(ls | egrep 'azumanga[0-9]{3}.(jpg)' | tail -1 | cut -c 9-11 | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=0  # first strip ever
fi

echo last comic was ${LATEST}

PAGEBASE="http://www.manga-takarajima.mangafan.net"
PICBASE="${PAGEBASE}/azu/azumanga"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

while true; do
    LATEST=$((${LATEST} + 1))
    NR=$(printf %02d ${LATEST})

    echo -n "fetching ${NR}: "
    EXT=jpg
    FILE=azumanga$(printf %03d ${LATEST}).${EXT}
    wget --user-agent="${USERAGENT}" --referer=${PAGEBASE} -qO ${FILE} ${PICBASE}${NR}.${EXT}

    if [ -s ${FILE} ]; then
	echo OK
	chmod -w ${FILE}
	EXITCODE=0
    else
	test -w ${FILE} && rm ${FILE}
	echo nok
	exit ${EXITCODE}
    fi

done
