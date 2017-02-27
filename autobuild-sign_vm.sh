#!/bin/sh -e
RELDA=$1

[ -z "${RELDA}" ] && echo "missing RELDA release date" && exit 1

# gpg signing params
export GPGDIR="${GPGDIR:-/home/autobuild/gpg}"
export GNUPGHOME=${GPGDIR}
#export GPGKEY="C03C6CA53E6068506C17EF246C8BD6DFEBA7AABB"

LOGDATE="$(date +%Y%m%d) "
LOGDEV="/dev/usb/lp0"
gitsigtaglog.sh -r /home/seeds		-t ${RELDA} -l /home/autolog/seeds.log
cp -p /home/autobuild/digests.log /home/autolog/digests.log
lprlog.sh -f /home/autolog/seeds.log		-p "${LOGDATE} seeds:"		-d ${LOGDEV} -n
lprlog.sh -f /home/autobuild/digests.log 	-p "${LOGDATE} digests:"	-d ${LOGDEV} -n

cd /home/autolog
git add digests.log
git add seeds.log
git commit -m "${RELDA}" .
git push origin master
