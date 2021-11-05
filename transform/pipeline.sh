#!/bin/bash

for f in $*; do
	./transform.sh add-sense_order.xsl - $f |
	./transform.sh add-generated_lexid.xsl - - |
	./transform.sh add-sensekey.xsl - - |
	#./transform.sh add-generated_sensekey.xsl - - |
	#./transform.sh add-legacy_sensekey.xsl - - |
	./transform.sh add-tag_count.xsl - -
done
