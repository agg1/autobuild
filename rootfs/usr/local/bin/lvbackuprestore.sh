# wakeonlan
arp -s 10.0.0.1 ec:08:6b:05:bb:56
echo | nc -4u -q3 10.0.0.1 9999

# md raid
mdadm --create /dev/md127 --level 1 --raid-device 2
cat /proc/mdstat
mdadm --detail /dev/md127

# check hdd
badblocks -v -s -B -c 256 -b 4096 -w /dev/md127

#tune2fs -O metadata_csum,encrypt
#fsck.ext4 --force

pvcreate -Z y --metadatasize 1048k --metadatacopies 2 /dev/mapper/home
#pvs ; pvdisplay ; pvs -o+pe_start
# after reboot
#pvscan -a ay --cache
vgcreate -s 16384k vghome /dev/disk/by-id/dm-name-home
# after reboot
#vgscan --cache

lvcreate -n lvhome -L24G vghome
lvcreate -n lvdocuments -L48G vghome
lvcreate -n lvdistfiles -L384G vghome
lvcreate -n lvgames -L192G vghome
lvcreate -n lvimages -L16G vghome
lvcreate -n lvmusic -L24G vghome
lvcreate -n lvmovies -L480G vghome
lvcreate -n lvsource -L24G vghome
lvcreate -n lvvirtual -L48G vghome
lvcreate -n lvwindows -L64G vghome

# after reboot
#lvscan -a --cache
# before shutdown
#lvchange -a n /dev/vghome/lv*
#lvremove /dev/vghome/lvgames

# backup
cd /media/sshfs/media/backup/container
for i in $(ls /dev/mapper/vghome-* | grep -v catalyst | grep -v lvfw01 | grep -v lvwin01) ; do
IMG=$(echo $i | cut -d'-' -f2)
dd if=$i of=${IMG}.img bs=1M
done
# restore
cd /media/sshfs/media/backup/container
for i in $(ls *.img) ; do
LVM=/dev/mapper/vghome-$(echo $i | sed 's/.img//')
echo $LVM
done

# create snapshots
# -l100%FREE
lvcreate -L8G -s -n lvsnaphome /dev/vghome/lvhome
# remove snapshot
lvremove /dev/vghome/lvsnaphome

# extend volume group
vgextend vghome /dev/md128
# extend logical volume
lvextend -L 48G /dev/mapper/vghome-lvhome
lvextend -l +100%FREE /dev/mapper/vghome-lvhome
# resize file system ONLINE
#fsck -y /dev/mapper/vghome-lvhome
resize2fs -p /dev/mapper/vghome-lvhome
#fsck -y /dev/mapper/vghome-lvhome

mkfs.ext4 -L HOME -O metadata_csum,encrypt,64bit /dev/mapper/vghome-lvhome
mkfs.ext4 -L DISTFILES -O metadata_csum,encrypt,64bit /dev/mapper/vghome-lvdistfiles
mkfs.ext4 -L DOCUMENTS -O metadata_csum,encrypt,64bit /dev/mapper/vghome-lvdocuments
mkfs.ext4 -L GAMES -O metadata_csum,encrypt,64bit /dev/mapper/vghome-lvgames
mkfs.ext4 -L IMAGES -O metadata_csum,encrypt,64bit /dev/mapper/vghome-lvimages
mkfs.ext4 -L MOVIES -O metadata_csum,encrypt,64bit /dev/mapper/vghome-lvmovies
mkfs.ext4 -L MUSIC -O metadata_csum,encrypt,64bit /dev/mapper/vghome-lvmusic
mkfs.ext4 -L SOURCE -O metadata_csum,encrypt,64bit /dev/mapper/vghome-lvsource
mkfs.ext4 -L VIRTUAL -O metadata_csum,encrypt,64bit /dev/mapper/vghome-lvvirtual
mkfs.ext4 -L WINDOWS -O metadata_csum,encrypt,64bit /dev/mapper/vghome-lvwindows
