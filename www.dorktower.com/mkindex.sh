#!/bin/bash
# $Id: mkindex.sh,v 1.1 2003-12-25 19:32:57 mitch Exp $

ls dorktower*.jpg | sort | while read FILE; do

    echo -e "${FILE}\t[${FILE:9:3}]"

done > index
