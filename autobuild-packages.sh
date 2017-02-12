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

# check that bind mounts are set and portage trees are in place
if [ ! -e /usr/writeable ] ;then
	/usr/local/bin/prepareusrupdate.sh /home/seeds/portage/20161118-1479508385/portage-latest.tar.bz2
fi
if [ ! -e /usr/writeable ] ; then
	mkdir -p /usr/portage/distfiles
	mkdir -p /usr/portage/packages
	mount --bind /home/packages/desktop /usr/portage/packages
	mount --bind /home/distfiles /usr/portage/distfiles
fi

cd /usr/src
tar -xf /home/distfiles/linux-4.6.tar.xz
ln -sf /usr/src/linux-4.6 /usr/src/linux
cp /home/autobuild/catalyst/etc/portage/kconfig /usr/src/linux/.config
#export KBUILD_OUTPUT=

rm -f /etc/portage/package.use/._cfg*
cd /home/autobuild
${EMERGE} $(cat pkg.list | grep -v '^#')
