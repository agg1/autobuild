#!/bin/sh -e

PTREE=$1
[ -z "${PTREE}" -o ! -e "${PTREE}" ] && echo "latest portage tree not found" && exit 1

[ -e /usr/.writeable ] && echo "already prepared" && exit 1

mount -o remount,rw /etc 2> /dev/null
mount -o remount,exec /tmp 2> /dev/null
mount -o remount,exec /var/tmp 2> /dev/null

/usr/local/bin/writable.sh /mnt/livecd
cd /usr ; tar -xf ${PTREE}

mkdir -p /usr/portage/distfiles
mount --bind /home/distfiles /usr/portage/distfiles

#mkdir -p /usr/portage/packages
#mount --bind /home/packages /usr/portage/packages
