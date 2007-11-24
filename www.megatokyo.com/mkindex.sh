#!/bin/bash
# $Id: mkindex.sh,v 1.5 2007-11-24 21:47:06 mitch Exp $

ls *.[gj][ip][fg] | sort -n | while read FILE; do

    NUMBER=${FILE%.jpg}
    NUMBER=${NUMBER%.gif}
    read TEXT < ${NUMBER}.txt
    echo -e "${FILE}\thttp://www.megatokyo.com/index.php?strip_id=${NUMBER}\t${TEXT}"

done > index
