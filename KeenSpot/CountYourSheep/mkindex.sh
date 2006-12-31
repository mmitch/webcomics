#!/bin/bash
# $Id: mkindex.sh,v 1.3 2006-12-31 14:00:46 mitch Exp $

ls *.jpeg *.png *.gif 2>/dev/null | sort | while read FILE; do
    echo -e "${FILE}\thttp://www.countyoursheep.com/d/${FILE:0:8}.html\t[${FILE:6:2}.${FILE:4:2}.${FILE:0:4}]"

done > index
