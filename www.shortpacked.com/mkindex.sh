#!/bin/bash
# $Id: mkindex.sh,v 1.2 2006-09-14 08:03:32 mitch Exp $

ls *.[gjp][ipn][fg] | sort | while read FILE; do

    echo -e "${FILE}\t${FILE:6:2}.${FILE:4:2}.${FILE:0:4}"

done > index
