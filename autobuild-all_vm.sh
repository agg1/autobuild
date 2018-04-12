#!/bin/sh -e
# Copyright aggi 2017,2018

export LATEST=$1
export NEWDA="$(date +%Y%m%d-%s)"
export RELDA="${RELDA:-$NEWDA}"
export CKERN=yes
[ -z "${LATEST}" ] && echo "missing latest" && exit 1

if [ -f /tmp/.relda ]; then
	export RELDA=$(cat /tmp/.relda)
	#export NOCLEAN="true"
else
	:> /home/autolog/build.log
fi

source /home/autobuild/autobuild.sh
prepare_system

build_livecd_minimal_machine_img() {
	echo "### build_livecd_minimal_machine_img()"

	mkdir -p ${SDDIR}/${MACHINE}/${RELDA}

	groupadd -g ${MACHID} ${MACHINE} 2> /dev/null || true
	useradd -N -M -u ${MACHID} -g ${MACHINE} ${MACHINE} 2>/dev/null || true

	dd if=/dev/urandom of=${SDDIR}/${MACHINE}/${RELDA}/${MACHINE}.sys.img bs=4M count=${LVSIZ}
	dd if=/dev/urandom of=${SDDIR}/${MACHINE}/${RELDA}/${MACHINE}.cfg.img bs=1M count=${CFSIZ}
	chown ${MACHID}:${MACHID} ${SDDIR}/${MACHINE}/${RELDA}/${MACHINE}.*.img
	chmod 600 ${SDDIR}/${MACHINE}/${RELDA}/${MACHINE}.*.img

	if [ "${LVSIZ}" != "0" ]; then
		echo "preparing sys img"
		# prepare sys image
		cryptsetup close TMPVM 2>/dev/null || true
		echo "${LVPWS}" | hashalot -n 64 sha512 > /tmp/sysvm
		cryptsetup open ${SDDIR}/${MACHINE}/${RELDA}/${MACHINE}.sys.img TMPVM \
		--type plain --cipher aes-xts-plain64 --key-size 512 --hash sha512 --key-file /tmp/sysvm
		pvcreate -ff -y -Z y --metadatasize 1024k --metadatacopies 2 /dev/mapper/TMPVM
		sleep 1
		pvscan -a ay --cache
		vgcreate -s 16384k vgTMPVM /dev/mapper/TMPVM
		sleep 1
		vgscan --cache
		lvcreate -n lvhome -l ${LVHOM}%FREE vgTMPVM
		lvcreate -n lvlog -l ${LVLOG}%FREE vgTMPVM
		lvcreate -n lvswap -l 100%FREE vgTMPVM
		mkfs.ext4 -L LOG -b 4096 -O metadata_csum,64bit,encrypt /dev/mapper/vgTMPVM-lvlog
		mkfs.ext4 -L HOME -b 4096 -O metadata_csum,64bit,encrypt /dev/mapper/vgTMPVM-lvhome
		mkswap -L SWAP /dev/mapper/vgTMPVM-lvswap
		lvchange -an /dev/vgTMPVM/lvlog || true
		lvchange -an /dev/vgTMPVM/lvhome || true
		lvchange -an /dev/vgTMPVM/lvswap || true
		vgchange -an vgTMPVM || true
		cryptsetup close TMPVM
		pvscan -a ay --cache
		shred /tmp/sysvm
		rm -f /tmp/sysvm
	fi

	# prepare cfg disk
	mkfs.ext4 -L CFG -O metadata_csum ${SDDIR}/${MACHINE}/${RELDA}/${MACHINE}.cfg.img
	mkdir -p /tmp/${MACHINE}
	mount ${SDDIR}/${MACHINE}/${RELDA}/${MACHINE}.cfg.img /tmp/${MACHINE}

	/usr/local/bin/compilescript.sh ${CADIR}/cscripts/default/etc/cfg/${MACHINE} /tmp/${MACHINE}/cfg.sh
	if [ -e "${CADIR}/cfg/${MACHINE}/files/" ] ; then
		cp -pR ${CADIR}/cfg/${MACHINE}/files/* /tmp/${MACHINE} || true
	fi

	umount /tmp/${MACHINE}
}

### fw01
export LVSIZ="128"
export LVHOM="10"
export LVLOG="70"
export MACHINE="fw01"
export MACHID=44444440
export PKDIR="/home/packages/${MACHINE}/${RELDA}"
clean_stage
compile_csripts default
cp ${SDDIR}/minimal/${LATEST}/livecd-stage1-${TARCH}-latest.tar.bz2* ${BDDIR}
update_livecd_stage2 ${MACHINE}
#build_livecd_minimal_machine_img
#cp -p /home/seeds/${MACHINE}/${RELDA}/* /home/virtual/${MACHINE}

### irc01
export LVSIZ="768"
export LVHOM="70"
export LVLOG="70"
export MACHINE="irc01"
export MACHID=44444443
export PKDIR="/home/packages/${MACHINE}/${RELDA}"
clean_stage
compile_csripts default
cp ${SDDIR}/minimal/${LATEST}/livecd-stage1-${TARCH}-latest.tar.bz2* ${BDDIR}
update_livecd_stage2 ${MACHINE}
#build_livecd_minimal_machine_img
#cp -p /home/seeds/${MACHINE}/${RELDA}/* /home/virtual/${MACHINE}

### proxy01
export LVSIZ="128"
export LVHOM="10"
export LVLOG="70"
export MACHINE="proxy01"
export MACHID=44444444
export PKDIR="/home/packages/${MACHINE}/${RELDA}"
clean_stage
compile_csripts default
cp ${SDDIR}/minimal/${LATEST}/livecd-stage1-${TARCH}-latest.tar.bz2* ${BDDIR}
update_livecd_stage2 ${MACHINE}
#build_livecd_minimal_machine_img
#cp -p /home/seeds/${MACHINE}/${RELDA}/* /home/virtual/${MACHINE}

### tor01
export LVSIZ="128"
export LVHOM="10"
export LVLOG="70"
export MACHINE="tor01"
export MACHID=44444442
export PKDIR="/home/packages/${MACHINE}/${RELDA}"
clean_stage
compile_csripts default
cp ${SDDIR}/minimal/${LATEST}/livecd-stage1-${TARCH}-latest.tar.bz2* ${BDDIR}
update_livecd_stage2 ${MACHINE}
#build_livecd_minimal_machine_img
#cp -p /home/seeds/${MACHINE}/${RELDA}/* /home/virtual/${MACHINE}

### www01
export CFSIZ="64"
export LVSIZ="192"
export LVHOM="50"
export LVLOG="50"
export MACHINE="www01"
export MACHID=44444445
export PKDIR="/home/packages/${MACHINE}/${RELDA}"
clean_stage
compile_csripts default
cp ${SDDIR}/minimal/${LATEST}/livecd-stage1-${TARCH}-latest.tar.bz2* ${BDDIR}
update_livecd_stage2 ${MACHINE}
#build_livecd_minimal_machine_img
#cp -p /home/seeds/${MACHINE}/${RELDA}/* /home/virtual/${MACHINE}

sign_release
