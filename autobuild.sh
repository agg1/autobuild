# Copyright aggi 2016

prepare_system() {
	echo "### prepare_system()"

	mount -o remount,size=22G /
	umount /etc || true

	NEWDA="$(date +%Y%m%d-%s)"
	export MAKEOPTS="${MAKEOPTS:--j12}"
	export STAMP="${STAMP:-latest}"
	export TARGT=""
	export CCONF="${CCONF:-/home/catalyst/catalyst.conf}"
	export CADIR="/home/catalyst"
	export RELDA="${RELDA:-$NEWDA}"
	export BDDIR="${BDDIR:-/var/tmp/catalyst/builds/hardened}"
	export SDDIR="${SDDIR:-/home/seeds}"
	export PKDIR="${PKDIR:-/home/packages}"
	export DFDIR="${DFDIR:-/home/distfiles}"
	export PTREE="${PTREE:-${SDDIR}/portage/latest/portage-latest.tar.bz2}"
	export RODIR="${RODIR:-${CADIR}/rootfs}"

	echo 0 > /proc/sys/vm/swappiness
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
	mount --bind /home/tmp/packages /var/tmp/catalyst/packages
	mount --bind /home/tmp/snapshots /var/tmp/catalyst/snapshots
	mount --bind /home/tmp/snapshot_cache /var/tmp/catalyst/snapshot_cache

	[ ! -e /etc/portage.orig ] && cp -pR /etc/portage /etc/portage.orig
	rm -rf /etc/portage
	cp -r /home/catalyst/etc/portage /etc/portage
	rm -f /etc/portage/make.profile
	rm -f /home/catalyst/etc/portage/make.profile
	ln -sf ../../usr/portage/profiles/hardened/linux/amd64/no-multilib /etc/portage/make.profile
	ln -sf ../../usr/portage/profiles/hardened/linux/amd64/no-multilib /home/catalyst/etc/portage/make.profile

	catalyst -v -c ${CCONF} -s $STAMP
	rm -f ${SDDIR}/portage/latest
	cp -p /var/tmp/catalyst/snapshots/portage-latest.* ${SDDIR}/portage/${RELDA}
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
	#cp ${SDDIR}/boot/latest/stage3-amd64-latest.tar.bz2* ${BDDIR}
	cp ${SDDIR}/init/latest/stage3-amd64-latest.tar.bz2* ${BDDIR}
	#cp ${SDDIR}/minimal/latest/livecd-stage1-amd64-latest.tar.bz2* ${BDDIR}
	cp ${SDDIR}/desktop/latest/livecd-stage1-amd64-latest.tar.bz2* ${BDDIR}

	iptables -P OUTPUT ACCEPT
	catalyst -v -F -f /home/catalyst/specs/amd64/hardened/stage1-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP
	catalyst -v -F -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-desktop.spec -c ${CCONF} -C version_stamp=$STAMP
	iptables -P OUTPUT DROP
}

fetch_all() {
#	echo "### fetch_all()"
#	PKLIST=$(equery l -p --format='$category/$name' '*')
#	emerge -f $PKLIST
#	chown portage:portage /usr/portage/distfiles/*
#	chmod 644 /usr/portage/distfiles/*

#	equery l -p '*'
#	equery l -o '*'
}

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
	rm -rf /var/tmp/catalyst/tmp/hardened
	rm -rf /var/tmp/catalyst/kerncache/hardened
	rm -rf /var/tmp/genkernel
	sync
	echo 3 > /proc/sys/vm/drop_caches
}

### build seed tarball from official stage3 seed
build_seed_boot() {
	echo "### build_seed_boot()"

	clean_stage

	cp ${SDDIR}/gentoo/stage3-amd64-hardened+nomultilib-20160908.tar.bz2* /var/tmp/catalyst/builds/hardened
	rm -f ${SDDIR}/boot/latest

	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage1-nomultilib-init.spec -c ${CCONF} -C version_stamp=$STAMP
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage2-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage3-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage4-nomultilib-minimal.spec -c ${CCONF} -C version_stamp=$STAMP

	cp -p ${BDDIR}/stage*-amd64-latest.tar.bz2* ${SDDIR}/boot/${RELDA}
	ln -sf ${SDDIR}/boot/${RELDA} ${SDDIR}/boot/latest
}

### build seed tarball from boot seed
build_seed_init() {
	echo "### build_seed_init()"

	clean_stage

	cp ${SDDIR}/boot/latest/stage3-amd64-latest.tar.bz2* ${BDDIR}
	rm -f ${SDDIR}/init/latest

	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage1-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage2-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage3-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP
	catalyst -v -f /home/catalyst/specs/amd64/hardened/stage4-nomultilib-minimal.spec -c ${CCONF} -C version_stamp=$STAMP

	cp -p ${BDDIR}/stage*-amd64-latest.tar.bz2* ${SDDIR}/init/${RELDA}
	ln -sf ${SDDIR}/init/${RELDA} ${SDDIR}/init/latest
}

