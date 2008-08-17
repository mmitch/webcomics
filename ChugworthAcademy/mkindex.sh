#!/bin/bash

ls ??.jpeg ??.gif 2>/dev/null | sort | while read FILE; do
    echo -e "${FILE}\t[${FILE:0:2}]"
done > index

ls ???.jpeg ???.gif 2>/dev/null | sort | while read FILE; do
    echo -e "${FILE}\t[${FILE:0:3}]"
done >> index

ls ??????.jpeg ??????.gif 2>/dev/null | sort | while read FILE; do
    echo -e "${FILE}\t[${FILE:2:2}.${FILE:4:2}.20${FILE:0:2}]"
done >> index
