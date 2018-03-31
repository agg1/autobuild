#!/bin/sh -e
# Copyright aggi 2016

export LATEST="20161226-1482779549"
export RELDA="padwalker"
export CKERN="yes"
export LVSIZ="0"
export LVHOM="10"
export LVLOG="70"

source /home/autobuild/autobuild.sh
prepare_system

export MACHINE="padwalker"
export MACHID=66669999
export PKDIR="/home/packages/${MACHINE}/${RELDA}"

for i in $(ls /home/catalyst/cfg/padwalker/infiles ) ; do
	/usr/local/bin/compilescript.sh /home/autobuild/cfg/padwalker/infiles/$i \
	/home/autobuild/cfg/padwalker/files/$i
	chmod 700 /home/autobuild/cfg/padwalker/files/$i
done

build_livecd_minimal_machine_img
