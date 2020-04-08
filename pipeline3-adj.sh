#!/bin/bash

for f in $*; do
	./transform3.sh add-order.xsl - $f |
	./transform3.sh merge-lexentries3.xsl - - |
	./transform3.sh add-adj_head.xsl - - |
	./transform3.sh add-sensekey.xsl - - |
	./transform3.sh add-tag_count.xsl - - |
	./transform3.sh add-adj_position.xsl - -
done
