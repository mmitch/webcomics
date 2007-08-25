#!/bin/bash
# $Id: mkindex.sh,v 1.1 2007-08-25 09:30:47 ranma Exp $

ls *.jpg | sort | while read FILE; do

    STRIPZERO=$(echo ${FILE:2:3} | sed 's/^0*//')
    echo -e "${FILE}\t#${STRIPZERO}"

done > index
