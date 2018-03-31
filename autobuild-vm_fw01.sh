#!/bin/sh -e
# Copyright aggi 2016

export CKERN="yes"
export LVSIZ="128"
export LVHOM="10"
export LVLOG="70"

source /home/autobuild/autobuild.sh
prepare_system

export MACHINE="fw01"
export MACHID=44444440
export PKDIR="/home/packages/${MACHINE}/${RELDA}"
build_livecd_minimal_machine 2>&1 | tee -a /home/autolog/build.log
#build_livecd_minimal_machine_img
#cp -p /home/seeds/${MACHINE}/${RELDA}/* /home/virtual/${MACHINE}
