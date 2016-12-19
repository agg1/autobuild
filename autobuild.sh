# Copyright aggi 2016

prepare_system() {
	echo "### prepare_system()"

	mount -o remount,size=22G / || true
	mount -o remount,exec,rw /etc || true
	mount -o remount,exec,dev,suid /home || true
	mount -o remount,exec,dev,suid,size=22G /tmp/ || true
	mount -o remount,exec,dev,suid,size=22G /var/tmp/ || true

	export LATEST="${LATEST:-latest}"
	export NEWDA="$(date +%Y%m%d-%s)"
	export MAKEOPTS="${MAKEOPTS:--j12}"
	export STAMP="${STAMP:-latest}"
	export TARGT=""
	export CCONF="${CCONF:-/home/catalyst/catalyst.conf}"
	export CCONB="${CCONB:-/home/catalyst/catalyst-boot.conf}"
	export CCONI="${CCONI:-/home/catalyst/catalyst-init.conf}"
	export CADIR="/home/catalyst"
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
	# in fact package.use among other things is ignored with catalyst
	# below workaround does not fix it
	# catalyst bug workaround since portage_confdir/etc/portage is ignored
	if [ ! -d /etc/portage.orig ] ; then
		mv /etc/portage /etc/portage.orig
		cp -pR /home/catalyst/etc/portage /etc
	else
		rm -rf /etc/portage
		cp -pR /home/catalyst/etc/portage /etc
	fi

	[ -e /usr/portage/.prepared ] && return

	/usr/local/bin/writable.sh /usr/portage
	/usr/local/bin/writable.sh /usr/local/portage
	rm -rf /usr/local/portage/*
	cp -pR /home/catalyst/extra_overlay/* /usr/local/portage

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
	mount --bind ${DFDIR} /usr/portage/distfiles
	mount --bind /home/tmp/builds /var/tmp/catalyst/builds
	mount --bind /home/tmp/packages /var/tmp/catalyst/packages
	mount --bind /home/tmp/snapshots /var/tmp/catalyst/snapshots
	mount --bind /home/tmp/snapshot_cache /var/tmp/catalyst/snapshot_cache

	rm -f /home/catalyst/etc/portage/make.profile
	ln -sf ../../usr/portage/profiles/hardened/linux/amd64/no-multilib /home/catalyst/etc/portage/make.profile

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

build_seed_boot() {
	echo "### build_seed_boot()"

	clean_stage
	cp ${SDDIR}/gentoo/stage3-amd64-hardened+nomultilib-libressl.tar.bz2* /var/tmp/catalyst/builds/hardened

	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage1-nomultilib-init.spec -c ${CCONB} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/boot/${RELDA}/logs/stage1
	cp -pR /var/tmp/catalyst/tmp/hardened/stage1-amd64-latest/tmp/logs/* ${SDDIR}/boot/${RELDA}/logs/stage1

	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage2-nomultilib.spec -c ${CCONB} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/boot/${RELDA}/logs/stage2
	cp -pR /var/tmp/catalyst/tmp/hardened/stage2-amd64-latest/tmp/logs/* ${SDDIR}/boot/${RELDA}/logs/stage2

	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage3-nomultilib.spec -c ${CCONB} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/boot/${RELDA}/logs/stage3
	cp -pR /var/tmp/catalyst/tmp/hardened/stage3-amd64-latest/tmp/logs/* ${SDDIR}/boot/${RELDA}/logs/stage3

	#catalyst -v -f /home/catalyst/specs/amd64/hardened/stage4-nomultilib-minimal.spec -c ${CCONB} -C version_stamp=$STAMP

	cp -p ${BDDIR}/stage*-amd64-latest.tar.bz2* ${SDDIR}/boot/${RELDA}
}

build_seed_init() {
	echo "### build_seed_init()"

	clean_stage
	cp ${SDDIR}/boot/${RELDA}/stage3-amd64-latest.tar.bz2* ${BDDIR}

	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage1-nomultilib.spec -c ${CCONI} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/init/${RELDA}/logs/stage1
	cp -pR /var/tmp/catalyst/tmp/hardened/stage1-amd64-latest/tmp/logs/* ${SDDIR}/init/${RELDA}/logs/stage1

	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage2-nomultilib.spec -c ${CCONI} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/init/${RELDA}/logs/stage2
	cp -pR /var/tmp/catalyst/tmp/hardened/stage2-amd64-latest/tmp/logs/* ${SDDIR}/init/${RELDA}/logs/stage2

	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage3-nomultilib.spec -c ${CCONI} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/init/${RELDA}/logs/stage3
	cp -pR /var/tmp/catalyst/tmp/hardened/stage3-amd64-latest/tmp/logs/* ${SDDIR}/init/${RELDA}/logs/stage3

	#catalyst -v -f /home/catalyst/specs/amd64/hardened/stage4-nomultilib-minimal.spec -c ${CCONI} -C version_stamp=$STAMP

	cp -p ${BDDIR}/stage*-amd64-latest.tar.bz2* ${SDDIR}/init/${RELDA}
}

build_livecd_minimal() {
	echo "### build_livecd_minimal()"

	clean_stage
	cp ${SDDIR}/init/${RELDA}/stage3-amd64-latest.tar.bz2* ${BDDIR}
	if [ "x${CKERN}" != "x" ] ; then
		mkdir -p /var/tmp/catalyst/kerncache/livecd-stage2-amd64-latest
		cp -pR ${SDDIR}/kerncache/${LATEST}/*.bz2 /var/tmp/catalyst/kerncache/livecd-stage2-amd64-latest
	fi

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-minimal.spec -c ${CCONF} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/minimal/${RELDA}/logs/livecd-stage1
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage1-amd64-latest/tmp/logs/* ${SDDIR}/minimal/${RELDA}/logs/livecd-stage2

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-minimal.spec -c ${CCONF} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/minimal/${RELDA}/logs/livecd-stage2
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage2-amd64-latest/tmp/logs/* ${SDDIR}/minimal/${RELDA}/logs/livecd-stage1

	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/minimal/${RELDA}
	cp -p ${BDDIR}/amd64-latest.iso* ${SDDIR}/minimal/${RELDA}
	[ ! -z "${PKDIR}" ] && rm -rf ${PKDIR}/*
	mkdir -p ${PKDIR} ; cp -pr /var/tmp/catalyst/packages/hardened/livecd-stage1-amd64-latest/* ${PKDIR}

	cp -pR /var/tmp/catalyst/kerncache/hardened/livecd-stage2-amd64-latest/*.bz2 ${SDDIR}/kerncache/${RELDA}
}

build_livecd_admin() {
	echo "### build_livecd_admin()"

	clean_stage
	cp ${SDDIR}/init/${RELDA}/stage3-amd64-latest.tar.bz2* ${BDDIR}
	if [ "x${CKERN}" != "x" ] ; then
		mkdir -p /var/tmp/catalyst/kerncache/livecd-stage2-amd64-latest
		cp -pR ${SDDIR}/kerncache/${LATEST}/*.bz2 /var/tmp/catalyst/kerncache/livecd-stage2-amd64-latest
	fi

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-admin.spec -c ${CCONF} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/admin/${RELDA}/logs/livecd-stage1
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage1-amd64-latest/tmp/logs/* ${SDDIR}/admin/${RELDA}/logs/livecd-stage1

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-admin.spec -c ${CCONF} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/admin/${RELDA}/logs/livecd-stage2
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage2-amd64-latest/tmp/logs/* ${SDDIR}/admin/${RELDA}/logs/livecd-stage2

	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/admin/${RELDA}
	cp -p ${BDDIR}/amd64-latest.iso* ${SDDIR}/admin/${RELDA}
	[ ! -z "${PKDIR}" ] && rm -rf ${PKDIR}/*
	mkdir -p ${PKDIR} ; cp -pr /var/tmp/catalyst/packages/hardened/livecd-stage1-amd64-latest/* ${PKDIR}

	cp -pR /var/tmp/catalyst/kerncache/hardened/livecd-stage2-amd64-latest/*.bz2 ${SDDIR}/kerncache/${RELDA}

}

build_livecd_desktop() {
	echo "### build_livecd_desktop()"

	clean_stage
	cp ${SDDIR}/init/${RELDA}/stage3-amd64-latest.tar.bz2* ${BDDIR}
	if [ "x${CKERN}" != "x" ] ; then
		mkdir -p /var/tmp/catalyst/kerncache/livecd-stage2-amd64-latest
		cp -pR ${SDDIR}/kerncache/${LATEST}/*.bz2 /var/tmp/catalyst/kerncache/livecd-stage2-amd64-latest
	fi

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-desktop.spec -c ${CCONF} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/desktop/${RELDA}/logs/livecd-stage1
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage1-amd64-latest/tmp/logs/* ${SDDIR}/desktop/${RELDA}/logs/livecd-stage1
	# otherwise running out of RAM with 24 GB available only
	rm -rf /var/tmp/catalyst/tmp/hardened/livecd-stage1-amd64-latest/

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-desktop.spec -c ${CCONF} -C version_stamp=$STAMP
	mkdir -p ${SDDIR}/desktop/${RELDA}/logs/livecd-stage2
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage2-amd64-latest/tmp/logs/* ${SDDIR}/desktop/${RELDA}/logs/livecd-stage2

	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/desktop/${RELDA}
	cp -p ${BDDIR}/amd64-latest.iso* ${SDDIR}/desktop/${RELDA}
	[ ! -z "${PKDIR}" ] && rm -rf ${PKDIR}/*
	mkdir -p ${PKDIR} ; cp -pr /var/tmp/catalyst/packages/hardened/livecd-stage1-amd64-latest/* ${PKDIR}

	cp -pR /var/tmp/catalyst/kerncache/hardened/livecd-stage2-amd64-latest/*.bz2 ${SDDIR}/kerncache/${RELDA}

}

update_livecd_minimal() {
	echo "### update_livecd_minimal()"

	clean_stage
	cp ${SDDIR}/minimal/${LATEST}/livecd-stage1-amd64-latest.tar.bz2* ${BDDIR}
	if [ "x${CKERN}" != "x" ] ; then
		mkdir -p /var/tmp/catalyst/kerncache/livecd-stage2-amd64-latest
		cp -pR ${SDDIR}/kerncache/${LATEST}/*.bz2 /var/tmp/catalyst/kerncache/livecd-stage2-amd64-latest
	fi

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-minimal.spec -c ${CCONF} -C version_stamp=$STAMP \
	source_subpath=hardened/livecd-stage1-amd64-latest.tar.bz2
	mkdir -p ${SDDIR}/minimal/${RELDA}/logs/livecd-stage1
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage1-amd64-latest/tmp/logs/* ${SDDIR}/minimal/${RELDA}/logs/livecd-stage1

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-minimal.spec -c ${CCONF} -C version_stamp=$STAMP \
	source_subpath=hardened/livecd-stage1-amd64-latest.tar.bz2
	mkdir -p ${SDDIR}/minimal/${RELDA}/logs/livecd-stage2
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage2-amd64-latest/tmp/logs/* ${SDDIR}/minimal/${RELDA}/logs/livecd-stage2

	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/minimal/${RELDA}
	cp -p ${BDDIR}/amd64-latest.iso* ${SDDIR}/minimal/${RELDA}
	cp -pR /var/tmp/catalyst/packages/hardened/livecd-stage1-amd64-latest/* ${PKDIR}
	cp -pR /var/tmp/catalyst/kerncache/hardened/livecd-stage2-amd64-latest/*.bz2 ${SDDIR}/kerncache/${RELDA}

}

update_livecd_admin() {
	echo "### update_livecd_admin()"

	clean_stage
	cp ${SDDIR}/admin/${LATEST}/livecd-stage1-amd64-latest.tar.bz2* ${BDDIR}
	if [ "x${CKERN}" != "x" ] ; then
		mkdir -p /var/tmp/catalyst/kerncache/livecd-stage2-amd64-latest
		cp -pR ${SDDIR}/kerncache/${LATEST}/*.bz2 /var/tmp/catalyst/kerncache/livecd-stage2-amd64-latest
	fi

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-admin.spec -c ${CCONF} -C version_stamp=$STAMP \
	source_subpath=hardened/livecd-stage1-amd64-latest.tar.bz2
	mkdir -p ${SDDIR}/admin/${RELDA}/logs/livecd-stage1
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage1-amd64-latest/tmp/logs/* ${SDDIR}/admin/${RELDA}/logs/livecd-stage1

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-admin.spec -c ${CCONF} -C version_stamp=$STAMP \
	source_subpath=hardened/livecd-stage1-amd64-latest.tar.bz2
	mkdir -p ${SDDIR}/admin/${RELDA}/logs/livecd-stage2
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage2-amd64-latest/tmp/logs/* ${SDDIR}/admin/${RELDA}/logs/livecd-stage2

	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/admin/${RELDA}
	cp -p ${BDDIR}/amd64-latest.iso* ${SDDIR}/admin/${RELDA}
	cp -pR /var/tmp/catalyst/packages/hardened/livecd-stage1-amd64-latest/* ${PKDIR}
	cp -pR /var/tmp/catalyst/kerncache/hardened/livecd-stage2-amd64-latest/*.bz2 ${SDDIR}/kerncache/${RELDA}
}

update_livecd_desktop() {
	echo "### update_livecd_desktop()"

	clean_stage
	cp ${SDDIR}/desktop/${LATEST}/livecd-stage1-amd64-latest.tar.bz2* ${BDDIR}
	if [ "x${CKERN}" != "x" ] ; then
		mkdir -p /var/tmp/catalyst/kerncache/livecd-stage2-amd64-latest
		cp -pR ${SDDIR}/kerncache/${LATEST}/*.bz2 /var/tmp/catalyst/kerncache/livecd-stage2-amd64-latest
	fi

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-desktop.spec -c ${CCONF} -C version_stamp=$STAMP \
	source_subpath=hardened/livecd-stage1-amd64-latest.tar.bz2
	mkdir -p ${SDDIR}/desktop/${RELDA}/logs/livecd-stage1
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage1-amd64-latest/tmp/logs/* ${SDDIR}/desktop/${RELDA}/logs/livecd-stage1

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-desktop.spec -c ${CCONF} -C version_stamp=$STAMP \
	source_subpath=hardened/livecd-stage1-amd64-latest.tar.bz2
	mkdir -p ${SDDIR}/desktop/${RELDA}/logs/livecd-stage2
	cp -pR /var/tmp/catalyst/tmp/hardened/livecd-stage2-amd64-latest/tmp/logs/* ${SDDIR}/desktop/${RELDA}/logs/livecd-stage2

	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/desktop/${RELDA}
	cp -p ${BDDIR}/amd64-latest.iso* ${SDDIR}/desktop/${RELDA}
	cp -pR /var/tmp/catalyst/packages/hardened/livecd-stage1-amd64-latest/* ${PKDIR}
	cp -pR /var/tmp/catalyst/kerncache/hardened/livecd-stage2-amd64-latest/*.bz2 ${SDDIR}/kerncache/${RELDA}
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
