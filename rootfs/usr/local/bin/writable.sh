#!/bin/sh
WDIR=$1
[ -z "${WDIR}" -o ! -e "${WDIR}" ] && echo "directory error" && exit

echo "### writable()"
if [ -e ${WDIR}/.writeable ] ; then
	echo "already writable"
else
	modprobe overlay || true
	rm -rf /home/livecd_overlay/upper/${WDIR} /home/livecd_overlay/work/${WDIR}
	mkdir -p /home/livecd_overlay/upper/${WDIR} /home/livecd_overlay/work/${WDIR}
	mount -t overlay overlay -o rw,dirsync,sync,lowerdir=${WDIR},upperdir=/home/livecd_overlay/upper/${WDIR},workdir=/home/livecd_overlay/work/ ${WDIR}
	touch ${WDIR}/.writeable
fi
