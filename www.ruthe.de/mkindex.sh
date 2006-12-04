#!/bin/bash
# $Id: mkindex.sh,v 1.3 2006-12-04 10:40:37 mitch Exp $

ls *.gif *.jpg 2>/dev/null | sort | while read FILE; do

    echo -e "${FILE}\thttp://www.ruthe.de/strip/strip.pl?fun=show&id=${FILE:2:4}\t#${FILE:2:4}"

done > index
