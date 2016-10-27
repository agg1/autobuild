#!/bin/sh -e
# Copyright aggi 2016

source /home/catalyst/autobuild.sh
prepare_system

clean_portage
prepare_portage

export PKDIR="/home/packages-minimal"
update_livecd_minimal
export PKDIR="/home/packages-desktop"
update_livecd_desktop
