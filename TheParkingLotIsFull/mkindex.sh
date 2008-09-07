#!/bin/bash

ls *.jpeg *.gif 2>/dev/null | sort | while read FILE; do
    echo -e "${FILE}\t[${FILE:2:3}]"

done > index
