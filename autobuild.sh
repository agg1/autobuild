#!/bin/sh
# Copyright aggi 2016

# make fetch distfiles script to run separately probably in systrace shell
# ssl/ssh preferred cipher config, libressl
# checking login tty/pts perms
# custom hexchat, ircd-hybrid, jitsi, mumble, WendzelNNTPd, yatb, xpdf
# check installed packages, eval, remove, track... gupnp etc...
# consider minimal flag
# bootcd ssword
# check llvm/clang cycling
# shell input con limit
# /etc/login.defs crypt method, limits.conf
# sync portage tree to latest
# add portage tree to livecd
# musl overlay
# java overlay
# systrace overlay
# sync NIST CVE database
# check signatures and git trees
# tighten systrace profiles, systrace emerge -f
# test hardening features, compare with ubuntu, paxtest
# test build with -udev
# squashfs routine hashsum check
# make root filesystem writable according to use case /bin /lib64 /opt /sbin /usr
# man pages, doc flag
# no-pw system
# localtime
# check toolchain, glibc, binutils, 584234
# compare spec from non-hardened installcd, env.d stage3
# eselect packages
# opensmtpd
# build from livecd
# livecd enc-loop
# check -X and what pulls in x11 parts with minimal/init admincd
# fuse, shm, mqueue?
# eclipse
# check arp, dhcp, ip stack
# network config
# disable dhcp during boot initrd
# blacklist usb eth modules
# ubsan performance
# check firmware inclusion
# systrace fetch.sh script
# losetup squashfs
# wakeonlan
# blacklist modules
# swapdev script
# cryptodisk script
# config script MAC/serial dependent
# disable dhcp during boot
# include portage with livecd
# .asoundrc defaults
# traced proxy setup
# traced dhcp setup
# systrace dhcp and proxies
# do not mount /usr/local read-write no more once packages are shipped with livecd

# SLAB, CROSS_MEM, ASLR 28/32? performance issue
# CONFIG_SCHED_MC
# strict /dev/mem IO -> radeon issue

prepare_system() {
	echo "### prepare_system()"
#	losetup /dev/loop7 /home/catalyst/swap.dat
#	mkswap /dev/loop7
#	swapon /dev/loop7
#	mount -o bind /home/catalyst/distfiles /usr/portage/distfiles

	export MAKEOPTS="-j12"
	#STAMP=$(date -u +%s)
	export STAMP=latest
	export TARGT=
	export CCONF="/home/catalyst/catalyst-cache.conf"
	export CADIR="/home/catalyst"
	export RELDA="$(date +%Y%m%d)"
	export BDDIR="/var/tmp/catalyst/builds/hardened"

	cd ${CADIR}

	echo 0 > /proc/sys/vm/swappiness
	echo 3 > /proc/sys/vm/drop_caches
	echo 524288 > /proc/sys/vm/min_free_kbytes
	#mount -o remount,size=22G /var/tmp/
	mount -o remount,size=22G /
	if [ ! -e /usr/bin/catalyst ] ; then
		emerge catalyst
		#overlay fix of catalyst script, also $ROOT/etc/portage fix necessary
		patch -d / -Np0 < catalyst.patch
	fi
}

sync_sources() {
}

sync_portage() {
	sg wanout -c "emaint -A sync"
}

fetch_distfiles() {
	sg wanout -c "catalyst -v -F -f /home/catalyst/specs/amd64/hardened/stage1-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP"
	sg wanout -c "catalyst -v -F -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-init.spec -c ${CCONF} -C version_stamp=$STAMP"
	sg wanout -c "catalyst -v -F -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened.spec -c ${CCONF} -C version_stamp=$STAMP"
	sg wanout -c "catalyst -v -F -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened.spec -c ${CCONF} -C version_stamp=$STAMP"
}

