#!/bin/sh
# Copyright aggi 2016

set -e

# ssl/ssh preferred cipher config, libressl
# custom hexchat, irssi, ircd-hybrid, jitsi, mumble, WendzelNNTPd, yatb, xpdf, pulseaudio -gtk -dbus , pamix?, eclipse, java, systrace, xtrlock
# check installed packages, eval, remove, track... gupnp etc...
# consider minimal flag
# check llvm/clang cycling
# shell input con limit
# sync portage tree to latest
# musl overlay
# sync NIST CVE database
# check signatures and git trees, key locations
# tighten systrace profiles, systrace emerge -f
# test build with -udev
# squashfs routine hashsum check
# eselect packages
# opensmtpd
# check -X and what pulls in x11 parts with minimal/init admincd
# check arp, dhcp, ip stack
# ubsan performance
# check firmware and microcode inclusion
# systrace fetch.sh script, fetch all distfiles from portage tree
# losetup squashfs bootcd ssword, livecd enc-loop
# config script MAC/serial dependent
# traced proxy setup, dhcp setup
# honeypot
# do not mount /usr/local read-write no more once packages are shipped with livecd
# replace glibc with musl
# PRINTING VM for brother printer
# signal qemu halt
# https://github.com/ganto/freeipa
# glsa-check
# firefox noflash, noscript, adblock and/or privoxy
# offline wikipedia
# backup script
# virtual machine init scripts
# crashdumps
# iscsi, lvm, e4cr backup, keyring maintenance, tpm
# opengl, egl, gles

# SLAB, CROSS_MEM, ASLR 28/32? performance issue
# CONFIG_SCHED_MC
# strict /dev/mem IO -> radeon issue

prepare_system() {
	echo "### prepare_system()"

	export MAKEOPTS="-j12"
	#STAMP=$(date -u +%s)
	export STAMP="latest"
	export TARGT=""
	export CCONF="/home/catalyst/catalyst-cache.conf"
	export CADIR="/home/catalyst"
	export RELDA="$(date +%Y%m%d)"
	export BDDIR="/var/tmp/catalyst/builds/hardened"
	export SDDIR="/home/seeds"
	export PKDIR="/home/packages"
	export DFDIR="/home/distfiles"
	export PTREE="${SDDIR}/portage-latest.tar.bz2"
	export RODIR="${CADIR}/rootfs"

	mkdir -p /usr/portage/distfiles
	mount --bind ${DFDIR} /usr/portage/distfiles
	mkdir -p /usr/portage/packages
	mount --bind ${PKDIR} /usr/portage/packages

	cd /usr/
	tar -xf ${PTREE}

	cd ${CADIR}

	echo 0 > /proc/sys/vm/swappiness
	echo 3 > /proc/sys/vm/drop_caches
	echo 524288 > /proc/sys/vm/min_free_kbytes

	mount -o remount,size=22G /
	if [ ! -e /usr/bin/catalyst ] ; then
		emerge catalyst
	fi
	#HOTFIX overlay fix of catalyst script, also $ROOTFS/etc/portage fix necessary
	#patch -d / -Np0 < catalyst.patch
}

prepare_portage() {
	echo "### prepare_portage()"

	mkdir -p ${SDDIR}/boot/${RELDA}
	mkdir -p ${SDDIR}/desktop/${RELDA}
	mkdir -p ${SDDIR}/init/${RELDA}
	mkdir -p ${SDDIR}/minimal/${RELDA}

	[ ! -e /etc/portage.orig ] && cp -pR /etc/portage /etc/portage.orig
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
	cp -p /var/tmp/catalyst/snapshots/portage-latest.* ${SDDIR}
	cp -p /var/tmp/catalyst/snapshots/portage-latest.* ${RODIR}
}

sync_sources() {
	echo "### sync_sources()"
}

sync_portage() {
	echo "### sync_portage()"
	sg wanout -c "emaint -A sync"
}

fetch_distfiles() {
	echo "### fetch_distfiles()"

	mkdir -p /var/tmp/catalyst/builds/hardened

	cp ${SDDIR}/gentoo/stage3-amd64-hardened+nomultilib-20160908.tar.bz2* /var/tmp/catalyst/builds/hardened
	#cp ${SDDIR}/boot/latest/stage3-amd64-latest.tar.bz2* ${BDDIR}
	cp ${SDDIR}/init/latest/stage3-amd64-latest.tar.bz2* ${BDDIR}
	#cp ${SDDIR}/minimal/latest/livecd-stage1-amd64-latest.tar.bz2* ${BDDIR}
	cp ${SDDIR}/desktop/latest/livecd-stage1-amd64-latest.tar.bz2* ${BDDIR}

	iptables -P OUTPUT ACCEPT
	catalyst -v -F -f /home/catalyst/specs/amd64/hardened/stage1-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP
	catalyst -v -F -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-init.spec -c ${CCONF} -C version_stamp=$STAMP
	catalyst -v -F -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened.spec -c ${CCONF} -C version_stamp=$STAMP
	iptables -P OUTPUT DROP
}

