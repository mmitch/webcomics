#!/bin/bash
# $Id: mkindex.sh,v 1.2 2005-02-21 22:38:22 mitch Exp $

(ls *.[jg][pi][gf]) | sort | while read FILE; do

    echo -e "${FILE}\t${FILE:6:2}.${FILE:4:2}.${FILE:0:4}"

done > index
