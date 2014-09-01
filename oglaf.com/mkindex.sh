#!/bin/bash

ls *.[gjp][ipn][fg] | sort | while read FILE; do

    NUMBER0=${FILE:0:6}
    NUMBER=$((10#${NUMBER0}))

    URLFILE=${NUMBER0}.url

    [ -r ${URLFILE} ] || continue

    read URL < ${URLFILE}

    TITLEFILE=${NUMBER0}.txt
    if [ -s ${TITLEFILE} ] ; then
	read TEXT < ${TITLEFILE}
    else
	TEXT=${NUMBER}
    fi

    echo -e "${FILE}\t${URL}\t${TEXT}"

done > index
