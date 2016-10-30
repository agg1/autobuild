#!/bin/sh -e
# Copyright aggi 2016

source /home/catalyst/autobuild.sh
prepare_system

clean_portage
prepare_portage

build_seed_boot
build_seed_init
export PKDIR="/home/packages-minimal"
build_livecd_minimal
export PKDIR="/home/packages-admin"
build_livecd_admin
export PKDIR="/home/packages-desktop"
build_livecd_desktop
