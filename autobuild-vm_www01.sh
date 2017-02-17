#!/bin/sh -e
# Copyright aggi 2016

#export LATEST="20161226-1482779549"
#export RELDA="www01-testing"
export CKERN="yes"
export CFSIZ="64"
export LVSIZ="192"
export LVHOM="50"
export LVLOG="50"

cd /home/autobuild; git crypt unlock /media/backup/git/catalyst.gcr; cd -
cd /home/extra_overlay; git crypt unlock /media/backup/git/catalyst.gcr; cd -

source /home/autobuild/autobuild.sh
prepare_system

clean_portage
prepare_portage

export MACHINE="www01"
export MACHID=44444445
export PKDIR="/home/packages/${MACHINE}/${RELDA}"
build_livecd_minimal_machine
#build_livecd_minimal_machine_img
#cp -p /home/seeds/${MACHINE}/${RELDA}/* /home/virtual/${MACHINE}
