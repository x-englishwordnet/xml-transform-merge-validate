#!/bin/bash

XSD=WN-LMF-1.2-relax_idrefs.xsd
if [ "$1" == "-strict"  ]; then
	XSD=WN-LMF-1.0.xsd
	shift
fi
echo "XSD: $XSD" 1>&2;

DIR=$1
if [ -z "$1" ]; then
	DIR=.
fi
echo "DIR: $DIR" 1>&2;

MEM=-Xmx2G
java -jar validator.jar $XSD $DIR/*.xml
