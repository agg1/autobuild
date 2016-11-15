#!/bin/sh
DISK=$1
[ -z "${DISK}" -o ! -e "${DISK}" ] && echo "disk error" && exit
hdparm --user-master u --security-set-pass pass $DISK
hdparm --user-master u --security-erase pass $DISK
