#!/bin/bash
# $Id: mkindex.sh,v 1.1 2007-01-16 21:40:32 mitch Exp $

ls *.jpeg *.gif 2>/dev/null | sort | while read FILE; do
    echo -e "${FILE}\t[${FILE:2:3}]"

done > index
