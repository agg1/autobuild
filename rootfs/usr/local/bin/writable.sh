#!/bin/sh
echo "### writable()"
if [ -e /mnt/livecd/usr/.writeable ] ; then
	echo "already writable"
else
	modprobe overlay || true
	rm -rf /home/livecd_overlay/upper/usr /home/livecd_overlay/work/usr
	mkdir -p /home/livecd_overlay/upper/usr /home/livecd_overlay/work/usr
	mount -t overlay overlay -o lowerdir=/mnt/livecd/usr,upperdir=/home/livecd_overlay/upper/usr,workdir=/home/livecd_overlay/work/usr /mnt/livecd/usr
	touch /mnt/livecd/usr/.writeable
fi
