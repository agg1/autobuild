#!/bin/sh -e
# Copyright aggi 2016

export LATEST="20161226-1482779549"
export RELDA="padwalker"
export PTREE=/home/seeds/portage/${LATEST}/portage-latest.tar.bz2
export CKERN="yes"
export LVSIZ="0"
export LVHOM="10"
export LVLOG="70"

source /home/catalyst/autobuild.sh
prepare_system

clean_portage
prepare_portage
umount /var/tmp/catalyst/builds || true

export MACHINE="padwalker"
export MACHID=66669999
export PKDIR="/home/packages/packages-${MACHINE}" ; rm -rf ${PKDIR}/*

for i in $(ls /home/catalyst/cfg/padwalker/infiles ) ; do
	/usr/local/bin/compilescript.sh /home/catalyst/cfg/padwalker/infiles/$i \
	/home/catalyst/cfg/padwalker/files/$i
	chmod 700 /home/catalyst/cfg/padwalker/files/$i
done

build_livecd_minimal_machine_img
