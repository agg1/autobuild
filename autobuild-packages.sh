#!/bin/sh -e
# Copyright aggi 2017

export LATEST=$1
#export CLEAN=false
export CKERN=true
[ -z "${LATEST}" ] && echo "LATEST not set" && exit 1

cd /home/autobuild; git crypt unlock /media/backup/git/catalyst.gcr; cd -
git clean -df .
cd /home/extra_overlay; git crypt unlock /media/backup/git/catalyst.gcr; cd -
git clean -df .

source /home/autobuild/autobuild.sh
prepare_system

clean_portage
prepare_portage

export PKDIR="/home/packages/desktop/${LATEST}"
update_livecd_packages
