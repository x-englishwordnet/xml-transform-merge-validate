#!/bin/bash

for f in $*; do
	./run.sh add-sensekey.xsl - $f 
done
