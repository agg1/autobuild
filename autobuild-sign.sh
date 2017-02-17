#!/bin/sh -e
RELDA=$1

[ -z "${RELDA}" ] && echo "param error" && exit 1

LOGDATE="$(date +%Y%m%d) "
LOGDEV="/dev/usb/lp0"
gitsigtaglog.sh /home/autobuild		${RELDA} /home/autolog/${RELDA}-autobuild.log
gitsigtaglog.sh /home/seeds		${RELDA} /home/autolog/${RELDA}-seeds.log
gitsigtaglog.sh /home/portage		${RELDA} /home/autolog/${RELDA}-portage.log
gitsigtaglog.sh /home/extra_overlay	${RELDA} /home/autolog/${RELDA}-extra_overlay.log
lprlog.sh -f /home/autobuild/digests.log 		-p "${LOGDATE} digests:"	-d ${LOGDEV}
lprlog.sh -f /home/autolog/${RELDA}-autobuild.log	-p "${LOGDATE} autobuild:"	-d ${LOGDEV}
lprlog.sh -f /home/autolog/${RELDA}-seeds.log		-p "${LOGDATE} seeds:"		-d ${LOGDEV}
lprlog.sh -f /home/autolog/${RELDA}-portage.log		-p "${LOGDATE} portage:"	-d ${LOGDEV}
lprlog.sh -f /home/autolog/${RELDA}-extra_overlay.log	-p "${LOGDATE} extra_overlay:"	-d ${LOGDEV}
