#!/bin/bash

(
    ls | egrep '^[0-9]{4}-[0-9]{2}-.*\.(gif|jpg|png)$' | sort
    ls | egrep '^[0-9]{10}-.*\.(gif|jpg|png)$' | sort
) |  while read FILE; do

	 if [ ${FILE:4:1} = '-' ] ; then
	     DATE=${FILE:8:2}.${FILE:5:2}.${FILE:0:4}
	 else
	     printf -v DATE '%(%d.%m.%Y)T' ${FILE:0:10}
	 fi

	 echo -e "${FILE}\t${DATE}"

    done > index