clean_portage() {
	echo "### clean_portage()"

	#rm -rf /var/tmp/catalyst/packages/hardened/livecd-stage1-amd64-latest/x11-base/*

	#rm -rf ${CADIR}/packages/*

	rm -rf /var/tmp/catalyst/builds/hardened/*
	rm -rf /var/tmp/catalyst/tmp/hardened/
	rm -rf /var/tmp/catalyst/packages/hardened
	rm -rf /var/tmp/catalyst/kerncache/hardened
	rm -rf /var/tmp/catalyst/snapshots
	rm -rf /var/tmp/catalyst/snapshot_cache
	mkdir -p /var/tmp/catalyst/builds/hardened
}

prepare_portage() {
	echo "### prepare_portage()"

	mkdir -p ${CADIR}/seeds/boot/${RELDA}
	mkdir -p ${CADIR}/seeds/desktop/${RELDA}
	mkdir -p ${CADIR}/seeds/init/${RELDA}
	mkdir -p ${CADIR}/seeds/minimal/${RELDA}

	rm -rf /etc/portage
	cp -r /home/catalyst/etc/portage /etc/portage
	rm -f /etc/portage/make.profile
	rm -f /home/catalyst/etc/portage/make.profile
	ln -sf ../../usr/portage/profiles/hardened/linux/amd64/no-multilib /etc/portage/make.profile
	ln -sf ../../usr/portage/profiles/hardened/linux/amd64/no-multilib /home/catalyst/etc/portage/make.profile

	# it seems some things are grabbed from /ROOT instead of /STAGEROOT such as /etc/portage things!
	cp /home/catalyst/toolchain.eclass /usr/portage/eclass
	cp /home/catalyst/etc/portage/make.defaults /usr/portage/profiles/hardened/linux/amd64/no-multilib/
	cp /home/catalyst/dmraid-1.0.0_rc16-r3.ebuild /usr/portage/sys-fs/dmraid
	# consider pulling in individual drivers instead of xorg-drivers package
	cp /home/catalyst/xorg-drivers-1.18-r1.ebuild /usr/portage/x11-base/xorg-drivers

	cd /usr/portage
	git config --global user.email "aggi@localhost"
	git config --global user.name "aggi"
	git commit -m "hotfix to pick first toolchain entry from gcc-config list" eclass/toolchain.eclass
	git commit -m "hardened no-multilib make.defaults" profiles/hardened/linux/amd64/no-multilib/make.defaults
	git commit -m "quickfix for non-parallel dmraid build" sys-fs/dmraid/dmraid-1.0.0_rc16-r3.ebuild
	git commit -m "disable broken xorg drivers" x11-base/xorg-drivers
	cd -

	catalyst -v -c ${CCONF} -s $STAMP
}

clean_stage() {
	echo "### clean_stage()"

	rm -rf /var/tmp/catalyst/builds/hardened/*
	rm -rf /var/tmp/catalyst/tmp/hardened/
	rm -rf /var/tmp/catalyst/packages/hardened
	rm -rf /var/tmp/catalyst/kerncache/hardened
}

### build seed tarball from official stage3 seed
build_seed_init() {
	echo "### build_seed_init()"

	clean_stage

	cp ${CADIR}/seeds/gentoo/stage3-amd64-hardened+nomultilib-20160908.tar.bz2* /var/tmp/catalyst/builds/hardened
	rm -f ${CADIR}/seeds/boot/latest
	[ "${FETCH}X" != "X" ] && sg wanout -c "catalyst -v -F -f /home/catalyst/specs/amd64/hardened/stage1-nomultilib-init.spec -c ${CCONF} -C version_stamp=$STAMP"
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage1-nomultilib-init.spec -c ${CCONF} -C version_stamp=$STAMP && \
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage2-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP && \
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage3-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP && \
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage4-nomultilib-minimal.spec -c ${CCONF} -C version_stamp=$STAMP && \
	cp -p ${BDDIR}/stage*-amd64-latest.tar.bz2* ${CADIR}/seeds/boot/${RELDA} && \
	ln -sf ${CADIR}/seeds/boot/${RELDA} ${CADIR}/seeds/boot/latest

	clean_stage
}

### build seed tarball from custom seed
build_seed() {
	echo "### build_seed()"

	clean_stage

	cp ${CADIR}/seeds/boot/latest/stage3-amd64-latest.tar.bz2* ${BDDIR}
	rm -f ${CADIR}/seeds/init/latest
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage1-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP && \
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage2-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP && \
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage3-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP && \
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage4-nomultilib-minimal.spec -c ${CCONF} -C version_stamp=$STAMP && \
	cp -p ${BDDIR}/stage*-amd64-latest.tar.bz2* ${CADIR}/seeds/init/${RELDA} && \
	ln -sf ${CADIR}/seeds/init/${RELDA} ${CADIR}/seeds/init/latest

	clean_stage
}

### build minimal livecd from new seed tarball
build_livecd_minimal() {
	echo "### build_livecd_minimal()"

	clean_stage

	cp ${CADIR}/seeds/init/latest/stage3-amd64-latest.tar.bz2* ${BDDIR}
	rm -f ${CADIR}/seeds/minimal/latest
	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-init.spec -c ${CCONF} -C version_stamp=$STAMP && \
	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-init.spec -c ${CCONF} -C version_stamp=$STAMP && \
	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${CADIR}/seeds/minimal/${RELDA} && \
	cp -p ${BDDIR}/admincd-amd64-latest.iso* ${CADIR}/seeds/minimal/${RELDA} && \
	ln -sf ${CADIR}/seeds/minimal/${RELDA} ${CADIR}/seeds/minimal/latest

	clean_stage
}

### build desktop livecd from minimal seed tarball
build_livecd_desktop() {
	echo "### build_livecd_desktop()"

	clean_stage

	# seed destkop build from minimal livecd stage1 seed
	cp ${CADIR}/seeds/minimal/latest/livecd-stage1-amd64-latest.tar.bz2* ${BDDIR}
	rm -f ${CADIR}/seeds/desktop/latest
	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened.spec -c ${CCONF} -C version_stamp=$STAMP && \
	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened.spec -c ${CCONF} -C version_stamp=$STAMP && \
	cp -pr /var/tmp/catalyst/packages/hardened/livecd-stage1-amd64-latest/* ${CADIR}/packages/ && \
	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${CADIR}/seeds/desktop/${RELDA} && \
	cp -p ${BDDIR}/admincd-amd64-latest.iso* ${CADIR}/seeds/desktop/${RELDA} && \
	ln -sf ${CADIR}/seeds/desktop/${RELDA} ${CADIR}/seeds/desktop/latest

	clean_stage
}

update_livecd_desktop() {
	echo "### update_livecd_desktop()"

	clean_stage

	# seed destkop build from desktop livecd stage1 seed
	cp ${CADIR}/seeds/desktop/latest/livecd-stage1-amd64-latest.tar.bz2* ${BDDIR}
	rm -f ${CADIR}/seeds/desktop/latest
	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened.spec -c ${CCONF} -C version_stamp=$STAMP && \
	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened.spec -c ${CCONF} -C version_stamp=$STAMP && \
	cp -pr /var/tmp/catalyst/packages/hardened/livecd-stage1-amd64-latest/* ${CADIR}/packages/ && \
	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${CADIR}/seeds/desktop/${RELDA} && \
	cp -p ${BDDIR}/admincd-amd64-latest.iso* ${CADIR}/seeds/desktop/${RELDA} && \
	ln -sf ${CADIR}/seeds/desktop/${RELDA} ${CADIR}/seeds/desktop/latest

	clean_stage
}
