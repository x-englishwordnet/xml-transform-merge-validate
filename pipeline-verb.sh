#!/bin/bash

for f in $*; do
	./run.sh add-sensekey.xsl - $f |
	./run.sh add-verb_frames_entity.xsl - - |
	./run.sh add-verb_frames.xsl - - |
	./run.sh add-verb_frames-attr.xsl - - |
	./run.sh add-verb_templates_entity.xsl - - |
	./run.sh add-verb_templates.xsl - - 
done
