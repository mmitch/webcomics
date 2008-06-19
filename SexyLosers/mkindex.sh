#!/bin/bash
# $Id: mkindex.sh,v 1.1 2005-03-27 21:19:03 mitch Exp $

ls *.jpeg *.gif | sort | while read FILE; do

    echo -e "${FILE}\thttp://www.sexylosers.com/${FILE:0:3}.html\t[${FILE:0:3}]"

done > index
