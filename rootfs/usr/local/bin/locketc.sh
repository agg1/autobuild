#!/bin/sh
echo "### locketc()"
rm -f /etc/.readonly 2>/dev/null

if [ -e /etc/.readonly ] ; then
	mount -o remount,ro,noexec,nodev,nosuid /etc 2>/dev/null
else
	umount /etc 2>/dev/null
	touch /etc/.readonly
	modprobe overlay || true
	rm -rf /tmp/etc_overlay/etc
	mkdir -p /tmp/etc_overlay/upper/etc /tmp/etc_overlay/work/etc
	mount -t overlay overlay -o ro,noexec,nodev,nosuid,dirsync,sync,lowerdir=/etc,upperdir=/tmp/etc_overlay/upper/etc,workdir=/tmp/etc_overlay/work/etc /etc
fi
