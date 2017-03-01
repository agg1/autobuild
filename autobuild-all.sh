#!/bin/sh -e
# Copyright aggi 2016

cd /home/autobuild; git crypt unlock /media/backup/git/catalyst.gcr; cd -
cd /home/extra_overlay; git crypt unlock /media/backup/git/catalyst.gcr; cd -

source /home/autobuild/autobuild.sh
prepare_system

clean_portage
prepare_portage

build_seed_boot
build_seed_init
export PKDIR="/home/packages/minimal/${RELDA}"
build_livecd_minimal
export PKDIR="/home/packages/admin/${RELDA}"
build_livecd_admin
export PKDIR="/home/packages/desktop/${RELDA}"
build_livecd_desktop

archive_digests
commit_seed boot
commit_seed init
commit_seed minimal
commit_seed admin
commit_seed desktop
commit_seed portage
commit_seed kerncache
