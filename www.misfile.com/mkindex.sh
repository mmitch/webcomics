#!/bin/bash
# $Id: mkindex.sh,v 1.2 2007-08-25 09:52:51 mitch Exp $

ls *.jpg | sort | while read FILE; do

    STRIPZERO=$(echo ${FILE:2:3} | sed 's/^0*//')
    echo -e "${FILE}\thttp://www.misfile.com/?page=${STRIPZERO}\t#${STRIPZERO}"

done > index
