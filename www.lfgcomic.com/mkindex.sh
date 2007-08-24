#!/bin/bash
# $Id: mkindex.sh,v 1.2 2007-08-24 18:30:53 mitch Exp $

ls *.gif | sort | while read FILE; do

    STRIPZERO=$(echo ${FILE:0:3} | sed 's/^0*//')
    echo -e "${FILE}\thttp://www.lfgcomic.com/page/${STRIPZERO}\t#${STRIPZERO}"

done > index
