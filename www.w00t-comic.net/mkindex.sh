#!/bin/bash
# $Id: mkindex.sh,v 1.2 2004-10-26 21:52:01 mitch Exp $

ls *.[gp][in][fg] | sort | while read FILE; do

    echo -e "${FILE}\t${FILE:6:2}.${FILE:4:2}.${FILE:0:4}"

done > index
