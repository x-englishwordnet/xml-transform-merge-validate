#!/bin/bash

for f in $*; do
	./transform.sh add-adj_head.xsl - $f |
	./transform.sh add-sensekey.xsl - - |
	./transform.sh add-tag_count.xsl - - |
	./transform.sh add-adj_position.xsl - -
done
