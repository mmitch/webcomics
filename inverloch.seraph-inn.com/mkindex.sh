#!/bin/bash
# $Id: mkindex.sh,v 1.1 2007-08-26 16:30:23 mitch Exp $

ls *.jpg | sort | while read FILE; do

    STRIPZERO=$(echo ${FILE:0:3} | sed 's/^0*//')
    echo -e "${FILE}\thttp://inverloch.seraph-inn.com/viewcomic.php?page=${STRIPZERO}\t#${STRIPZERO}"

done > index
