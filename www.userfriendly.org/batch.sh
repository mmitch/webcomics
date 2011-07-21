#!/bin/bash

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{8}.(gif|jpg)' | tail -1 | cut -c 1-8)
if [ -z ${LATEST} ]; then
    LATEST=19971116  # first strip ever - 1
fi

X=${LATEST}
TODAY=$(date +%Y%m%d)

while [ "${TODAY}" -ge "${X}" ] ; do

    echo -n "getting ${X}: "
    URL="http://ars.userfriendly.org/cartoons/?mode=classic&id=${X}"
    PICURL=$(
	wget -qO - ${URL} | \
	    grep ${X} | \
	    grep "^<a href.*gif" |\
	    sed -e 's/gif.*$/gif/' -e 's/^.*src="//'
    )
    if [ -z ${PICURL} ]; then
	echo "wrong date?"
	exit ${EXITCODE}
    else

	if [ -e ${X}.gif -a ! -w ${X}.gif ]; then
	    echo skipping
	else

	    wget -qO${X}.gif --referer=${URL} ${PICURL}
	    if [ -s ${X}.gif -a $( stat -c %s ${X}.gif ) -gt 100 ]; then
		echo OK
		chmod -w ${X}.gif
		EXITCODE=0
	    else
		rm -f ${X}.gif
		echo "fetch failed!!!"
		exit ${EXITCODE}
	    fi
	fi
    fi

    X=$(date -d "${X:0:4}-${X:4:2}-${X:6:2} + 1 day" +%Y%m%d)

done

exit ${EXITCODE}
