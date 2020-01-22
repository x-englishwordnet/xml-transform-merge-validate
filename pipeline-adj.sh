#!/bin/bash

for f in $*; do
	./transform.sh add-sensekey.xsl - $f |
	./transform.sh add-adj_position.xsl - -
done
