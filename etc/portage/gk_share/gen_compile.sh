#!/bin/bash
# $Id: c28705422202cc4bcf3127e101494aa7df2f6240 $

compile_kernel_args() {
	local ARGS

	ARGS=''
	if [ "${KERNEL_CROSS_COMPILE}" != '' ]
	then
		ARGS="${ARGS} CROSS_COMPILE=\"${KERNEL_CROSS_COMPILE}\""
	fi
	if [ "${KERNEL_CC}" != '' ]
	then
		ARGS="CC=\"${KERNEL_CC}\""
	fi
	if [ "${KERNEL_LD}" != '' ]
	then
		ARGS="${ARGS} LD=\"${KERNEL_LD}\""
	fi
	if [ "${KERNEL_AS}" != '' ]
	then
		ARGS="${ARGS} AS=\"${KERNEL_AS}\""
	fi
	if [ -n "${KERNEL_ARCH}" ]
	then
		ARGS="${ARGS} ARCH=\"${KERNEL_ARCH}\""
	fi
	if [ -n "${KERNEL_OUTPUTDIR}" -a "${KERNEL_OUTPUTDIR}" != "${KERNEL_DIR}" ]
	then
		ARGS="${ARGS} O=\"${KERNEL_OUTPUTDIR}\""
	fi
	printf "%s" "${ARGS}"
}

compile_utils_args()
{
	local ARGS
	ARGS=''

	if [ -n "${UTILS_CROSS_COMPILE}" ]
	then
		UTILS_CC="${UTILS_CROSS_COMPILE}gcc"
		UTILS_LD="${UTILS_CROSS_COMPILE}ld"
		UTILS_AS="${UTILS_CROSS_COMPILE}as"
	fi

	if [ "${UTILS_ARCH}" != '' ]
	then
		ARGS="ARCH=\"${UTILS_ARCH}\""
	fi
	if [ "${UTILS_CC}" != '' ]
	then
		ARGS="CC=\"${UTILS_CC}\""
	fi
	if [ "${UTILS_LD}" != '' ]
	then
		ARGS="${ARGS} LD=\"${UTILS_LD}\""
	fi
	if [ "${UTILS_AS}" != '' ]
	then
		ARGS="${ARGS} AS=\"${UTILS_AS}\""
	fi

	printf "%s" "${ARGS}"
}

export_utils_args()
{
	save_args
	if [ "${UTILS_ARCH}" != '' ]
	then
		export ARCH="${UTILS_ARCH}"
	fi
	if [ "${UTILS_CC}" != '' ]
	then
		export CC="${UTILS_CC}"
	fi
	if [ "${UTILS_LD}" != '' ]
	then
		export LD="${UTILS_LD}"
	fi
	if [ "${UTILS_AS}" != '' ]
	then
		export AS="${UTILS_AS}"
	fi
	if [ "${UTILS_CROSS_COMPILE}" != '' ]
	then
		export CROSS_COMPILE="${UTILS_CROSS_COMPILE}"
	fi
}

unset_utils_args()
{
	if [ "${UTILS_ARCH}" != '' ]
	then
		unset ARCH
	fi
	if [ "${UTILS_CC}" != '' ]
	then
		unset CC
	fi
	if [ "${UTILS_LD}" != '' ]
	then
		unset LD
	fi
	if [ "${UTILS_AS}" != '' ]
	then
		unset AS
	fi
	if [ "${UTILS_CROSS_COMPILE}" != '' ]
	then
		unset CROSS_COMPILE
	fi
	reset_args
}

export_kernel_args()
{
	if [ "${KERNEL_CC}" != '' ]
	then
		export CC="${KERNEL_CC}"
	fi
	if [ "${KERNEL_LD}" != '' ]
	then
		export LD="${KERNEL_LD}"
	fi
	if [ "${KERNEL_AS}" != '' ]
	then
		export AS="${KERNEL_AS}"
	fi
	if [ "${KERNEL_CROSS_COMPILE}" != '' ]
	then
		export CROSS_COMPILE="${KERNEL_CROSS_COMPILE}"
	fi
}

