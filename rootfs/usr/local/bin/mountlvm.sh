#!/bin/sh

cryptsetup open /dev/md127 home --type plain --cipher aes-xts-plain64 --key-size 512 --hash sha512

/sbin/vgs | grep vghome
if [ $? -gt 0 ];then
	cryptsetup close home
	echo "setup error"
	exit 1
fi

fsck -y /dev/mapper/vghome-lvhome
mount -o nodev,nosuid,noexec /dev/mapper/vghome-lvhome /home/ 2>/dev/null
for i in $(ls /dev/mapper/vghome-lv* | grep -v lvhome | grep -v lvcatalyst | grep -v lvfw01 | grep -v lvwin01) ; do
	LVOL=$(basename $i | cut -d'-' -f2)
	fsck -y /dev/mapper/$LVOL
	mount -o noatime,nodev,nosuid,noexec $i /media/lvm/$LVOL 2>/dev/null
	# -o user_xattr,sync,dirsync
done
