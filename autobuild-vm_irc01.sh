#!/bin/sh -e
# Copyright aggi 2016

#export LATEST="20161226-1482779549"
#export RELDA="irc01-testing"
export CKERN="yes"
export LVSIZ="768"
export LVHOM="70"
export LVLOG="70"

source /home/autobuild/autobuild.sh

prepare_system
clean_portage
prepare_portage

export MACHINE="irc01"
export MACHID=44444443
export PKDIR="/home/packages/${MACHINE}/${RELDA}"
build_livecd_minimal_machine
#cp -p /home/seeds/${MACHINE}/${RELDA}/* /home/virtual/${MACHINE}
