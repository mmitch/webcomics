#!/bin/bash
# $Id: mkindex.sh,v 1.2 2005-07-10 15:26:19 mitch Exp $

ls ??.jpeg ??.gif 2>/dev/null | sort | while read FILE; do
    echo -e "${FILE}\t[${FILE:0:2}]"
done > index

ls ???.jpeg ???.gif 2>/dev/null | sort | while read FILE; do
    echo -e "${FILE}\t[${FILE:0:3}]"
done >> index