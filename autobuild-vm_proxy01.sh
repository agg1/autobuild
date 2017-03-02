#!/bin/sh -e
# Copyright aggi 2016

#export LATEST="20161226-1482779549"
#export RELDA="proxy01-testing"
export CKERN="yes"
export LVSIZ="128"
export LVHOM="10"
export LVLOG="70"

source /home/autobuild/autobuild.sh
prepare_system

clean_portage
prepare_portage

export MACHINE="proxy01"
export MACHID=44444444
export PKDIR="/home/packages/${MACHINE}/${RELDA}"
build_livecd_minimal_machine
#cp -p /home/seeds/${MACHINE}/${RELDA}/* /home/virtual/${MACHINE}
