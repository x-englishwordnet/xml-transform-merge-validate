#!/bin/bash

for f in $*; do
	./transform3.sh add-sense_order.xsl - $f |
	#./transform3.sh merge-lexentries3.xsl - - |
	./transform3.sh add-adj_head.xsl - - |
	#./transform3.sh add-generated_lexid.xsl - - |
	#./transform3.sh add-sensekey3.xsl - - |
	#./transform3.sh add-generated_sensekey.xsl - - |
	#./transform3.sh add-legacy_sensekey.xsl - - |
	./transform3.sh add-tag_count.xsl - - #|
	#./transform3.sh add-adj_position.xsl - -
done
