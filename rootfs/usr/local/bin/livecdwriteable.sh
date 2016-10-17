#!/bin/sh
if [ -e /mnt/livecd/.writeable ] ; then
	echo "already writable"
	exit
else
	modprobe overlay || true
	mkdir -p /home/livecd_overlay/upper /home/livecd_overlay/work
	mount -t overlay overlay -o lowerdir=/mnt/livecd/,upperdir=/home/livecd_overlay/upper,workdir=/home/livecd_overlay/work /mnt/livecd/
	touch /mnt/livecd/.writeable
fi