unset_kernel_args()
{
	if [ "${KERNEL_CC}" != '' ]
	then
		unset CC
	fi
	if [ "${KERNEL_LD}" != '' ]
	then
		unset LD
	fi
	if [ "${KERNEL_AS}" != '' ]
	then
		unset AS
	fi
	if [ "${KERNEL_CROSS_COMPILE}" != '' ]
	then
		unset CROSS_COMPILE
	fi
}
save_args()
{
	if [ "${ARCH}" != '' ]
	then
		export ORIG_ARCH="${ARCH}"
	fi
	if [ "${CC}" != '' ]
	then
		export ORIG_CC="${CC}"
	fi
	if [ "${LD}" != '' ]
	then
		export ORIG_LD="${LD}"
	fi
	if [ "${AS}" != '' ]
	then
		export ORIG_AS="${AS}"
	fi
	if [ "${CROSS_COMPILE}" != '' ]
	then
		export ORIG_CROSS_COMPILE="${CROSS_COMPILE}"
	fi
}
reset_args()
{
	if [ "${ORIG_ARCH}" != '' ]
	then
		export ARCH="${ORIG_ARCH}"
		unset ORIG_ARCH
	fi
	if [ "${ORIG_CC}" != '' ]
	then
		export CC="${ORIG_CC}"
		unset ORIG_CC
	fi
	if [ "${ORIG_LD}" != '' ]
	then
		export LD="${ORIG_LD}"
		unset ORIG_LD
	fi
	if [ "${ORIG_AS}" != '' ]
	then
		export AS="${ORIG_AS}"
		unset ORIG_AS
	fi
	if [ "${ORIG_CROSS_COMPILE}" != '' ]
	then
		export CROSS_COMPILE="${ORIG_CROSS_COMPILE}"
		unset ORIG_CROSS_COMPILE
	fi
}

