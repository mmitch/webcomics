#!/bin/bash

ls *.[gjp][ipn][fg] | sort | while read FILE; do

    NUMBER0=${FILE:0:6}
    NUMBER=$((10#${NUMBER0}))

    URL=http://www.darklegacycomics.com/${NUMBER}

    TITLEFILE=${NUMBER0}.txt
    if [ -s ${TITLEFILE} ] ; then
	read TEXT < ${TITLEFILE}
	TEXT="${NUMBER0}: ${TEXT}"
    else
	TEXT=${NUMBER0}
    fi

    echo -e "${FILE}\t${URL}\t${TEXT}"

done > index
