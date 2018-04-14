#!/bin/sh -e
# Copyright aggi 2016,2017,2018

export LATEST=$1
[ -z "${LATEST}" ] && echo "LATEST not set" && exit 1

:> /home/autolog/build.log
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
cp ${TMP_DIR}/catalyst/snapshots/* ${CDROM_OVERLAY}
update_livecd_stage2 desktop

# full
clean_stage
compile_csripts default
update_livecd_stage1 full
# keep portage tree for package updates on desktop ISO
cp ${TMP_DIR}/catalyst/snapshots/* ${CDROM_OVERLAY}
update_livecd_stage2 full

sign_release
