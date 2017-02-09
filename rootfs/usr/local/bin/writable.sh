#!/bin/sh
TDIR=$1
[ -z "${TDIR}" -o ! -e "${TDIR}" ] && echo "directory error" && exit

WDIR="$(realpath ${TDIR})"

echo "### writable()"
if [ -e ${WDIR}/.writeable ] ; then
	echo "already writable"
else
	modprobe overlay || true
	rm -rf /home/livecd_overlay/upper/${WDIR} /home/livecd_overlay/work/${WDIR}
	mkdir -p /home/livecd_overlay/upper/${WDIR} /home/livecd_overlay/work/${WDIR}
	mount -t overlay overlay -o \
	rw,dirsync,sync,lowerdir=${WDIR},upperdir=/home/livecd_overlay/upper/${WDIR},workdir=/home/livecd_overlay/work/${WDIR} ${WDIR}
	touch ${WDIR}/.writeable
fi
