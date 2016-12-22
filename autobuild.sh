# Copyright aggi 2016

prepare_system() {
	echo "### prepare_system()"

	mount -o remount,size=22G / || true
	mount -o remount,exec,rw /etc || true
	mount -o remount,exec,dev,suid /home || true
	mount -o remount,exec,dev,suid,size=22G /tmp/ || true
	mount -o remount,exec,dev,suid,size=22G /var/tmp/ || true

	export TARCH="${TARCH:-amd64}"
	export LATEST="${LATEST:-latest}"
	export NEWDA="$(date +%Y%m%d-%s)"
	export MAKEOPTS="${MAKEOPTS:--j12}"
	export STAMP="${STAMP:-latest}"
	export TARGT=""
	export CADIR="/home/catalyst"
	export CCONF="${CCONF:-${CADIR}/catalyst.conf}"
	export CCONB="${CCONB:-${CADIR}/catalyst-boot.conf}"
	export CCONI="${CCONI:-${CADIR}/catalyst-init.conf}"
	export RELDA="${RELDA:-$NEWDA}"
	export BDDIR="${BDDIR:-/var/tmp/catalyst/builds/hardened}"
	export SDDIR="${SDDIR:-/home/seeds}"
	export PKDIR="${PKDIR:-/home/packages}"
	export DFDIR="${DFDIR:-/home/distfiles}"
	export PTREE="${PTREE:-${SDDIR}/portage/${LATEST}/portage-latest.tar.bz2}"
	export RODIR="${RODIR:-${CADIR}/rootfs}"
	export CKERN="${CKERN:-}"

	echo 30 > /proc/sys/vm/swappiness
	echo 3 > /proc/sys/vm/drop_caches
	echo 524288 > /proc/sys/vm/min_free_kbytes

	mkdir -p /var/tmp/catalyst/builds
	mkdir -p /var/tmp/catalyst/packages
	mkdir -p ${PKDIR}

	mkdir -p ${SDDIR}/admin/${RELDA}
	mkdir -p ${SDDIR}/boot/${RELDA}
	mkdir -p ${SDDIR}/desktop/${RELDA}
	mkdir -p ${SDDIR}/init/${RELDA}
	mkdir -p ${SDDIR}/minimal/${RELDA}
	mkdir -p ${SDDIR}/portage/${RELDA}
	mkdir -p ${SDDIR}/kerncache/${RELDA}
}

