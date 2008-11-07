#!/bin/sh

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{6}.png' | tail -n 1 | cut -c 1-6 | sed 's/^0*//')
if [ -z ${LATEST} ]; then
    LATEST=1  # first strip ever
fi

echo reading from ${LATEST}

PAGEBASE="http://manga.clone-army.org/t42r.php?page="
PICBASE="http://manga.clone-army.org/t42r/tomoyo"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"
DEFEXT=png

source ./download.include
