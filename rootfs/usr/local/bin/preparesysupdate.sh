#!/bin/sh -e

[ ! -e /home/seeds/portage/latest/portage-latest.tar.bz2 ] && echo "latest portage tree not found" && exit 1
[ -e /etc/.readonly ] && mount -o remount,rw /etc

/usr/local/bin/writable.sh /mnt/livecd
cd /usr ; tar -xf /home/seeds/portage/latest/portage-latest.tar.bz2

[ ! -e /etc/portage.orig ] && cp -pR /etc/portage /etc/portage.orig
rm -rf /etc/portage
cp -pr /home/catalyst/etc/portage /etc/portage
rm -f /etc/portage/make.profile

cd -

cd /home/catalyst
rm -f etc/portage/make.profile
ln -sf ../../usr/portage/profiles/hardened/linux/amd64/no-multilib /etc/portage/make.profile
ln -sf ../../usr/portage/profiles/hardened/linux/amd64/no-multilib etc/portage/make.profile

cd -

mount -o remount,exec /tmp
mount -o remount,exec /var/tmp

mkdir -p /usr/portage/distfiles
mount --bind /home/distfiles /usr/portage/distfiles

#mkdir -p /usr/portage/packages
#mount --bind /home/packages /usr/portage/packages

