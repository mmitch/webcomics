#!/bin/bash
# $Id: mkindex.sh,v 1.2 2006-11-16 22:39:09 mitch Exp $

ls *.gif *.jpg | sort | while read FILE; do

    echo -e "${FILE}\thttp://www.ruthe.de/strip/strip.pl?fun=show&id=${FILE:2:4}\t#${FILE:2:4}"

done > index
