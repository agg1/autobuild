#!/bin/sh -e

[ -e /usr/.writeable ] && echo "already prepared" && exit 1

[ ! -e /home/seeds/portage/latest/portage-latest.tar.bz2 ] && echo "latest portage tree not found" && exit 1

mount -o remount,rw /etc 2> /dev/null
mount -o remount,exec /tmp 2> /dev/null
mount -o remount,exec /var/tmp 2> /dev/null

/usr/local/bin/writable.sh /usr
cd /usr ; tar -xf /home/seeds/portage/latest/portage-latest.tar.bz2

mkdir -p /usr/portage/distfiles
mount --bind /home/distfiles /usr/portage/distfiles

#mkdir -p /usr/portage/packages
#mount --bind /home/packages /usr/portage/packages
