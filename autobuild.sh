# Copyright aggi 2016

prepare_system() {
	echo "### prepare_system()"

	mount -o remount,size=22G / || true
	mount -o remount,exec,dev,suid,size=22G /tmp/ || true
	mount -o remount,exec,dev,suid,size=22G /var/tmp/ || true
	umount /etc || true

	NEWDA="$(date +%Y%m%d-%s)"
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
	export PTREE="${PTREE:-${SDDIR}/portage/latest/portage-latest.tar.bz2}"
	export RODIR="${RODIR:-${CADIR}/rootfs}"

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
}

prepare_portage() {
	echo "### prepare_portage()"
	[ -e /usr/portage/.prepared ] && return
	touch /usr/portage/.prepared

	cd /usr/
	tar -xf ${PTREE}
	cd ${CADIR}
	#cp -pR /home/catalyst/extra_overlay /usr/local/portage

	mkdir -p /usr/portage/distfiles
	mkdir -p /var/tmp/catalyst/builds
	mkdir -p /var/tmp/catalyst/packages
	mkdir -p /var/tmp/catalyst/snapshots
	mkdir -p /var/tmp/catalyst/snapshot_cache
	mkdir -p /home/tmp/builds/hardened
	mkdir -p /home/tmp/packages/hardened
	mkdir -p /home/tmp/snapshots
	mkdir -p /home/tmp/snapshot_cache
	mount --bind ${DFDIR} /usr/portage/distfiles
	mount --bind /home/tmp/builds /var/tmp/catalyst/builds
	#mount --bind /home/tmp/packages /var/tmp/catalyst/packages
	mount --bind /home/tmp/snapshots /var/tmp/catalyst/snapshots
	mount --bind /home/tmp/snapshot_cache /var/tmp/catalyst/snapshot_cache

	[ ! -e /etc/portage.orig ] && cp -pR /etc/portage /etc/portage.orig
	rm -rf /etc/portage
	cp -pr /home/catalyst/etc/portage /etc/portage
	rm -f /etc/portage/make.profile
	rm -f /home/catalyst/etc/portage/make.profile
	ln -sf ../../usr/portage/profiles/hardened/linux/amd64/no-multilib /etc/portage/make.profile
	ln -sf ../../usr/portage/profiles/hardened/linux/amd64/no-multilib /home/catalyst/etc/portage/make.profile

	catalyst -v -c ${CCONF} -s $STAMP
	cp -p /var/tmp/catalyst/snapshots/portage-latest.* ${SDDIR}/portage/${RELDA}
	rm -f ${SDDIR}/portage/latest
	ln -sf ${SDDIR}/portage/${RELDA} ${SDDIR}/portage/latest
}

sync_sources() {
	echo "### sync_sources()"
}

sync_portage() {
	echo "### sync_portage()"
	sg wanout -c "emaint -A sync"
	#emerge --sync
}

