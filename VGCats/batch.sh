#!/bin/sh
#
# needs dosage from http://dosage.rocks/
#

for f in *.jpeg; do
    [ -e "$f" ] && echo "VGCats:  OLD FILENAMES DETECTED.  PLEASE RENAME ALL *.jpeg TO *.jpg MANUALLY AND RERUN" && exit 1
    break
done

dosage -b .. -c VGCats