prepare_portage() {
	echo "### prepare_portage()"

	# strangely it seems that without overriding make.conf in /etc/portage --jobs=N is ignored
	if [ ! -d /etc/portage.orig ] ; then
		mv /etc/portage /etc/portage.orig
		cp -pR ${CADIR}/etc/portage /etc
	else
		rm -rf /etc/portage
		cp -pR ${CADIR}/etc/portage /etc
	fi

	rm -f ${CADIR}/etc/portage/make.profile
	ln -sf ../../usr/portage/profiles/hardened/linux/${TARCH}/no-multilib ${CADIR}/etc/portage/make.profile

	[ -e /usr/portage/.prepared ] && return

	if [ ! -e /usr/.writeable ] ; then
		/usr/local/bin/writable.sh /usr/portage
		/usr/local/bin/writable.sh /usr/local/portage
	fi

	rm -rf /usr/local/portage/*
	cp -pR ${CADIR}/extra_overlay/* /usr/local/portage
	cp -pR ${CADIR}/rootfs/usr/local/bin/* /usr/local/bin

	cd /usr/
	tar -xf ${PTREE}
	cd ${CADIR}

	mkdir -p /usr/portage/distfiles
	mkdir -p /var/tmp/catalyst/builds
	mkdir -p /var/tmp/catalyst/packages
	mkdir -p /var/tmp/catalyst/snapshots
	mkdir -p /var/tmp/catalyst/snapshot_cache

	rm -rf /home/tmp/*
	mkdir -p /home/tmp/builds/hardened
	mkdir -p /home/tmp/packages/hardened
	mkdir -p /home/tmp/snapshots
	mkdir -p /home/tmp/snapshot_cache

	cat /proc/mounts | grep /usr/portage/distfiles || \
	mount --bind ${DFDIR} /usr/portage/distfiles
	cat /proc/mounts | grep /var/tmp/catalyst/builds || \
	mount --bind /home/tmp/builds /var/tmp/catalyst/builds
	cat /proc/mounts | grep /var/tmp/catalyst/packages || \
	mount --bind /home/tmp/packages /var/tmp/catalyst/packages
	cat /proc/mounts | grep /var/tmp/catalyst/snapshots || \
	mount --bind /home/tmp/snapshots /var/tmp/catalyst/snapshots
	cat /proc/mounts | grep /var/tmp/catalyst/snapshot_cache || \
	mount --bind /home/tmp/snapshot_cache /var/tmp/catalyst/snapshot_cache

	catalyst -v -c ${CCONF} -s $STAMP
	cp -p /var/tmp/catalyst/snapshots/portage-latest.* ${SDDIR}/portage/${RELDA}

	touch /usr/portage/.prepared
}

clean_portage() {
	echo "### clean_portage()"

	rm -rf /home/tmp/builds/hardened/*
	rm -rf /home/tmp/packages/hardened/*
	#rm -rf /home/tmp/snapshots/*
	rm -rf /home/tmp/snapshot_cache/*
	rm -rf /var/tmp/catalyst/tmp/hardened
	rm -rf /var/tmp/catalyst/kerncache/hardened
	sync
	echo 3 > /proc/sys/vm/drop_caches
}

clean_stage() {
	echo "### clean_stage()"

	rm -rf /home/tmp/builds/hardened/*
	rm -rf /home/tmp/packages/hardened/*
	rm -rf /var/tmp/catalyst/packages/hardened/*
	rm -rf /var/tmp/catalyst/tmp/hardened
	rm -rf /var/tmp/catalyst/kerncache/hardened
	rm -rf /var/tmp/genkernel
	sync
	echo 3 > /proc/sys/vm/drop_caches
}

compile_csripts() {
    echo "### compile_csripts()"
	cd ${CADIR}/cscripts
	CFILES=$(find . -type f)
	cd -
	cd /tmp
	for c in $CFILES ; do
		CTDIR=$(dirname $c | sed 's/\.\///')
		CTFIL=$(basename $c)
		CFFIO="${CTFIL}.o"
		CTFIX="${CTFIL}.o.x"
		CTFIC="${CTFIL}.o.x.c"
		/usr/local/bin/obfsh -g 128-8+128-256 -i -f ${CADIR}/cscripts/${CTDIR}/${CTFIL} > ${CADIR}/cscripts/${CTDIR}/${CFFIO}
		CFLAGS="-nopie -fno-pie" /usr/bin/shc -f ${CADIR}/cscripts/${CTDIR}/${CFFIO}
		mkdir -p ${CADIR}/rootfs/${CTDIR}
		mv ${CADIR}/cscripts/${CTDIR}/${CTFIX} ${CADIR}/rootfs/${CTDIR}/${CTFIL}
		rm -f ${CADIR}/cscripts/${CTDIR}/${CTFIX} ${CADIR}/cscripts/${CTDIR}/${CTFIC} ${CADIR}/cscripts/${CTDIR}/${CFFIO}
	done
	cd -
}

build_seed_boot() {
	echo "### build_seed_boot()"

	clean_stage
	cp ${SDDIR}/gentoo/stage3-${TARCH}-hardened+nomultilib-libressl.tar.bz2* /var/tmp/catalyst/builds/hardened

	catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/stage1-nomultilib-init.spec -c ${CCONB} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/boot/${RELDA}/elogs/stage1
	cp -pR /var/tmp/catalyst/tmp/hardened/stage1-${TARCH}-latest/var/elogs/* ${SDDIR}/boot/${RELDA}/elogs/stage1 || true
	rm -rf /var/tmp/catalyst/tmp/hardened/stage1-${TARCH}-latest/var/elogs/*

	catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/stage2-nomultilib.spec -c ${CCONB} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/boot/${RELDA}/elogs/stage2
	cp -pR /var/tmp/catalyst/tmp/hardened/stage2-${TARCH}-latest/var/elogs/* ${SDDIR}/boot/${RELDA}/elogs/stage2 || true
	rm -rf /var/tmp/catalyst/tmp/hardened/stage2-${TARCH}-latest/var/elogs/*

	catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/stage3-nomultilib.spec -c ${CCONB} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/boot/${RELDA}/elogs/stage3
	cp -pR /var/tmp/catalyst/tmp/hardened/stage3-${TARCH}-latest/var/elogs/* ${SDDIR}/boot/${RELDA}/elogs/stage3 || true
	rm -rf /var/tmp/catalyst/tmp/hardened/stage3-${TARCH}-latest/var/elogs/*

	#catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/stage4-nomultilib-minimal.spec -c ${CCONB} -C version_stamp=$STAMP

	cp -p ${BDDIR}/stage*-${TARCH}-latest.tar.bz2* ${SDDIR}/boot/${RELDA}
}

build_seed_init() {
	echo "### build_seed_init()"

	clean_stage
	cp ${SDDIR}/boot/${RELDA}/stage3-${TARCH}-latest.tar.bz2* ${BDDIR}

	catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/stage1-nomultilib.spec -c ${CCONI} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/init/${RELDA}/elogs/stage1
	cp -pR /var/tmp/catalyst/tmp/hardened/stage1-${TARCH}-latest/var/elogs/* ${SDDIR}/init/${RELDA}/elogs/stage1 || true
	rm -rf /var/tmp/catalyst/tmp/hardened/stage1-${TARCH}-latest/var/elogs/*

	catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/stage2-nomultilib.spec -c ${CCONI} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/init/${RELDA}/elogs/stage2
	cp -pR /var/tmp/catalyst/tmp/hardened/stage2-${TARCH}-latest/var/elogs/* ${SDDIR}/init/${RELDA}/elogs/stage2 || true
	rm -rf /var/tmp/catalyst/tmp/hardened/stage2-${TARCH}-latest/var/elogs/*

	catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/stage3-nomultilib.spec -c ${CCONI} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/init/${RELDA}/elogs/stage3
	cp -pR /var/tmp/catalyst/tmp/hardened/stage3-${TARCH}-latest/var/elogs/* ${SDDIR}/init/${RELDA}/elogs/stage3 || true
	rm -rf /var/tmp/catalyst/tmp/hardened/stage3-${TARCH}-latest/var/elogs/*

	#catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/stage4-nomultilib-minimal.spec -c ${CCONI} -C version_stamp=$STAMP

	cp -p ${BDDIR}/stage*-${TARCH}-latest.tar.bz2* ${SDDIR}/init/${RELDA}
}

build_livecd_minimal() {
	echo "### build_livecd_minimal()"

	clean_stage
	compile_csripts

	cp ${SDDIR}/init/${RELDA}/stage3-${TARCH}-latest.tar.bz2* ${BDDIR}
	if [ "x${CKERN}" != "x" ] ; then
		mkdir -p /var/tmp/catalyst/kerncache/livecd-stage2-${TARCH}-latest
		cp -pR ${SDDIR}/kerncache/${LATEST}/*.bz2 /var/tmp/catalyst/kerncache/hardened/livecd-stage2-${TARCH}-latest
	fi

	catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/admincd-stage1-hardened-minimal.spec -c ${CCONF} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/minimal/${RELDA}/elogs/livecd-stage1
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage1-${TARCH}-latest/var/elogs/* ${SDDIR}/minimal/${RELDA}/elogs/livecd-stage1 || true
	rm -rf /var/tmp/catalyst/tmp/hardened/livecd-stage1-${TARCH}-latest/var/elogs/*

	catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/admincd-stage2-hardened-minimal.spec -c ${CCONF} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/minimal/${RELDA}/elogs/livecd-stage2
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage2-${TARCH}-latest/var/elogs/* ${SDDIR}/minimal/${RELDA}/elogs/livecd-stage2 || true
	rm -rf /var/tmp/catalyst/tmp/hardened/livecd-stage2-${TARCH}-latest/var/elogs/*

	cp -p ${BDDIR}/livecd-stage*-${TARCH}-latest.tar.bz2* ${SDDIR}/minimal/${RELDA}
	cp -p ${BDDIR}/${TARCH}-latest.iso* ${SDDIR}/minimal/${RELDA}
	[ ! -z "${PKDIR}" ] && rm -rf ${PKDIR}/*
	mkdir -p ${PKDIR} ; cp -pr /var/tmp/catalyst/packages/hardened/livecd-stage1-${TARCH}-latest/* ${PKDIR}

	cp -pR /var/tmp/catalyst/kerncache/hardened/livecd-stage2-${TARCH}-latest/*.bz2 ${SDDIR}/kerncache/${RELDA}
}

build_livecd_admin() {
	echo "### build_livecd_admin()"

	clean_stage
	compile_csripts

	cp ${SDDIR}/init/${RELDA}/stage3-${TARCH}-latest.tar.bz2* ${BDDIR}
	if [ "x${CKERN}" != "x" ] ; then
		mkdir -p /var/tmp/catalyst/kerncache/livecd-stage2-${TARCH}-latest
		cp -pR ${SDDIR}/kerncache/${LATEST}/*.bz2 /var/tmp/catalyst/kerncache/hardened/livecd-stage2-${TARCH}-latest
	fi

	catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/admincd-stage1-hardened-admin.spec -c ${CCONF} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/admin/${RELDA}/elogs/livecd-stage1
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage1-${TARCH}-latest/var/elogs/* ${SDDIR}/admin/${RELDA}/elogs/livecd-stage1 || true
	rm -rf /var/tmp/catalyst/tmp/hardened/livecd-stage1-${TARCH}-latest/var/elogs/*

	catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/admincd-stage2-hardened-admin.spec -c ${CCONF} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/admin/${RELDA}/elogs/livecd-stage2
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage2-${TARCH}-latest/var/elogs/* ${SDDIR}/admin/${RELDA}/elogs/livecd-stage2 || true
	rm -rf /var/tmp/catalyst/tmp/hardened/livecd-stage2-${TARCH}-latest/var/elogs/*

	cp -p ${BDDIR}/livecd-stage*-${TARCH}-latest.tar.bz2* ${SDDIR}/admin/${RELDA}
	cp -p ${BDDIR}/${TARCH}-latest.iso* ${SDDIR}/admin/${RELDA}
	[ ! -z "${PKDIR}" ] && rm -rf ${PKDIR}/*
	mkdir -p ${PKDIR} ; cp -pr /var/tmp/catalyst/packages/hardened/livecd-stage1-${TARCH}-latest/* ${PKDIR}

	cp -pR /var/tmp/catalyst/kerncache/hardened/livecd-stage2-${TARCH}-latest/*.bz2 ${SDDIR}/kerncache/${RELDA}

}

build_livecd_desktop() {
	echo "### build_livecd_desktop()"

	clean_stage
	compile_csripts

	cp ${SDDIR}/init/${RELDA}/stage3-${TARCH}-latest.tar.bz2* ${BDDIR}
	if [ "x${CKERN}" != "x" ] ; then
		mkdir -p /var/tmp/catalyst/kerncache/livecd-stage2-${TARCH}-latest
		cp -pR ${SDDIR}/kerncache/${LATEST}/*.bz2 /var/tmp/catalyst/kerncache/hardened/livecd-stage2-${TARCH}-latest
	fi

	catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/admincd-stage1-hardened-desktop.spec -c ${CCONF} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/desktop/${RELDA}/elogs/livecd-stage1
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage1-${TARCH}-latest/var/elogs/* ${SDDIR}/desktop/${RELDA}/elogs/livecd-stage1 || true
	rm -rf /var/tmp/catalyst/tmp/hardened/livecd-stage1-${TARCH}-latest/var/elogs/*
	# otherwise running out of RAM with 24 GB available only
	rm -rf /var/tmp/catalyst/tmp/hardened/livecd-stage1-${TARCH}-latest/

	catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/admincd-stage2-hardened-desktop.spec -c ${CCONF} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/desktop/${RELDA}/elogs/livecd-stage2
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage2-${TARCH}-latest/var/elogs/* ${SDDIR}/desktop/${RELDA}/elogs/livecd-stage2 || true
	rm -rf /var/tmp/catalyst/tmp/hardened/livecd-stage2-${TARCH}-latest/var/elogs/*

	cp -p ${BDDIR}/livecd-stage*-${TARCH}-latest.tar.bz2* ${SDDIR}/desktop/${RELDA}
	cp -p ${BDDIR}/${TARCH}-latest.iso* ${SDDIR}/desktop/${RELDA}
	[ ! -z "${PKDIR}" ] && rm -rf ${PKDIR}/*
	mkdir -p ${PKDIR} ; cp -pr /var/tmp/catalyst/packages/hardened/livecd-stage1-${TARCH}-latest/* ${PKDIR}

	cp -pR /var/tmp/catalyst/kerncache/hardened/livecd-stage2-${TARCH}-latest/*.bz2 ${SDDIR}/kerncache/${RELDA}

}

update_livecd_minimal() {
	echo "### update_livecd_minimal()"

	clean_stage
	compile_csripts

	cp ${SDDIR}/minimal/${LATEST}/livecd-stage1-${TARCH}-latest.tar.bz2* ${BDDIR}
	if [ "x${CKERN}" != "x" ] ; then
		mkdir -p /var/tmp/catalyst/kerncache/livecd-stage2-${TARCH}-latest
		cp -pR ${SDDIR}/kerncache/${LATEST}/*.bz2 /var/tmp/catalyst/kerncache/hardened/livecd-stage2-${TARCH}-latest
	fi

	catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/admincd-stage1-hardened-minimal.spec -c ${CCONF} -C version_stamp=$STAMP \
	source_subpath=hardened/livecd-stage1-${TARCH}-latest.tar.bz2
	mkdir -p ${SDDIR}/minimal/${RELDA}/elogs/livecd-stage1
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage1-${TARCH}-latest/var/elogs/* ${SDDIR}/minimal/${RELDA}/elogs/livecd-stage1 || true
	rm -rf /var/tmp/catalyst/tmp/hardened/livecd-stage1-${TARCH}-latest/var/elogs/*

	catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/admincd-stage2-hardened-minimal.spec -c ${CCONF} -C version_stamp=$STAMP \
	source_subpath=hardened/livecd-stage1-${TARCH}-latest.tar.bz2
	mkdir -p ${SDDIR}/minimal/${RELDA}/elogs/livecd-stage2
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage2-${TARCH}-latest/var/elogs/* ${SDDIR}/minimal/${RELDA}/elogs/livecd-stage2 || true
	rm -rf /var/tmp/catalyst/tmp/hardened/livecd-stage2-${TARCH}-latest/var/elogs/*

	cp -p ${BDDIR}/livecd-stage*-${TARCH}-latest.tar.bz2* ${SDDIR}/minimal/${RELDA}
	cp -p ${BDDIR}/${TARCH}-latest.iso* ${SDDIR}/minimal/${RELDA}
	cp -pR /var/tmp/catalyst/packages/hardened/livecd-stage1-${TARCH}-latest/* ${PKDIR}
	cp -pR /var/tmp/catalyst/kerncache/hardened/livecd-stage2-${TARCH}-latest/*.bz2 ${SDDIR}/kerncache/${RELDA}

}

update_livecd_admin() {
	echo "### update_livecd_admin()"

	clean_stage
	compile_csripts

	cp ${SDDIR}/admin/${LATEST}/livecd-stage1-${TARCH}-latest.tar.bz2* ${BDDIR}
	if [ "x${CKERN}" != "x" ] ; then
		mkdir -p /var/tmp/catalyst/kerncache/livecd-stage2-${TARCH}-latest
		cp -pR ${SDDIR}/kerncache/${LATEST}/*.bz2 /var/tmp/catalyst/kerncache/hardened/livecd-stage2-${TARCH}-latest
	fi

	catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/admincd-stage1-hardened-admin.spec -c ${CCONF} -C version_stamp=$STAMP \
	source_subpath=hardened/livecd-stage1-${TARCH}-latest.tar.bz2
	mkdir -p ${SDDIR}/admin/${RELDA}/elogs/livecd-stage1
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage1-${TARCH}-latest/var/elogs/* ${SDDIR}/admin/${RELDA}/elogs/livecd-stage1 || true
	rm -rf /var/tmp/catalyst/tmp/hardened/livecd-stage1-${TARCH}-latest/var/elogs/*

	catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/admincd-stage2-hardened-admin.spec -c ${CCONF} -C version_stamp=$STAMP \
	source_subpath=hardened/livecd-stage1-${TARCH}-latest.tar.bz2
	mkdir -p ${SDDIR}/admin/${RELDA}/elogs/livecd-stage2
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage2-${TARCH}-latest/var/elogs/* ${SDDIR}/admin/${RELDA}/elogs/livecd-stage2 || true
	rm -rf /var/tmp/catalyst/tmp/hardened/livecd-stage2-${TARCH}-latest/var/elogs/*

	cp -p ${BDDIR}/livecd-stage*-${TARCH}-latest.tar.bz2* ${SDDIR}/admin/${RELDA}
	cp -p ${BDDIR}/${TARCH}-latest.iso* ${SDDIR}/admin/${RELDA}
	cp -pR /var/tmp/catalyst/packages/hardened/livecd-stage1-${TARCH}-latest/* ${PKDIR}
	cp -pR /var/tmp/catalyst/kerncache/hardened/livecd-stage2-${TARCH}-latest/*.bz2 ${SDDIR}/kerncache/${RELDA}
}

update_livecd_desktop() {
	echo "### update_livecd_desktop()"

	clean_stage
	compile_csripts

	cp ${SDDIR}/desktop/${LATEST}/livecd-stage1-${TARCH}-latest.tar.bz2* ${BDDIR}
	if [ "x${CKERN}" != "x" ] ; then
		mkdir -p /var/tmp/catalyst/kerncache/livecd-stage2-${TARCH}-latest
		cp -pR ${SDDIR}/kerncache/${LATEST}/*.bz2 /var/tmp/catalyst/kerncache/hardened/livecd-stage2-${TARCH}-latest
	fi

	catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/admincd-stage1-hardened-desktop.spec -c ${CCONF} -C version_stamp=$STAMP \
	source_subpath=hardened/livecd-stage1-${TARCH}-latest.tar.bz2
	mkdir -p ${SDDIR}/desktop/${RELDA}/elogs/livecd-stage1
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage1-${TARCH}-latest/var/elogs/* ${SDDIR}/desktop/${RELDA}/elogs/livecd-stage1 || true
	rm -rf /var/tmp/catalyst/tmp/hardened/livecd-stage1-${TARCH}-latest/var/elogs/*
	# otherwise running out of RAM with 24 GB available only
	rm -rf /var/tmp/catalyst/tmp/hardened/livecd-stage1-${TARCH}-latest/

	catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/admincd-stage2-hardened-desktop.spec -c ${CCONF} -C version_stamp=$STAMP \
	source_subpath=hardened/livecd-stage1-${TARCH}-latest.tar.bz2
	mkdir -p ${SDDIR}/desktop/${RELDA}/elogs/livecd-stage2
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage2-${TARCH}-latest/var/elogs/* ${SDDIR}/desktop/${RELDA}/elogs/livecd-stage2 || true
	rm -rf /var/tmp/catalyst/tmp/hardened/livecd-stage2-${TARCH}-latest/var/elogs/*

	cp -p ${BDDIR}/livecd-stage*-${TARCH}-latest.tar.bz2* ${SDDIR}/desktop/${RELDA}
	cp -p ${BDDIR}/${TARCH}-latest.iso* ${SDDIR}/desktop/${RELDA}
	cp -pR /var/tmp/catalyst/packages/hardened/livecd-stage1-${TARCH}-latest/* ${PKDIR}
	cp -pR /var/tmp/catalyst/kerncache/hardened/livecd-stage2-${TARCH}-latest/*.bz2 ${SDDIR}/kerncache/${RELDA}
}

build_livecd_tor01() {
	echo "### build_livecd_tor01()"

	clean_stage
	compile_csripts
	mkdir -p ${SDDIR}/tor01/${RELDA}

	cp ${SDDIR}/minimal/${LATEST}/livecd-stage1-${TARCH}-latest.tar.bz2* ${BDDIR}
	if [ "x${CKERN}" != "x" ] ; then
		mkdir -p /var/tmp/catalyst/kerncache/livecd-stage2-${TARCH}-latest
		cp -pR ${SDDIR}/kerncache/${LATEST}/*.bz2 /var/tmp/catalyst/kerncache/hardened/livecd-stage2-${TARCH}-latest
	fi

	catalyst -v -f ${CADIR}/specs/${TARCH}/hardened/admincd-stage2-hardened-tor01.spec -c ${CCONF} -C version_stamp=$STAMP \
	source_subpath=hardened/livecd-stage1-${TARCH}-latest.tar.bz2

	cp -p ${BDDIR}/${TARCH}-latest.iso* ${SDDIR}/tor01/${RELDA}
}

archive_digests() {
	echo "### archive_digests()"
	cd ${SDDIR}
	DIGESTS=$(find . | grep DIGESTS$)
	rm -f ${CADIR}/digests.tar
	tar -cpf ${CADIR}/digests.tar ${DIGESTS}
	sha512sum ${CADIR}/digests.tar > ${CADIR}/digests.tar.DIGESTS
	cd -
}

