#!/bin/bash
# $Id: mkindex.sh,v 1.1 2006-12-27 17:41:21 mitch Exp $

ls *.jpeg *.gif 2>/dev/null | sort | while read FILE; do
    echo -e "${FILE}\t[${FILE:13:2}.${FILE:10:2}.${FILE:5:4}]"

done > index
