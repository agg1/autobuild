#!/bin/sh
if [ -e /mnt/livecd/.writeable ] ; then
	echo "already writable"
	exit
else
	modprobe overlay || true
	mkdir -p /tmp/livecd_overlay/upper /tmp/livecd_overlay/work
	mount -t overlay overlay -o lowerdir=/mnt/livecd/,upperdir=/tmp/livecd_overlay/upper,workdir=/tmp/livecd_overlay/work /mnt/livecd/
	touch /mnt/livecd/.writeable
fi
