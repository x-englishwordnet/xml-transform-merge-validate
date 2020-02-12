#!/bin/bash

for f in $*; do
	./transform3.sh add-sensekey.xsl - $f |
	./transform3.sh add-tag_count.xsl - - |
	./transform3.sh add-verb_frame-entity.xsl - - |
	./transform3.sh add-verb_frame.xsl - - |
	./transform3.sh add-verb_frame-attr.xsl - - |
	./transform3.sh add-verb_template-entity.xsl - - |
	./transform3.sh add-verb_template-attr.xsl - - |
	./transform3.sh remove-syntacticbehaviourref.xsl - -
done
