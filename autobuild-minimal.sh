#!/bin/sh -e
# Copyright aggi 2016
export LATEST=minimal-testing
export RELDA=minimal-testing
export CLEAN=false
CKERN="yes"

#cd /home/autobuild; git crypt unlock /media/backup/git/catalyst.gcr; cd -
#cd /home/extra_overlay; git crypt unlock /media/backup/git/catalyst.gcr; cd -

source /home/autobuild/autobuild.sh
prepare_system

clean_portage
prepare_portage

#build_seed_boot
#build_seed_init
export PKDIR="/home/packages/minimal/${RELDA}"
build_livecd_minimal

#archive_digests
#commit_seed minimal
