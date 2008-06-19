#!/bin/bash
# $Id: mkindex.sh,v 1.1 2005-08-02 18:03:51 mitch Exp $

ls *.jpeg *.gif | sort | while read FILE; do

    echo -e "${FILE}\thttp://www.comics.com/comics/arlonjanis/archive/${FILE:0:19}.html\t[${FILE:17:2}.${FILE:15:2}.${FILE:11:4}]"

done > index
