#!/bin/bash
# $Id: mkindex.sh,v 1.1 2005-04-26 19:30:15 mitch Exp $

ls *.jpeg *.gif 2>/dev/null | sort | while read FILE; do

    NR=$(echo ${FILE:5:4} | sed s/^0+//)
    echo -e "${FILE}\thttp://www.irregularwebcomic.net/${NR}.html\t[${FILE:5:4}]"

done > index
