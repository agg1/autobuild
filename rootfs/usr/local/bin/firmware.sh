#!/bin/sh -e
echo "### firmware()"
if [ -e /mnt/livecd/lib/firmware/.writeable ] ; then
	echo "already writable"
else
	modprobe overlay || true
	rm -rf /tmp/livecd_overlay/upper/firmware /tmp/livecd_overlay/work/firmware
	mkdir -p /tmp/livecd_overlay/upper/firmware /tmp/livecd_overlay/work/firmware
	mount -t overlay overlay -o lowerdir=/mnt/livecd/lib/firmware,upperdir=/tmp/livecd_overlay/upper/firmware,workdir=/tmp/livecd_overlay/work/firmware /mnt/livecd/lib/firmware
	touch /mnt/livecd/lib/firmware/.writeable
	
	cp -pR /usr/local/lib/firmware/* /lib/firmware/
fi
