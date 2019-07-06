#!/bin/bash

XSD=WN-LMF-1.0-relax_idrefs.xsd
if [ "$1" == "-strict"  ]; then
	XSD=WN-LMF-1.0.xsd
	shift
fi
echo "XSD: $XSD"

DIR=$1
if [ -z "$1" ]; then
	DIR=.
fi
echo "DIR: $DIR"

MEM=-Xmx2G
java -jar validator.jar $XSD $DIR/*.xml
