#!/bin/sh -e
# Copyright aggi 2016

NEWDA="$(date +%Y%m%d-%s)"
export RELDA="${RELDA:-$NEWDA}"
export PTREE="${PTREE:-${SDDIR}/portage-latest.tar.bz2}"
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
