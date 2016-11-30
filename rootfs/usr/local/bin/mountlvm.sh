#!/bin/sh

cryptsetup open /dev/md0 home --type plain --cipher aes-xts-plain64 --key-size 512 --hash sha512
pvscan -a ay --cache

/sbin/vgs | grep vghome
if [ $? -gt 0 ];then
	cryptsetup close home
	echo "setup error"
	exit 1
fi

sleep 3

mkdir -p /media/lvm
fsck -y /dev/mapper/vghome-lvhome
mount -o nodev,nosuid,noexec /dev/mapper/vghome-lvhome /home/ 2>/dev/null
for i in $(ls /dev/mapper/vghome-lv* | grep -v lvhome | grep -v lvfw01) ; do
	LVOL=$(basename $i | cut -d'-' -f2)
	mkdir -p /media/lvm/$LVOL
	fsck -y $i ; mount -o nodev,nosuid,noexec $i /media/lvm/$LVOL 2>/dev/null
	# -o user_xattr,sync,dirsync
done
