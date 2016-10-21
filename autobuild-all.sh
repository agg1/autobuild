#!/bin/sh -e
# Copyright aggi 2016

NEWDA="$(date +%Y%m%d-%s)"
export MAKEOPTS="${MAKEOPTS:--j12}"
export STAMP="${STAMP:-latest}"
export TARGT=""
export CCONF="${CCONF:-/home/catalyst/catalyst-cache.conf}"
export CADIR="/home/catalyst"
export RELDA="${RELDA:-$NEWDA}"
export BDDIR="${BDDIR:-/var/tmp/catalyst/builds/hardened}"
export SDDIR="${SDDIR:-/home/seeds}"
export PKDIR="${PKDIR:-/home/packages}"
export DFDIR="${DFDIR:-/home/distfiles}"
export PTREE="${PTREE:-${SDDIR}/portage-latest.tar.bz2}"
export RODIR="${RODIR:-${CADIR}/rootfs}"


export PTREE="/home/seeds/portage/20161001/portage.tar"
export PKDIR="/home/packages-desktop"

source /home/catalyst/autobuild.sh
prepare_system

clean_portage
prepare_portage
build_seed_init
build_seed
build_livecd_minimal
build_livecd_desktop
