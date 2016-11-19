#!/bin/sh
DISK=$1
[ -z "${DISK}" -o ! -e "${DISK}" ] && echo "disk error" && exit
hdparm --user-master u --security-unlock pass $DISK
mount $DISK /media/stick
/usr/local/bin/unlockdir.sh /media/stick/container

rm -rf /media/stick/container/catalyst
cp -pR /home/catalyst /media/stick/container
