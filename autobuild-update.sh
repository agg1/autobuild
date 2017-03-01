#!/bin/sh -e
# Copyright aggi 2016

export CLEAN=false
export CKERN=true
#export LATEST=20161126-1480193160
[ -z "${LATEST}" ] && echo "LATEST not set" && exit 1

cd /home/autobuild; git crypt unlock /media/backup/git/catalyst.gcr; cd -
cd /home/extra_overlay; git crypt unlock /media/backup/git/catalyst.gcr; cd -

source /home/autobuild/autobuild.sh
prepare_system

clean_portage
prepare_portage

export PKDIR="/home/packages/minimal/${LATEST}"
update_livecd_minimal
export PKDIR="/home/packages/admin/${LATEST}"
update_livecd_admin
export PKDIR="/home/packages/desktop/${LATEST}"
update_livecd_desktop

archive_digests
commit_seed boot
commit_seed init
commit_seed minimal
commit_seed admin
commit_seed desktop