apply_patches() {
	util=$1
	version=$2
	patchdir=${GK_SHARE}/patches/${util}/${version}

	if [ -d "${patchdir}" ]
	then
		print_info 1 "${util}: >> Applying patches..."
		for i in ${patchdir}/*{diff,patch}
		do
			[ -f "${i}" ] || continue
			patch_success=0
			for j in `seq 0 5`
			do
				patch -p${j} --backup-if-mismatch -f < "${i}" --dry-run >/dev/null && \
					patch -p${j} --backup-if-mismatch -f < "${i}"
				if [ $? = 0 ]
				then
					patch_success=1
					break
				fi
			done
			if [ ${patch_success} -eq 1 ]
			then
				print_info 1 "          - `basename ${i}`"
			else
				gen_die "could not apply patch ${i} for ${util}-${version}"
			fi
		done
	else
		print_info 1 "${util}: >> No patches found in $patchdir ..."
	fi
}

compile_generic() {
	local RET
	[ "$#" -lt '2' ] &&
		gen_die 'compile_generic(): improper usage!'
	local target=${1}
	local argstype=${2}

	case "${argstype}" in
		kernel|kernelruntask)
			export_kernel_args
			MAKE=${KERNEL_MAKE}
			;;
		utils)
			export_utils_args
			MAKE=${UTILS_MAKE}
			;;
	esac

	case "${argstype}" in
		kernel|kernelruntask) ARGS="`compile_kernel_args`" ;;
		utils) ARGS="`compile_utils_args`" ;;
		*) ARGS="" ;;
	esac
	shift 2

	if [ ${NICE} -ne 0 ]
	then
		NICEOPTS="nice -n${NICE} "
	else
		NICEOPTS=""
	fi

	# the eval usage is needed in the next set of code
	# as ARGS can contain spaces and quotes, eg:
	# ARGS='CC="ccache gcc"'
	if [ "${argstype}" == 'kernelruntask' ]
	then
		# Silent operation, forced -j1
		print_info 2 "COMMAND: ${NICEOPTS}${MAKE} ${MAKEOPTS} -j1 ${ARGS} ${target} $*" 1 0 1
		eval ${NICEOPTS}${MAKE} -s ${MAKEOPTS} -j1 "${ARGS}" ${target} $*
		RET=$?
	elif [ "${LOGLEVEL}" -gt "1" ]
	then
		# Output to stdout and logfile
		print_info 2 "COMMAND: ${NICEOPTS}${MAKE} ${MAKEOPTS} ${ARGS} ${target} $*" 1 0 1
		eval ${NICEOPTS}${MAKE} ${MAKEOPTS} ${ARGS} ${target} $* 2>&1 | tee -a ${LOGFILE}
		RET=${PIPESTATUS[0]}
	else
		# Output to logfile only
		print_info 2 "COMMAND: ${NICEOPTS}${MAKE} ${MAKEOPTS} ${ARGS} ${target} $*" 1 0 1
		eval ${NICEOPTS}${MAKE} ${MAKEOPTS} ${ARGS} ${target} $* >> ${LOGFILE} 2>&1
		RET=$?
	fi
	[ ${RET} -ne 0 ] &&
		gen_die "Failed to compile the \"${target}\" target..."

	unset MAKE
	unset ARGS

	case "${argstype}" in
		kernel) unset_kernel_args ;;
		utils) unset_utils_args ;;
	esac
}

compile_modules() {
	print_info 1 "        >> Compiling ${KV} modules..."
	cd ${KERNEL_DIR}
	compile_generic modules kernel
	export UNAME_MACHINE="${ARCH}"
	[ "${INSTALL_MOD_PATH}" != '' ] && export INSTALL_MOD_PATH
	if [ "${CMD_STRIP_TYPE}" == "all" -o "${CMD_STRIP_TYPE}" == "modules" ]
	then
		print_info 1 "        >> Installing ${KV} modules (and stripping)"
		INSTALL_MOD_STRIP=1
		export INSTALL_MOD_STRIP
	else
		print_info 1 "        >> Installing ${KV} modules"
	fi
	MAKEOPTS="${MAKEOPTS} -j1" compile_generic "modules_install" kernel
	print_info 1 "        >> Generating module dependency data..."
	if [ "${INSTALL_MOD_PATH}" != '' ]
	then
		depmod -a -e -F "${KERNEL_OUTPUTDIR}"/System.map -b "${INSTALL_MOD_PATH}" ${KV}
	else
		depmod -a -e -F "${KERNEL_OUTPUTDIR}"/System.map ${KV}
	fi
	unset UNAME_MACHINE
	unset INSTALL_MOD_STRIP
}

compile_kernel() {
	[ "${KERNEL_MAKE}" = '' ] &&
		gen_die "KERNEL_MAKE undefined - I don't know how to compile a kernel for this arch!"
	cd ${KERNEL_DIR}
	local kernel_make_directive="${KERNEL_MAKE_DIRECTIVE}"
	if [ "${KERNEL_MAKE_DIRECTIVE_OVERRIDE}" != "${DEFAULT_KERNEL_MAKE_DIRECTIVE_OVERRIDE}" ]; then
		kernel_make_directive="${KERNEL_MAKE_DIRECTIVE_OVERRIDE}"
	fi
	print_info 1 "        >> Compiling ${KV} ${kernel_make_directive/_install/ [ install ]/}..."
	compile_generic "${kernel_make_directive}" kernel
	if [ "${KERNEL_MAKE_DIRECTIVE_2}" != '' ]
	then
		print_info 1 "        >> Starting supplimental compile of ${KV}: ${KERNEL_MAKE_DIRECTIVE_2}..."
		compile_generic "${KERNEL_MAKE_DIRECTIVE_2}" kernel
	fi

	if isTrue "${FIRMWARE_INSTALL}" && [ ! -e "${KERNEL_DIR}/ihex2fw.c" ] ; then
		# Kernel v4.14 removed firmware from the kernel sources, including the
		# ihex2fw.c tool source. Try and detect the tool to see if we are in >=v4.14
		print_warning 1 "        >> Linux v4.14 removed in-kernel firmware, you MUST install the sys-kernel/linux-firmware package!"
	elif isTrue "${FIRMWARE_INSTALL}" ; then
		local cfg_CONFIG_FIRMWARE_IN_KERNEL=$(kconfig_get_opt "${KERNEL_OUTPUTDIR}/.config" CONFIG_FIRMWARE_IN_KERNEL)
		if isTrue "$cfg_CONFIG_FIRMWARE_IN_KERNEL"; then
			print_info 1 "        >> Not installing firmware as it's included in the kernel already (CONFIG_FIRMWARE_IN_KERNEL=y)..."
		else
			print_info 1 "        >> Installing firmware ('make firmware_install') due to CONFIG_FIRMWARE_IN_KERNEL != y..."
			[ "${INSTALL_MOD_PATH}" != '' ] && export INSTALL_MOD_PATH
			[ "${INSTALL_FW_PATH}" != '' ] && export INSTALL_FW_PATH
			MAKEOPTS="${MAKEOPTS} -j1" compile_generic "firmware_install" kernel
		fi
	else
		print_info 1 "        >> Not installing firmware as requested by configuration FIRMWARE_INSTALL=no..."
	fi

	local tmp_kernel_binary=$(find_kernel_binary ${KERNEL_BINARY_OVERRIDE:-${KERNEL_BINARY}})
	local tmp_kernel_binary2=$(find_kernel_binary ${KERNEL_BINARY_2})
	if [ -z "${tmp_kernel_binary}" ]
	then
		gen_die "Cannot locate kernel binary"
	fi
	# if source != outputdir, we need this:
	tmp_kernel_binary="${KERNEL_OUTPUTDIR}"/"${tmp_kernel_binary}"
	tmp_kernel_binary2="${KERNEL_OUTPUTDIR}"/"${tmp_kernel_binary2}"
	systemmap="${KERNEL_OUTPUTDIR}"/System.map

	if isTrue "${CMD_INSTALL}"
	then
		copy_image_with_preserve "kernel" \
			"${tmp_kernel_binary}" \
			"kernel-${KNAME}-${ARCH}-${KV}"

		copy_image_with_preserve "System.map" \
			"${systemmap}" \
			"System.map-${KNAME}-${ARCH}-${KV}"

		if isTrue "${GENZIMAGE}"
		then
			copy_image_with_preserve "kernelz" \
				"${tmp_kernel_binary2}" \
				"kernelz-${KV}"
		fi
	else
		cp "${tmp_kernel_binary}" "${TMPDIR}/kernel-${KNAME}-${ARCH}-${KV}" ||
			gen_die "Could not copy the kernel binary to ${TMPDIR}!"
		cp "${systemmap}" "${TMPDIR}/System.map-${KNAME}-${ARCH}-${KV}" ||
			gen_die "Could not copy System.map to ${TMPDIR}!"
		if isTrue "${GENZIMAGE}"
		then
			cp "${tmp_kernel_binary2}" "${TMPDIR}/kernelz-${KV}" ||
				gen_die "Could not copy the kernelz binary to ${TMPDIR}!"
		fi
	fi
}

compile_busybox() {
	[ -f "${BUSYBOX_SRCTAR}" ] ||
		gen_die "Could not find busybox source tarball: ${BUSYBOX_SRCTAR}!"

	if [ -n "${BUSYBOX_CONFIG}" ]
	then
		[ -f "${BUSYBOX_CONFIG}" ] ||
			gen_die "Could not find busybox config file: ${BUSYBOX_CONFIG}"
	elif isTrue "${NETBOOT}" && [ -f "$(arch_replace "${GK_SHARE}/arch/%%ARCH%%/netboot-busy-config")" ]
	then
		BUSYBOX_CONFIG="$(arch_replace "${GK_SHARE}/arch/%%ARCH%%/netboot-busy-config")"
	elif isTrue "${NETBOOT}" && [ -f "${GK_SHARE}/netboot/busy-config" ]
	then
		BUSYBOX_CONFIG="${GK_SHARE}/netboot/busy-config"
	elif [ -f "$(arch_replace "${GK_SHARE}/arch/%%ARCH%%/busy-config")" ]
	then
		BUSYBOX_CONFIG="$(arch_replace "${GK_SHARE}/arch/%%ARCH%%/busy-config")"
	elif [ -f "${GK_SHARE}/defaults/busy-config" ]
	then
		BUSYBOX_CONFIG="${GK_SHARE}/defaults/busy-config"
	else
		gen_die "Could not find a busybox config file"
	fi

	# Apply config-based tweaks to the busybox config.
	# This needs to be done before cache validation.
	cp "${BUSYBOX_CONFIG}" "${TEMP}/busybox-config"

	# If you want mount.nfs to work on older than 2.6.something, you might need to turn this on.
	#isTrue "${NFS}" && nfs_opt='y'
	nfs_opt='n'
	kconfig_set_opt "${TEMP}/busybox-config" CONFIG_FEATURE_MOUNT_NFS $nfs_opt

	# Delete cache if stored config's MD5 does not match one to be used
	# This exactly just the .config.gk_orig file, and compares it again the
	# current .config.
	if [ -f "${BUSYBOX_BINCACHE}" ]
	then
		oldconfig_md5="$(tar -xf "${BUSYBOX_BINCACHE}" -O .config.gk_orig 2>/dev/null | md5sum)"
		newconfig_md5="$(md5sum < "${TEMP}/busybox-config")"
		if [ "${oldconfig_md5}" != "${newconfig_md5}" ]
		then
			print_info 1 "busybox: >> Removing stale cache..."
			rm -rf "${BUSYBOX_BINCACHE}"
		else
			print_info 1 "busybox: >> Using cache"
		fi
	fi

	# If the busybox bincache does NOT exist, create it; this cannot be merged
	# with the above statement, because that statement might remove the
	# bincache.
	if [ ! -f "${BUSYBOX_BINCACHE}" ]
	then
		cd "${TEMP}"
		rm -rf "${BUSYBOX_DIR}" > /dev/null
		/bin/tar -xpf ${BUSYBOX_SRCTAR} ||
			gen_die 'Could not extract busybox source tarball!'
		[ -d "${BUSYBOX_DIR}" ] ||
			gen_die "Busybox directory ${BUSYBOX_DIR} is invalid!"

		cp "${TEMP}/busybox-config" "${BUSYBOX_DIR}/.config"
		cp "${BUSYBOX_DIR}/.config" "${BUSYBOX_DIR}/.config.gk_orig" # used for the bincache compare

		cd "${BUSYBOX_DIR}"
		apply_patches busybox ${BUSYBOX_VER}

		# This has the side-effect of changing the .config
		print_info 1 'busybox: >> Configuring...'
		yes '' 2>/dev/null | compile_generic oldconfig utils

		print_info 1 'busybox: >> Compiling...'
		compile_generic all utils V=1

		print_info 1 'busybox: >> Copying to cache...'
		[ -f "${TEMP}/${BUSYBOX_DIR}/busybox" ] ||
			gen_die 'Busybox executable does not exist!'
		${UTILS_CROSS_COMPILE}strip "${TEMP}/${BUSYBOX_DIR}/busybox" ||
			gen_die 'Could not strip busybox binary!'
		tar -C "${TEMP}/${BUSYBOX_DIR}" -cjf "${BUSYBOX_BINCACHE}" busybox .config .config.gk_orig ||
			gen_die 'Could not create the busybox bincache!'

		cd "${TEMP}"
		isTrue "${CMD_DEBUGCLEANUP}" && rm -rf "${BUSYBOX_DIR}" > /dev/null
		return 0
	fi
}

compile_lvm() {
	if [ -f "${LVM_BINCACHE}" ]
	then
		print_info 1 "lvm: >> Using cache"
	else
		[ -f "${LVM_SRCTAR}" ] ||
			gen_die "Could not find LVM source tarball: ${LVM_SRCTAR}! Please place it there, or place another version, changing /etc/genkernel.conf as necessary!"
		cd "${TEMP}"
		rm -rf ${LVM_DIR} > /dev/null
		/bin/tar -xpf ${LVM_SRCTAR} ||
			gen_die 'Could not extract LVM source tarball!'
		[ -d "${LVM_DIR}" ] ||
			gen_die "LVM directory ${LVM_DIR} is invalid!"
		cd "${LVM_DIR}"
		print_info 1 'lvm: >> Patching ...'
		apply_patches lvm ${LVM_VER}
		# we currently have a patch that changes configure.ac
		# once given patch is dropped, drop autoconf too
		print_info 1 'lvm: >> Autoconf ...'
		autoconf || gen_die 'Autoconf failed for LVM2'
		print_info 1 'lvm: >> Configuring...'
		LVM_CONF=(
			--enable-static_link
			--prefix=/
			--disable-dmeventd # Fails to build libdm-string.c:(.text+0x1481): undefined reference to `nearbyintl'
			--enable-cmdlib
			--enable-applib
			--disable-lvmetad
			--with-lvm1=internal
			--with-clvmd=none
			--with-cluster=none
			--disable-readline
			--disable-selinux
			--with-mirrors=internal
			--with-snapshots=internal
			--with-pool=internal
			--with-thin=internal
			--with-cache=internal
			--with-raid=internal
		)
		CFLAGS="-fPIC" \
		LIBS='-luuid -lrt -lpthread -lm' \
		LDFLAGS='-Wl,--no-as-needed' \
		./configure "${LVM_CONF[@]}" \
			>> ${LOGFILE} 2>&1 || \
			gen_die 'Configure of lvm failed!'
		print_info 1 'lvm: >> Compiling...'
		compile_generic '' utils || gen_die "failed to build LVM"

		mkdir -p "${TEMP}/lvm/sbin"
		print_info 1 'lvm: >> Installing to DESTDIR...'
		compile_generic "install DESTDIR=${TEMP}/lvm/" utils || gen_die "failed to install LVM"
		# Upstream does u-w on files, and this breaks stuff.
		chmod -R u+w "${TEMP}/lvm/"

		cd "${TEMP}/lvm"
		print_info 1 '      >> Copying to bincache...'
		${UTILS_CROSS_COMPILE}strip "sbin/lvm.static" ||
			gen_die 'Could not strip lvm.static!'
		# See bug 382555
		${UTILS_CROSS_COMPILE}strip "sbin/dmsetup.static" ||
			gen_die 'Could not strip dmsetup.static'
		/bin/tar -cjf "${LVM_BINCACHE}" . ||
			gen_die 'Could not create binary cache'

		cd "${TEMP}"
		isTrue "${CMD_DEBUGCLEANUP}" && rm -rf "${TEMP}/lvm" > /dev/null
		isTrue "${CMD_DEBUGCLEANUP}" && rm -rf "${LVM_DIR}" lvm
		return 0
	fi
}

compile_mdadm() {
	if [ -f "${MDADM_BINCACHE}" ]
	then
		print_info 1 '		MDADM: Using cache'
	else
		[ -f "${MDADM_SRCTAR}" ] ||
			gen_die "Could not find MDADM source tarball: ${MDADM_SRCTAR}! Please place it there, or place another version, changing /etc/genkernel.conf as necessary!"
		cd "${TEMP}"
		rm -rf "${MDADM_DIR}" > /dev/null
		/bin/tar -xpf "${MDADM_SRCTAR}" ||
			gen_die 'Could not extract MDADM source tarball!'
		[ -d "${MDADM_DIR}" ] ||
			gen_die "MDADM directory ${MDADM_DIR} is invalid!"

		cd "${MDADM_DIR}"
		apply_patches mdadm ${MDADM_VER}
		defs='-DNO_DLM -DNO_COROSYNC'
		sed -i \
			-e "/^CFLAGS = /s:^CFLAGS = \(.*\)$:CFLAGS = -Os ${defs}:" \
			-e "/^CXFLAGS = /s:^CXFLAGS = \(.*\)$:CXFLAGS = -Os ${defs}:" \
			-e "/^CWFLAGS = /s:^CWFLAGS = \(.*\)$:CWFLAGS = -Wall:" \
			-e "s/^# LDFLAGS = -static/LDFLAGS = -static/" \
			Makefile || gen_die "Failed to sed mdadm Makefile"

		print_info 1 'mdadm: >> Compiling...'
		compile_generic 'mdadm mdmon' utils

		mkdir -p "${TEMP}/mdadm/sbin"
		install -m 0755 -s mdadm "${TEMP}/mdadm/sbin/mdadm" || gen_die "Failed mdadm install"
		install -m 0755 -s mdmon "${TEMP}/mdadm/sbin/mdmon" || gen_die "Failed mdmon install"
		print_info 1 '      >> Copying to bincache...'
		cd "${TEMP}/mdadm"
		${UTILS_CROSS_COMPILE}strip "sbin/mdadm" "sbin/mdmon" ||
			gen_die 'Could not strip mdadm binaries!'
		/bin/tar -cjf "${MDADM_BINCACHE}" sbin/mdadm sbin/mdmon ||
			gen_die 'Could not create binary cache'

		cd "${TEMP}"
		isTrue "${CMD_DEBUGCLEANUP}" && rm -rf "${MDADM_DIR}" mdadm
		return 0
	fi
}

compile_dmraid() {
	compile_device_mapper
	if [ ! -f "${DMRAID_BINCACHE}" ]
	then
		[ -f "${DMRAID_SRCTAR}" ] ||
			gen_die "Could not find DMRAID source tarball: ${DMRAID_SRCTAR}! Please place it there, or place another version, changing /etc/genkernel.conf as necessary!"
		cd "${TEMP}"
		rm -rf ${DMRAID_DIR} > /dev/null
		/bin/tar -xpf ${DMRAID_SRCTAR} ||
			gen_die 'Could not extract DMRAID source tarball!'
		[ -d "${DMRAID_DIR}" ] ||
			gen_die "DMRAID directory ${DMRAID_DIR} is invalid!"
		rm -rf "${TEMP}/lvm" > /dev/null
		mkdir -p "${TEMP}/lvm"
		/bin/tar -xpf "${LVM_BINCACHE}" -C "${TEMP}/lvm" ||
			gen_die "Could not extract LVM2 binary cache!";

		cd "${DMRAID_DIR}"
		apply_patches dmraid ${DMRAID_VER}
		print_info 1 'dmraid: >> Configuring...'

		LDFLAGS="-L${TEMP}/lvm/lib" \
		CFLAGS="-I${TEMP}/lvm/include" \
		DEVMAPPEREVENT_CFLAGS="-I${TEMP}/lvm/include" \
		CPPFLAGS="-I${TEMP}/lvm/include" \
		LIBS="-ldevmapper -lm -lrt -lpthread" \
		LDFLAGS='-Wl,--no-as-needed' \
		./configure --enable-static_link \
			--with-devmapper-prefix="${TEMP}/lvm" \
			--prefix=${TEMP}/dmraid >> ${LOGFILE} 2>&1 ||
			gen_die 'Configure of dmraid failed!'

		# We dont necessarily have selinux installed yet... look into
		# selinux global support in the future.
		sed -i tools/Makefile -e "/DMRAID_LIBS +=/s|-lselinux||g"
		###echo "DMRAIDLIBS += -lselinux -lsepol" >> tools/Makefile
		mkdir -p "${TEMP}/dmraid"
		print_info 1 'dmraid: >> Compiling...'
		# Force dmraid to be built with -j1 for bug #188273
		MAKEOPTS="${MAKEOPTS} -j1" compile_generic '' utils
		#compile_generic 'install' utils
		mkdir ${TEMP}/dmraid/sbin
		install -m 0755 -s tools/dmraid "${TEMP}/dmraid/sbin/dmraid"
		print_info 1 '      >> Copying to bincache...'
		cd "${TEMP}/dmraid"
		/bin/tar -cjf "${DMRAID_BINCACHE}" sbin/dmraid ||
			gen_die 'Could not create binary cache'

		cd "${TEMP}"
		isTrue "${CMD_DEBUGCLEANUP}" && rm -rf "${TEMP}/lvm" > /dev/null
		isTrue "${CMD_DEBUGCLEANUP}" && rm -rf "${DMRAID_DIR}" dmraid
		return 0
	fi
}

compile_device_mapper() {
	compile_lvm
}

compile_fuse() {
	if [ ! -f "${FUSE_BINCACHE}" ]
	then
		[ ! -f "${FUSE_SRCTAR}" ] &&
			gen_die "Could not find fuse source tarball: ${FUSE_SRCTAR}. Please place it there, or place another version, changing /etc/genkernel.conf as necessary!"
		cd "${TEMP}"
		rm -rf "${FUSE_DIR}"
		tar -xpf "${FUSE_SRCTAR}"
		[ ! -d "${FUSE_DIR}" ] &&
			gen_die "fuse directory ${FUSE_DIR} invalid"
		cd "${FUSE_DIR}"
		apply_patches fuse ${FUSE_VER}
		print_info 1 'fuse: >> Configuring...'
		./configure --disable-example >> ${LOGFILE} 2>&1 ||
			gen_die 'Configuring fuse failed!'
		print_info 1 'fuse: >> Compiling...'
		MAKE=${UTILS_MAKE} compile_generic "" ""

		# Since we're linking statically against libfuse, we don't need to cache the .so
#		print_info 1 'libfuse: >> Copying to cache...'
#		[ -f "${TEMP}/${FUSE_DIR}/lib/.libs/libfuse.so" ] ||
#			gen_die 'libfuse.so does not exist!'
#		${UTILS_CROSS_COMPILE}strip "${TEMP}/${FUSE_DIR}/lib/.libs/libfuse.so" ||
#			gen_die 'Could not strip libfuse.so!'
#		cd "${TEMP}/${FUSE_DIR}/lib/.libs"
#		tar -cjf "${FUSE_BINCACHE}" libfuse*so* ||
#			gen_die 'Could not create fuse bincache!'

		cd "${TEMP}"
#		isTrue "${CMD_DEBUGCLEANUP}" && rm -rf "${FUSE_DIR}" > /dev/null
		return 0
	fi
}

compile_unionfs_fuse() {
	if [ ! -f "${UNIONFS_FUSE_BINCACHE}" ]
	then

		# We'll call compile_fuse() from here, since it's not needed directly by anything else
		compile_fuse

		[ ! -f "${UNIONFS_FUSE_SRCTAR}" ] &&
			gen_die "Could not find unionfs-fuse source tarball: ${UNIONFS_FUSE_SRCTAR}. Please place it there, or place another version, changing /etc/genkernel.conf as necessary!"
		cd "${TEMP}"
		rm -rf "${UNIONFS_FUSE_DIR}"
		tar -xpf "${UNIONFS_FUSE_SRCTAR}"
		[ ! -d "${UNIONFS_FUSE_DIR}" ] &&
			gen_die "unionfs-fuse directory ${UNIONFS_FUSE_DIR} invalid"
		cd "${UNIONFS_FUSE_DIR}"
		apply_patches unionfs-fuse ${UNIONFS_FUSE_VER}
		print_info 1 'unionfs-fuse: >> Compiling...'
		sed -i "/^\(CFLAGS\|CPPFLAGS\)/s:^\\(.*\\)$:\\1 -static -I${TEMP}/${FUSE_DIR}/include -L${TEMP}/${FUSE_DIR}/lib/.libs:" Makefile src/Makefile
		sed -i "/^LIB = /s:^LIB = \(.*\)$:LIB = -static -L${TEMP}/${FUSE_DIR}/lib/.libs \1 -ldl -lpthread -lrt:" Makefile src/Makefile
		MAKE=${UTILS_MAKE} compile_generic "" ""
		print_info 1 'unionfs-fuse: >> Copying to cache...'
		[ -f "${TEMP}/${UNIONFS_FUSE_DIR}/src/unionfs" ] ||
			gen_die 'unionfs binary does not exist!'
		${UTILS_CROSS_COMPILE}strip "${TEMP}/${UNIONFS_FUSE_DIR}/src/unionfs" ||
			gen_die 'Could not strip unionfs binary!'
		bzip2 "${TEMP}/${UNIONFS_FUSE_DIR}/src/unionfs" ||
			gen_die 'bzip2 compression of unionfs binary failed!'
		mv "${TEMP}/${UNIONFS_FUSE_DIR}/src/unionfs.bz2" "${UNIONFS_FUSE_BINCACHE}" ||
			gen_die 'Could not copy the unionfs binary to the package directory, does the directory exist?'

		cd "${TEMP}"
		isTrue "${CMD_DEBUGCLEANUP}" && rm -rf "${UNIONFS_FUSE_DIR}" > /dev/null
		return 0
	fi
}

compile_iscsi() {
	if [ ! -f "${ISCSI_BINCACHE}" ]
	then
		[ ! -f "${ISCSI_SRCTAR}" ] &&
			gen_die "Could not find iSCSI source tarball: ${ISCSI_SRCTAR}. Please place it there, or place another version, changing /etc/genkernel.conf as necessary!"
		cd "${TEMP}"
		rm -rf "${ISCSI_DIR}"
		tar -xpf "${ISCSI_SRCTAR}"
		[ ! -d "${ISCSI_DIR}" ] &&
			gen_die "ISCSI directory ${ISCSI_DIR} invalid"
				print_info 1 'iSCSI: >> Compiling...'
		cd "${TEMP}/${ISCSI_DIR}"
		apply_patches iscsi ${ISCSI_VER}

		# Only build userspace
		print_info 1 'iSCSI: >> Configuring userspace...'
		cd utils/open-isns || gen_die 'Could not enter open-isns dir'
		# we currently have a patch that changes configure.ac
		# once given patch is dropped, drop autoconf too
		autoconf || gen_die 'Could not tweak open-iscsi configuration'
		./configure --without-slp >> ${LOGFILE} 2>&1 || gen_die 'Could not configure userspace'
		cd ../.. || gen_die 'wtf?'
		MAKE=${UTILS_MAKE} compile_generic "user" ""

		# if kernel modules exist, copy them to initramfs, otherwise it will be compiled into the kernel
		mkdir -p "${TEMP}/initramfs-iscsi-temp/lib/modules/${KV}/kernel/drivers/scsi/"
		KEXT=$(modules_kext)
		for modname in iscsi_tcp libiscsi scsi_transport_iscsi
		do
			module=${KERNEL_OUTPUTDIR}/drivers/scsi/${modname}${KEXT}
			if [ -e "${module}" ]
			then
				cp $module "${TEMP}/initramfs-iscsi-temp/lib/modules/${KV}/kernel/drivers/scsi/"
			fi
		done

	        cd "${TEMP}/initramfs-iscsi-temp/"
		print_info 1 'iscsistart: >> Copying to cache...'
		[ -f "${TEMP}/${ISCSI_DIR}/usr/iscsistart" ] ||
			gen_die 'iscsistart executable does not exist!'
		${UTILS_CROSS_COMPILE}strip "${TEMP}/${ISCSI_DIR}/usr/iscsistart" ||
			gen_die 'Could not strip iscsistart binary!'
		bzip2 "${TEMP}/${ISCSI_DIR}/usr/iscsistart" ||
			gen_die 'bzip2 compression of iscsistart failed!'
		mv "${TEMP}/${ISCSI_DIR}/usr/iscsistart.bz2" "${ISCSI_BINCACHE}" ||
			gen_die 'Could not copy the iscsistart binary to the package directory, does the directory exist?'

		cd "${TEMP}"
		isTrue "${CMD_DEBUGCLEANUP}" && rm -rf "${ISCSI_DIR}" > /dev/null
		return 0
	fi
}

compile_gpg() {
	if [ -f "${GPG_BINCACHE}" ]
	then
		print_info 1 "gnupg: >> Using cache"
	else
		[ ! -f "${GPG_SRCTAR}" ] &&
			gen_die "Could not find gnupg source tarball: ${GPG_SRCTAR}. Please place it there, or place another version, changing /etc/genkernel.conf as necessary!"
		cd "${TEMP}"
		rm -rf "${GPG_DIR}"
		tar -xf "${GPG_SRCTAR}"
		[ ! -d "${GPG_DIR}" ] &&
			gen_die "gnupg directory ${GPG_DIR} invalid"
		cd "${GPG_DIR}"
		apply_patches gnupg ${GPG_VER}
		print_info 1 'gnupg: >> Configuring...'
		# --enable-minimal works, but it doesn't reduce the command length much.
		# Given its history and the precision this needs, explicit is cleaner.
		LDFLAGS='-static' CFLAGS='-Os' ./configure --prefix=/ \
			--enable-static-rnd=linux --disable-dev-random --disable-asm \
			--disable-selinux-support --disable-gnupg-iconv --disable-card-support \
			--disable-agent-support --disable-bzip2 --disable-exec \
			--disable-photo-viewers --disable-keyserver-helpers --disable-ldap \
			--disable-hkp --disable-finger --disable-generic --disable-mailto \
			--disable-keyserver-path --disable-dns-srv --disable-dns-pka \
			--disable-dns-cert --disable-nls --disable-threads --disable-regex \
			--disable-optimization --with-included-zlib --without-capabilities \
			--without-tar --without-ldap --without-libcurl --without-mailprog \
			--without-libpth-prefix --without-libiconv-prefix --without-libintl-prefix\
			--without-zlib --without-bzip2 --without-libusb --without-readline \
				>> ${LOGFILE} 2>&1 || gen_die 'Configuring gnupg failed!'
		print_info 1 'gnupg: >> Compiling...'
		compile_generic "" "utils"
		print_info 1 'gnupg: >> Copying to cache...'
		[ -f "${TEMP}/${GPG_DIR}/g10/gpg" ] ||
			gen_die 'gnupg executable does not exist!'
		${UTILS_CROSS_COMPILE}strip "${TEMP}/${GPG_DIR}/g10/gpg" ||
			gen_die 'Could not strip gpg binary!'
		bzip2 -z -c "${TEMP}/${GPG_DIR}/g10/gpg" > "${GPG_BINCACHE}" ||
			gen_die 'Could not copy the gpg binary to the package directory, does the directory exist?'

		cd "${TEMP}"
		isTrue "${CMD_DEBUGCLEANUP}" && rm -rf "${GPG_DIR}" > /dev/null
		return 0
	fi
}