fetch_all() {
}

clean_portage() {
	echo "### clean_portage()"

	rm -rf /var/tmp/catalyst/builds/hardened/*
	rm -rf /var/tmp/catalyst/tmp/hardened/
	rm -rf /var/tmp/catalyst/packages/hardened
	rm -rf /var/tmp/catalyst/kerncache/hardened
	rm -rf /var/tmp/catalyst/snapshots
	rm -rf /var/tmp/catalyst/snapshot_cache
	mkdir -p /var/tmp/catalyst/builds/hardened
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

	cp ${SDDIR}/gentoo/stage3-amd64-hardened+nomultilib-20160908.tar.bz2* /var/tmp/catalyst/builds/hardened
	rm -f ${SDDIR}/boot/latest
	[ "${FETCH}X" != "X" ] && sg wanout -c "catalyst -v -F -f /home/catalyst/specs/amd64/hardened/stage1-nomultilib-init.spec -c ${CCONF} -C version_stamp=$STAMP"
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage1-nomultilib-init.spec -c ${CCONF} -C version_stamp=$STAMP && \
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage2-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP && \
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage3-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP && \
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage4-nomultilib-minimal.spec -c ${CCONF} -C version_stamp=$STAMP && \
	cp -p ${BDDIR}/stage*-amd64-latest.tar.bz2* ${SDDIR}/boot/${RELDA} && \
	ln -sf ${SDDIR}/boot/${RELDA} ${SDDIR}/boot/latest

	clean_stage
}

### build seed tarball from custom seed
build_seed() {
	echo "### build_seed()"

	clean_stage

	cp ${SDDIR}/boot/latest/stage3-amd64-latest.tar.bz2* ${BDDIR}
	rm -f ${SDDIR}/init/latest
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage1-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP && \
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage2-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP && \
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage3-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP && \
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage4-nomultilib-minimal.spec -c ${CCONF} -C version_stamp=$STAMP && \
	cp -p ${BDDIR}/stage*-amd64-latest.tar.bz2* ${SDDIR}/init/${RELDA} && \
	ln -sf ${SDDIR}/init/${RELDA} ${SDDIR}/init/latest

	clean_stage
}

### build minimal livecd from new seed tarball
build_livecd_minimal() {
	echo "### build_livecd_minimal()"

	clean_stage

	cp ${SDDIR}/init/latest/stage3-amd64-latest.tar.bz2* ${BDDIR}
	rm -f ${SDDIR}/minimal/latest
	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-init.spec -c ${CCONF} -C version_stamp=$STAMP && \
	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-init.spec -c ${CCONF} -C version_stamp=$STAMP && \
	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/minimal/${RELDA} && \
	cp -p ${BDDIR}/admincd-amd64-latest.iso* ${SDDIR}/minimal/${RELDA} && \
	ln -sf ${SDDIR}/minimal/${RELDA} ${SDDIR}/minimal/latest

	clean_stage
}

### build desktop livecd from minimal seed tarball
build_livecd_desktop() {
	echo "### build_livecd_desktop()"

	clean_stage

	# seed destkop build from minimal livecd stage1 seed
	cp ${SDDIR}/minimal/latest/livecd-stage1-amd64-latest.tar.bz2* ${BDDIR}
	rm -f ${SDDIR}/desktop/latest
	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened.spec -c ${CCONF} -C version_stamp=$STAMP && \
	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened.spec -c ${CCONF} -C version_stamp=$STAMP && \
	cp -pr /var/tmp/catalyst/packages/hardened/livecd-stage1-amd64-latest/* ${PKDIR} && \
	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/desktop/${RELDA} && \
	cp -p ${BDDIR}/admincd-amd64-latest.iso* ${SDDIR}/desktop/${RELDA} && \
	ln -sf ${SDDIR}/desktop/${RELDA} ${SDDIR}/desktop/latest

	clean_stage
}

update_livecd_desktop() {
	echo "### update_livecd_desktop()"

	clean_stage

	# seed destkop build from desktop livecd stage1 seed
	cp ${SDDIR}/desktop/latest/livecd-stage1-amd64-latest.tar.bz2* ${BDDIR}
	rm -f ${SDDIR}/desktop/latest
	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened.spec -c ${CCONF} -C version_stamp=$STAMP && \
	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened.spec -c ${CCONF} -C version_stamp=$STAMP && \
	cp -pr /var/tmp/catalyst/packages/hardened/livecd-stage1-amd64-latest/* ${PKDIR} && \
	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/desktop/${RELDA} && \
	cp -p ${BDDIR}/admincd-amd64-latest.iso* ${SDDIR}/desktop/${RELDA} && \
	ln -sf ${SDDIR}/desktop/${RELDA} ${SDDIR}/desktop/latest

	clean_stage
}
