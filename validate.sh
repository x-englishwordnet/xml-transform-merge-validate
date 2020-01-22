#!/bin/bash

RED='\u001b[31m'
GREEN='\u001b[32m'
YELLOW='\u001b[33m'
BLUE='\u001b[34m'
MAGENTA='\u001b[35m'
CYAN='\u001b[36m'
RESET='\u001b[0m'

XSD="${1}"
echo -e "${MAGENTA}XSD: $XSD${RESET}" 1>&2;

XML="$2"
if [ -z "$XML" ]; then
	XML=.
fi

ISDIR="$3"
if [ "$ISDIR" == "-dir"  ]; then
	DIR=$XML
	echo -e "${MAGENTA}DIR: $DIR${RESET}" 1>&2;
	MEM=-Xmx2G
	java -jar validator.jar "$XSD" $DIR/*.xml
else
	echo -e "${MAGENTA}XML: $XML${RESET}" 1>&2;
	MEM=-Xmx2G
	java -jar validator.jar "$XSD" "$XML"
fi

