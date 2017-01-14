#!/bin/sh

IFILE=$1
OFILE=$2

if [ ! -e "${IFILE}" ]; then
	echo "file error"
	exit 1
fi

/usr/local/bin/obfsh -g 128-8+128-256 -i -f ${IFILE} > ${IFILE}.o
CFLAGS="-nopie -fno-pie" /usr/bin/shc -r -f ${IFILE}.o

mv ${IFILE}.o.x ${OFILE}
rm -f ${IFILE}.o ${IFILE}.o.x.c
