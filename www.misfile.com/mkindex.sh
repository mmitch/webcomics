#!/bin/bash
# $Id: mkindex.sh,v 1.3 2007-08-25 17:48:37 mitch Exp $

ls *.jpg | sort | while read FILE; do

    STRIPZERO=$(echo ${FILE:2:4} | sed 's/^0*//')
    echo -e "${FILE}\thttp://www.misfile.com/?page=${STRIPZERO}\t#${STRIPZERO}"

done > index
