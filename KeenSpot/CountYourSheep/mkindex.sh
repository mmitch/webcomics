#!/bin/bash
# $Id: mkindex.sh,v 1.2 2006-12-28 09:42:13 mitch Exp $

ls *.jpeg *.png *.gif 2>/dev/null | sort | while read FILE; do
    echo -e "${FILE}\t[${FILE:6:2}.${FILE:4:2}.${FILE:0:4}]"

done > index
