#!/bin/sh -e
# Copyright aggi 2016

rm -f build.log

LATEST=20161117-1479426114
PTREE=/home/seeds/gentoo/portage-hardened.tar

source /home/catalyst/autobuild.sh
prepare_system

clean_portage
prepare_portage

build_seed_boot
build_seed_init
export PKDIR="/home/packages-minimal" ; rm -rf ${PKDIR}/*
build_livecd_minimal
export PKDIR="/home/packages-admin" ; rm -rf ${PKDIR}/*
build_livecd_admin
export PKDIR="/home/packages-desktop" ; rm -rf ${PKDIR}/*
build_livecd_desktop

archive_digests
