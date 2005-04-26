#!/bin/bash
# $Id: mkindex.sh,v 1.1 2005-04-26 19:30:15 mitch Exp $

ls *.jpeg *.gif 2>/dev/null | sort | while read FILE; do
    echo -e "${FILE}\t[${FILE:5:4}]"

done > index
