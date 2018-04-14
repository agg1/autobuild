#!/bin/sh -e
# Copyright aggi 2016,2017,2018

export LATEST=$1
[ -z "${LATEST}" ] && echo "LATEST not set" && exit 1

if [ -f /tmp/.relda ]; then
	export RELDA=$(cat /tmp/.relda)
else
	:> /home/autolog/build.log
fi

source /home/autobuild/autobuild.sh

# minimal
clean_stage
update_livecd_stage1 minimal
update_livecd_stage2 minimal
archive_kerncache

# admin
clean_stage
compile_csripts default
update_livecd_stage1 admin
update_livecd_stage2 admin

# desktop
clean_stage
compile_csripts default
update_livecd_stage1 desktop
# keep portage tree for package updates on desktop ISO
cp ${TMPDR}/catalyst/snapshots/* ${CDOVERLAY}
update_livecd_stage2 desktop

# full
clean_stage
compile_csripts default
update_livecd_stage1 full
# keep portage tree for package updates on desktop ISO
cp ${TMPDR}/catalyst/snapshots/* ${CDOVERLAY}
update_livecd_stage2 full

sign_release
