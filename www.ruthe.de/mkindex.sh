#!/bin/bash
# $Id: mkindex.sh,v 1.4 2007-06-26 20:53:51 mitch Exp $

ls *.jpg 2>/dev/null | sort | while read FILE; do

    echo -e "${FILE}\thttp://www.ruthe.de/gallery/cpg1410/albums/userpics/10001/strip_${FILE:2:4}.jpg\t#${FILE:2:4}"

done > index
