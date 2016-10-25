#!/bin/sh
DISK=$1
[ -z "${DISK}" -o ! -e "${DISK}" ] && echo "disk error" && exit
hdparm --user-master u --security-set-pass $DISK
hdparm --user-master u --security-erase $DISK