fetch_distfiles() {
	echo "### fetch_distfiles()"

	mkdir -p /var/tmp/catalyst/builds/hardened

	cp ${SDDIR}/gentoo/stage3-amd64-hardened+nomultilib-20160908.tar.bz2* /var/tmp/catalyst/builds/hardened
	#cp livecd-stage3

	iptables -P OUTPUT ACCEPT
	catalyst -v -F -f /home/catalyst/specs/amd64/hardened/stage1-nomultilib-init.spec -c ${CCONF} -C version_stamp=$STAMP
	catalyst -v -F -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-desktop.spec -c ${CCONF} -C version_stamp=$STAMP
	#\ source_subpath=hardened/stage3-amd64-hardened+nomultilib-20160908.tar.bz2
	iptables -P OUTPUT DROP

	rm -f /var/tmp/catalyst/builds/hardened/*
}

#fetch_all() {
#	echo "### fetch_all()"
#	PKLIST=$(equery l -p --format='$category/$name' '*')
#	emerge -f $PKLIST
#	chown portage:portage /usr/portage/distfiles/*
#	chmod 644 /usr/portage/distfiles/*

#	equery l -p '*'
#	equery l -o '*'
#}

clean_portage() {
	echo "### clean_portage()"

	rm -rf /home/tmp/builds/hardened/*
	rm -rf /home/tmp/packages/hardened/*
	rm -rf /home/tmp/snapshots/*
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
	cp ${SDDIR}/gentoo/stage3-amd64-hardened+nomultilib-20160908.tar.bz2* /var/tmp/catalyst/builds/hardened

	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage1-nomultilib-init.spec -c ${CCONB} -C version_stamp=$STAMP
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage2-nomultilib.spec -c ${CCONB} -C version_stamp=$STAMP
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage3-nomultilib.spec -c ${CCONB} -C version_stamp=$STAMP
#	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage4-nomultilib-minimal.spec -c ${CCONB} -C version_stamp=$STAMP

	cp -p ${BDDIR}/stage*-amd64-latest.tar.bz2* ${SDDIR}/boot/${RELDA}
	rm -f ${SDDIR}/boot/latest
	ln -sf ${SDDIR}/boot/${RELDA} ${SDDIR}/boot/latest
}

build_seed_init() {
	echo "### build_seed_init()"

	clean_stage
	cp ${SDDIR}/boot/latest/stage3-amd64-latest.tar.bz2* ${BDDIR}

	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage1-nomultilib.spec -c ${CCONI} -C version_stamp=$STAMP
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage2-nomultilib.spec -c ${CCONI} -C version_stamp=$STAMP
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage3-nomultilib.spec -c ${CCONI} -C version_stamp=$STAMP
#	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage4-nomultilib-minimal.spec -c ${CCONI} -C version_stamp=$STAMP

	cp -p ${BDDIR}/stage*-amd64-latest.tar.bz2* ${SDDIR}/init/${RELDA}
	rm -f ${SDDIR}/init/latest
	ln -sf ${SDDIR}/init/${RELDA} ${SDDIR}/init/latest
}

build_livecd_minimal() {
	echo "### build_livecd_minimal()"

	clean_stage
	cp ${SDDIR}/init/latest/stage3-amd64-latest.tar.bz2* ${BDDIR}

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-minimal.spec -c ${CCONF} -C version_stamp=$STAMP
	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-minimal.spec -c ${CCONF} -C version_stamp=$STAMP

	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/minimal/${RELDA}
	cp -p ${BDDIR}/amd64-latest.iso* ${SDDIR}/minimal/${RELDA}
	rm -f ${SDDIR}/minimal/latest
	ln -sf ${SDDIR}/minimal/${RELDA} ${SDDIR}/minimal/latest
	[ ! -z "${PKDIR}" ] && rm -rf ${PKDIR}/*
	mkdir -p ${PKDIR} ; cp -pr /var/tmp/catalyst/packages/hardened/livecd-stage1-amd64-latest/* ${PKDIR}
}

build_livecd_admin() {
	echo "### build_livecd_admin()"

	clean_stage
	cp ${SDDIR}/init/latest/stage3-amd64-latest.tar.bz2* ${BDDIR}

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-admin.spec -c ${CCONF} -C version_stamp=$STAMP
	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-admin.spec -c ${CCONF} -C version_stamp=$STAMP

	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/admin/${RELDA}
	cp -p ${BDDIR}/amd64-latest.iso* ${SDDIR}/admin/${RELDA}
	rm -f ${SDDIR}/admin/latest
	ln -sf ${SDDIR}/admin/${RELDA} ${SDDIR}/admin/latest
	[ ! -z "${PKDIR}" ] && rm -rf ${PKDIR}/*
	mkdir -p ${PKDIR} ; cp -pr /var/tmp/catalyst/packages/hardened/livecd-stage1-amd64-latest/* ${PKDIR}
}

build_livecd_desktop() {
	echo "### build_livecd_desktop()"

	clean_stage
	cp ${SDDIR}/init/latest/stage3-amd64-latest.tar.bz2* ${BDDIR}

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-desktop.spec -c ${CCONF} -C version_stamp=$STAMP
	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-desktop.spec -c ${CCONF} -C version_stamp=$STAMP

	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/desktop/${RELDA}
	cp -p ${BDDIR}/amd64-latest.iso* ${SDDIR}/desktop/${RELDA}
	rm -f ${SDDIR}/desktop/latest
	ln -sf ${SDDIR}/desktop/${RELDA} ${SDDIR}/desktop/latest
	[ ! -z "${PKDIR}" ] && rm -rf ${PKDIR}/*
	mkdir -p ${PKDIR} ; cp -pr /var/tmp/catalyst/packages/hardened/livecd-stage1-amd64-latest/* ${PKDIR}
}

update_livecd_minimal() {
	echo "### update_livecd_minimal()"

	clean_stage
	cp ${SDDIR}/minimal/latest/livecd-stage1-amd64-latest.tar.bz2* ${BDDIR}

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-minimal.spec -c ${CCONF} -C version_stamp=$STAMP
	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/minimal/${RELDA}
	cp -p ${BDDIR}/amd64-latest.iso* ${SDDIR}/minimal/${RELDA}
	rm -f ${SDDIR}/minimal/latest
	ln -sf ${SDDIR}/minimal/${RELDA} ${SDDIR}/minimal/latest
}

update_livecd_admin() {
	echo "### update_livecd_admin()"

	clean_stage
	cp ${SDDIR}/admin/latest/livecd-stage1-amd64-latest.tar.bz2* ${BDDIR}

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-admin.spec -c ${CCONF} -C version_stamp=$STAMP
	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/admin/${RELDA}
	cp -p ${BDDIR}/amd64-latest.iso* ${SDDIR}/admin/${RELDA}
	rm -f ${SDDIR}/admin/latest
	ln -sf ${SDDIR}/admin/${RELDA} ${SDDIR}/admin/latest
}

update_livecd_desktop() {
	echo "### update_livecd_desktop()"

	clean_stage
	cp ${SDDIR}/desktop/latest/livecd-stage1-amd64-latest.tar.bz2* ${BDDIR}

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-desktop.spec -c ${CCONF} -C version_stamp=$STAMP source_subpath=hardened/livecd-stage1-amd64-latest.tar.bz2
	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/desktop/${RELDA}
	cp -p ${BDDIR}/amd64-latest.iso* ${SDDIR}/desktop/${RELDA}
	rm -f ${SDDIR}/desktop/latest
	ln -sf ${SDDIR}/desktop/${RELDA} ${SDDIR}/desktop/latest
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
