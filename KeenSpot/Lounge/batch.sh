#!/bin/sh

exec 1>&2

echo "KeenSpot/Lounge has moved to KeenSpot/TheLounge"
echo "(it's a change in dosage that we have to accept...)"
echo
echo "1."
echo "manually move all your stuff over to the new folder"
echo "and switch your batch.sh/mkindex.sh calls over to"
echo "that folder as well"
echo
echo "2."
echo "rename all *.jpeg files to *.jpg, or they will be"
echo "downloaded again as duplicates (again, this is a"
echo "dosage change we have to accept)"
echo
echo "3."
echo "afterwards a Scan for Comics should be issued in"
echo "the web interface.  read/unread-counters should not"
echo "be affected."

exit 1
