#!/bin/bash
# $Id: mkindex.sh,v 1.1 2006-08-18 16:01:15 mitch Exp $

ls *.jpeg *.gif 2>/dev/null | sort | while read FILE; do
    echo -e "${FILE}\t[${FILE:6:2}.${FILE:4:2}.${FILE:0:4}]"

done > index
