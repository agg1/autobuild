#!/bin/sh -e

EMERGE="emerge -vkbuN --jobs 4"
#export PORTAGE_CONFIGROOT
export MAKEFLAGS=-j4
export GENTOO_MIRRORS="http://ftp.wh2.tu-dresden.de/pub/mirrors/gentoo/ http://ftp.uni-erlangen.de/pub/mirrors/gentoo http://gd.tuwien.ac.at/opsys/linux/gentoo/"
export EMERGE_DEFAULT_OPTS="--verbose --verbose-conflicts --tree --with-bdeps y --autounmask y --autounmask-write y --binpkg-respect-use y --jobs=4 "
export PORTAGE_CHECKSUM_FILTER="-* sha512"
export PORTAGE_COMPRESS="bzip2"
export PORTAGE_COMPRESS_FLAGS="-1"
export PROFILE_IS_HARDENED=1

[ ! -e /usr/writeable ] && /usr/local/bin/prepareusrupdate.sh /media/stick/container/seeds/portage/20161118-1479508385/portage-latest.tar.bz2
[ ! -e /usr/writeable ] && mkdir -p /usr/portage/packages ; mount --bind /media/stick/container/packages-desktop /usr/portage/packages

cd /usr/src
tar -xf /home/distfiles/linux-4.6.tar.xz
ln -sf /usr/src/linux-4.6 /usr/src/linux
cp /media/stick/container/catalyst/etc/portage/kconfig /usr/src/linux/.config
#export KBUILD_OUTPUT=

rm -f /etc/portage/package.use/._cfg*
${EMERGE} $(cat pkg.app-admin.txt | grep -v '^#')
