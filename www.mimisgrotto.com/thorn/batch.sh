#!/bin/bash

for I in $(seq -w 292); do
	wget http://www.mimisgrotto.com/thorn/strips/$I.jpg
done
