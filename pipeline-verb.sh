#!/bin/bash

for f in $*; do
	./transform.sh add-sensekey.xsl - $f |
	./transform.sh add-tag_count.xsl - - |
	./transform.sh add-verb_frame-entity.xsl - - |
	./transform.sh add-verb_frame.xsl - - |
	./transform.sh add-verb_frame-attr.xsl - - |
	./transform.sh add-verb_template-entity.xsl - - |
	./transform.sh add-verb_template-attr.xsl - - 
done
