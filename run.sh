#!/bin/bash

if [ -z "$1" ]; then
	echo "Null XSL"
	exit
fi
XSL="$1"
echo "XSL: $XSL" 1>&2;

if [ -z "$2" ]; then
	echo "Null Source"
	exit
fi
SRC="$2"
echo "SRC: $SRC" 1>&2;

RES="$3"
if [ -z "$3" ]; then
	RES="-"
fi

MEM=-Xmx2G
java -jar transformer.jar $XSL $SRC $RES
