#!/bin/sh -e
RELDA=$1

[ -z "${RELDA}" ] && echo "param error" && exit 1

# gpg signing params
export GPGDIR="${GPGDIR:-/home/autobuild/gpg}"
export GNUPGHOME=${GPGDIR}
#export GPGKEY="C03C6CA53E6068506C17EF246C8BD6DFEBA7AABB"

LOGDATE="$(date +%Y%m%d) "
LOGDEV="/dev/usb/lp0"
gitsigtaglog.sh -r /home/autobuild	-t ${RELDA} -l /home/autolog/autobuild.log
gitsigtaglog.sh -r /home/seeds		-t ${RELDA} -l /home/autolog/seeds.log
gitsigtaglog.sh -r /home/portage	-t ${RELDA} -l /home/autolog/portage.log
gitsigtaglog.sh -r /home/extra_overlay	-t ${RELDA} -l /home/autolog/extra_overlay.log
cp -p /home/autobuild/digests.log /home/autolog/digests.log
lprlog.sh -f /home/autolog/autobuild.log	-p "${LOGDATE} autobuild:"	-d ${LOGDEV} -n
lprlog.sh -f /home/autolog/seeds.log		-p "${LOGDATE} seeds:"		-d ${LOGDEV} -n
lprlog.sh -f /home/autolog/portage.log		-p "${LOGDATE} portage:"	-d ${LOGDEV} -n
lprlog.sh -f /home/autolog/extra_overlay.log	-p "${LOGDATE} extra_overlay:"	-d ${LOGDEV} -n
lprlog.sh -f /home/autobuild/digests.log 	-p "${LOGDATE} digests:"	-d ${LOGDEV} -n

cd /home/autolog
git add digests.log
git add autobuild.log
git add seeds.log
git add portage.log
git add extra_overlay.log
git commit -m "${RELDA}" .
git push origin master
