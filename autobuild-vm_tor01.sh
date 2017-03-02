#!/bin/sh -e
# Copyright aggi 2016

#export LATEST="20161226-1482779549"
#export RELDA="tor01-testing"
export CKERN="yes"
export LVSIZ="128"
export LVHOM="10"
export LVLOG="70"

source /home/autobuild/autobuild.sh
prepare_system

clean_portage
prepare_portage

export MACHINE="tor01"
export MACHID=44444442
export PKDIR="/home/packages/${MACHINE}/${RELDA}"
build_livecd_minimal_machine
#build_livecd_minimal_machine_img
#cp -p /home/seeds/${MACHINE}/${RELDA}/* /home/virtual/${MACHINE}
