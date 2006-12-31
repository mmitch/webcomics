#!/bin/bash
# $Id: mkindex.sh,v 1.2 2006-12-31 14:02:22 mitch Exp $

ls *.jpeg *.gif 2>/dev/null | sort | while read FILE; do
    echo -e "${FILE}\thttp://www.sinfest.net/archive_page.php?comicID=${FILE:0:4}\t[${FILE:13:2}.${FILE:10:2}.${FILE:5:4}]"

done > index
