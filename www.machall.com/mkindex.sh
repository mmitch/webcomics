#!/bin/bash
# $Id: mkindex.sh,v 1.2 2005-02-21 22:33:05 mitch Exp $

ls *.jpg | sort | while read FILE; do

    echo -e "${FILE}\t#${FILE:0:5}"

done > index
