#!/bin/sh -e
# Copyright aggi 2016

export LATEST="20161220-1482271055"
export RELDA="tor01-testing"
export PTREE=/home/seeds/portage/${LATEST}/portage-latest.tar.bz2
export CKERN="yes"

source /home/catalyst/autobuild.sh
prepare_system

clean_portage
prepare_portage

export PKDIR="/tmp/packages-tor01" ; rm -rf ${PKDIR}/*
build_livecd_tor01

