#!/bin/sh -e
# Copyright aggi 2017

export LATEST=$1
export CLEAN=true
export CKERN=false
[ -z "${LATEST}" ] && echo "LATEST not set" && exit 1

#git clean -df .
#cd /home/autobuild; git crypt unlock /media/backup/git/catalyst.gcr; cd -
#git clean -df .
#cd /home/extra_overlay; git crypt unlock /media/backup/git/catalyst.gcr; cd -

source /home/autobuild/autobuild.sh
prepare_system

clean_portage
prepare_portage

export PKDIR="/home/packages/flash/${LATEST}"
update_livecd_flash