### build minimal livecd from new seed tarball
build_livecd_minimal() {
	echo "### build_livecd_minimal()"

	clean_stage
	rm -f ${RODIR}/portage-latest.*

	cp ${SDDIR}/init/latest/stage3-amd64-latest.tar.bz2* ${BDDIR}
	rm -f ${SDDIR}/minimal/latest

	# seed minimal build from init stage3 seed
	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-minimal.spec -c ${CCONF} -C version_stamp=$STAMP
	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-minimal.spec -c ${CCONF} -C version_stamp=$STAMP

	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/minimal/${RELDA}
	cp -p ${BDDIR}/amd64-latest.iso* ${SDDIR}/minimal/${RELDA}
	ln -sf ${SDDIR}/minimal/${RELDA} ${SDDIR}/minimal/latest
	[ ! -z "${PKDIR}" ] && rm -rf ${PKDIR}/*
	mkdir -p ${PKDIR} ; cp -pr /var/tmp/catalyst/packages/hardened/livecd-stage1-amd64-latest/* ${PKDIR}
}

build_livecd_admin() {
	echo "### build_livecd_admin()"

	clean_stage
	rm -f ${RODIR}/portage-latest.*

	cp ${SDDIR}/init/latest/stage3-amd64-latest.tar.bz2* ${BDDIR}
	rm -f ${SDDIR}/admin/latest

	# seed admin build from init stage3 seed
	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-admin.spec -c ${CCONF} -C version_stamp=$STAMP
	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-admin.spec -c ${CCONF} -C version_stamp=$STAMP

	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/admin/${RELDA}
	cp -p ${BDDIR}/amd64-latest.iso* ${SDDIR}/admin/${RELDA}
	ln -sf ${SDDIR}/admin/${RELDA} ${SDDIR}/admin/latest
	[ ! -z "${PKDIR}" ] && rm -rf ${PKDIR}/*
	mkdir -p ${PKDIR} ; cp -pr /var/tmp/catalyst/packages/hardened/livecd-stage1-amd64-latest/* ${PKDIR}
}

### build desktop livecd from minimal seed tarball
build_livecd_desktop() {
	echo "### build_livecd_desktop()"

	clean_stage
	cp -p /var/tmp/catalyst/snapshots/portage-latest.* ${RODIR}

	# seed desktop build from minimal stage3 seed
	cp ${SDDIR}/init/latest/stage3-amd64-latest.tar.bz2* ${BDDIR}
	rm -f ${SDDIR}/desktop/latest

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-desktop.spec -c ${CCONF} -C version_stamp=$STAMP
	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-desktop.spec -c ${CCONF} -C version_stamp=$STAMP

	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/desktop/${RELDA}
	cp -p ${BDDIR}/amd64-latest.iso* ${SDDIR}/desktop/${RELDA}
	ln -sf ${SDDIR}/desktop/${RELDA} ${SDDIR}/desktop/latest
	[ ! -z "${PKDIR}" ] && rm -rf ${PKDIR}/*
	mkdir -p ${PKDIR} ; cp -pr /var/tmp/catalyst/packages/hardened/livecd-stage1-amd64-latest/* ${PKDIR}

	rm -f ${RODIR}/portage-latest.*
}

update_livecd_minimal() {
	echo "### update_livecd_minimal()"

	clean_stage
	rm -f ${RODIR}/portage-latest.*

	# seed minimal build from previous minimal stage1
	cp ${SDDIR}/minimal/latest/livecd-stage1-amd64-latest.tar.bz2* ${BDDIR}
	rm -f ${SDDIR}/minimal/latest

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-minimal.spec -c ${CCONF} -C version_stamp=$STAMP
	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/minimal/${RELDA}
	cp -p ${BDDIR}/amd64-latest.iso* ${SDDIR}/minimal/${RELDA}
	ln -sf ${SDDIR}/minimal/${RELDA} ${SDDIR}/minimal/latest
}

update_livecd_admin() {
	echo "### update_livecd_admin()"

	clean_stage
	rm -f ${RODIR}/portage-latest.*

	# seed admin build from previous admin stage1
	cp ${SDDIR}/admin/latest/livecd-stage1-amd64-latest.tar.bz2* ${BDDIR}
	rm -f ${SDDIR}/admin/latest

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-admin.spec -c ${CCONF} -C version_stamp=$STAMP
	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/admin/${RELDA}
	cp -p ${BDDIR}/amd64-latest.iso* ${SDDIR}/admin/${RELDA}
	ln -sf ${SDDIR}/admin/${RELDA} ${SDDIR}/admin/latest
}

update_livecd_desktop() {
	echo "### update_livecd_desktop()"

	clean_stage
	cp -p /var/tmp/catalyst/snapshots/portage-latest.* ${RODIR}

	# seed destkop build from desktop livecd stage1 seed
	cp ${SDDIR}/desktop/latest/livecd-stage1-amd64-latest.tar.bz2* ${BDDIR}
	rm -f ${SDDIR}/desktop/latest

	catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-desktop.spec -c ${CCONF} -C version_stamp=$STAMP source_subpath=hardened/livecd-stage1-amd64-latest.tar.bz2
	cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${SDDIR}/desktop/${RELDA}
	cp -p ${BDDIR}/amd64-latest.iso* ${SDDIR}/desktop/${RELDA}
	ln -sf ${SDDIR}/desktop/${RELDA} ${SDDIR}/desktop/latest

	rm -f ${RODIR}/portage-latest.*
}
