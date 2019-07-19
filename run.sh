#!/bin/bash

if [ -z "$1" ]; then
	echo "Null XSL"
	exit
fi
XSL="$1"
shift
echo "XSL: $XSL" 1>&2;

OUT="$1"
shift
echo "OUT: $OUT" 1>&2;

ISDIR=
if [ "$1" == "-dir" ]; then
	shift
	ISDIR="-dir"
	echo "OUT: is directory"
fi

if [ -z "$*" ]; then
	echo "Null Source"
	exit
fi
echo "SRC: $*" 1>&2;

MEM=-Xmx1G
java $MEM -jar transformer.jar $XSL $OUT $ISDIR $*
