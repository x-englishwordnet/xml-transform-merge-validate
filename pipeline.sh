#!/bin/bash

for f in $*; do
	./transform.sh add-sensekey.xsl - $f 
done
