#!/bin/bash

if [ -z "$1" ]; then
	echo "Null XSL"
	exit
fi
XSL="$1"
shift
echo "XSL: $XSL" 1>&2;

OUT="$1"
echo "OUT: $OUT" 1>&2;
shift

if [ -z "$*" ]; then
	echo "Null Source"
	exit
fi
echo "SRC: $*" 1>&2;

MEM=-Xmx1G
echo java $MEM -jar transformer.jar $XSL $OUT $*
java $MEM -jar transformer.jar $XSL $OUT $*
