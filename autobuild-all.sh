#!/bin/sh -e
# Copyright aggi 2016

cd /home/autobuild ; git clean -df .
git crypt unlock /media/backup/git/catalyst.gcr; cd -
cd /home/extra_overlay ; git clean -df .
git crypt unlock /media/backup/git/catalyst.gcr; cd -

#if [ -f /tmp/.relda ]; then
#	export RELDA=$(cat /tmp/.relda)
#fi

source /home/autobuild/autobuild.sh
prepare_system

clean_portage
prepare_portage

#sync_portage
##fetch_portage
#fetch_wget
#fetch_catalyst

build_seed_boot
build_seed_init
export PKDIR="/home/packages/minimal/${RELDA}"
rm -rf /home/packages/minimal/*
build_livecd_minimal
export PKDIR="/home/packages/admin/${RELDA}"
rm -rf /home/packages/admin/*
build_livecd_admin
export PKDIR="/home/packages/desktop/${RELDA}"
rm -rf /home/packages/desktop/*
build_livecd_desktop
export PKDIR="/home/packages/desktop/${RELDA}"
#build_livecd_packages

archive_digests
commit_seed boot
commit_seed init
commit_seed minimal
commit_seed admin
commit_seed desktop
commit_seed portage
commit_seed kerncache
