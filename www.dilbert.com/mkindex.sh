#!/bin/bash
# $Id: mkindex.sh,v 1.1 2005-02-21 22:35:38 mitch Exp $

ls *.jpg | sort | while read FILE; do

    echo -e "${FILE}\t#${FILE:0:5}"

done > index
