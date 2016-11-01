#!/bin/sh
echo "### locketc()"
if [ -e /etc/.readonly ] ; then
	echo "already locked"
else
	touch /etc/.readonly
	modprobe overlay || true
	rm -rf /tmp/etc_overlay/etc
	mkdir -p /tmp/etc_overlay/upper/etc /tmp/etc_overlay/work/etc
	mount -t overlay overlay -o ro,dirsync,sync,lowerdir=/etc,upperdir=/tmp/etc_overlay/upper/etc,workdir=/tmp/etc_overlay/work/etc /etc
fi
