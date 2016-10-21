#!/bin/sh -e
# Copyright aggi 2016

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
