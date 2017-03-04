#!/bin/sh
# Copyright aggi 2017
TXFILE=$1
DEVICE=$2

[ -z "${TXFILE}" -o ! -e "${TXFILE}" ] && echo "file error" && exit 1
[ -z "${DEVICE}" -o ! -e "${DEVICE}" ] && echo "device error" && exit 1

cat ${TXFILE} > ${DEVICE}
echo -ne "\x0C" > ${DEVICE}
