#!/bin/bash

data=wn31
frames=verb.Framestext
sentences=sents.vrb
sentencemap=sentidx.vrb

sort -n ${data}/${frames} | \
sed 's/^\([0-9]*\) /<frame id="\1">/' - | \
sed 's/ *$/<\/frame>/' - > frames.xml

sort -n ${data}/${sentences} | \
sed 's/^\([0-9]*\) /<sent id="\1">/' - | \
sed 's/ *$/<\/sent>/' - > sentences.xml

sort -n ${data}/${sentencemap} | \
awk -F ' |,' '{printf "<map><sensekey>%s</sensekey>",$1; for(i=2;i<=NF;i++) printf "<sentid>%s</sentid>",$i; print "</map>"}' - > sentencemap.xml
