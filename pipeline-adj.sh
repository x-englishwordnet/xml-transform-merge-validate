#!/bin/bash

for f in $*; do
	./run.sh add-sensekey.xsl - $f |
	./run.sh add-adj_position.xsl - -
done
