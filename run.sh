#!/bin/bash

XSL=merge-lexfiles.xsl
echo "XSL: $XSL" 1>&2;

DIR=$1
if [ -z "$DIR" ]; then
	DIR=.
fi
echo "DIR: $DIR" 1>&2;

OUT=$2
if [ ! -z "$OUT" ]; then
	echo "OUT: $OUT" 1>&2;
	OUT="-o:$OUT"
fi

MEM=-Xmx2G
OPTIONS=

java -jar Saxon-HE-9.9.1-4.jar $OPTIONS -s:source.xml $OUT -xsl:$XSL dir=$DIR
