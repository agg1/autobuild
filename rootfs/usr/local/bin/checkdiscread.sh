#!/bin/sh
DISK=$1
[ -z "${DISK}" -o ! -e "${DISK}" ] && echo "disk error" && exit
badblocks -c 8 -b 1048576 -s -v ${DISK}
