#!/bin/bash

convert -rotate 270 \
$(ls | egrep '\.(gif|jpe?g)$' | sort) \
$(grep ^NAME COMIC | sed -e 's/^NAME: //' | tr -cd '[a-zA-Z0-9]').pdf

