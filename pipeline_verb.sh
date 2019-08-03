#!/bin/bash

for f in $*; do
	./run.sh add-sensekey.xsl - $f |
	./run.sh add-syntactic_behaviour_entity.xsl - - |
	./run.sh add-syntactic_behaviour.xsl - - |
	./run.sh add-syntactic_behaviour-attr.xsl - -
done
