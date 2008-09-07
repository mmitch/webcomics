#!/bin/bash

#ls *.jpg *.gif *.jpeg | sort | while read FILE; do
ls *.gif *.jpeg | sort | while read FILE; do

    echo -e "${FILE}\t${FILE:6:2}.${FILE:4:2}.${FILE:0:4}";

done > index
