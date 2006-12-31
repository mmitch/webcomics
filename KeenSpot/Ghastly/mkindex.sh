#!/bin/bash
# $Id: mkindex.sh,v 1.2 2006-12-31 14:15:27 mitch Exp $

ls *.jpeg *.gif 2>/dev/null | sort | while read FILE; do
    echo -e "${FILE}\thttp://www.ghastlycomic.com/d/${FILE:0:8}.html\t[${FILE:6:2}.${FILE:4:2}.${FILE:0:4}]"

done > index
