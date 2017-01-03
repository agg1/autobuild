#!/bin/sh -e
# Copyright aggi 2016

export LATEST="20161226-1482779549"
export RELDA="fw01-testing"
export PTREE=/home/seeds/portage/${LATEST}/portage-latest.tar.bz2
export CKERN="yes"

source /home/catalyst/autobuild.sh
prepare_system

clean_portage
prepare_portage

export MACHINE="fw01"
export MACHID=44444440
export PKDIR="/tmp/packages-${MACHINE}" ; rm -rf ${PKDIR}/*
build_livecd_minimal_machine
#cp -p /home/seeds/${MACHINE}/${RELDA}/* /home/virtual/${MACHINE}
