#!/bin/sh -e
# Copyright aggi 2016
PTREE=/home/seeds/gentoo/portage-hardened.tar
source /home/catalyst/autobuild.sh
prepare_system

clean_portage
prepare_portage

export PKDIR="/home/packages-minimal"
update_livecd_minimal
export PKDIR="/home/packages-admin"
update_livecd_admin
export PKDIR="/home/packages-desktop"
update_livecd_desktop

archive_digests
