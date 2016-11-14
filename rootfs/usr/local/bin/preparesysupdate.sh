#!/bin/sh -e

[ ! -e /home/seeds/portage/latest/portage-latest.tar.bz2 ] && echo "latest portage tree not found" && exit 1

/usr/local/bin/writable.sh /mnt/livecd
cd /usr ; tar -xf /home/seeds/portage/latest/portage-latest.tar.bz2

mount -o remount,exec /tmp
mount -o remount,exec /var/tmp

mkdir -p /usr/portage/distfiles
mount --bind /home/distfiles /usr/portage/distfiles

#mkdir -p /usr/portage/packages
#mount --bind /home/packages /usr/portage/packages
