#!/bin/sh -e
# Copyright aggi 2016,2017,2018

if [ -f /tmp/.relda ]; then
	export RELDA=$(cat /tmp/.relda)
	export NOCLEAN="true"
else
	:> /home/autolog/build.log
fi

source /home/autobuild/autobuild.sh

prepare_system
clean_portage
prepare_portage

sync_portage
#fetch_portage
fetch_wget
fetch_catalyst

build_seed_boot
build_seed_init

export PKDIR="/home/packages/minimal/${RELDA}"
rm -rf /home/packages/minimal/*
build_livecd_minimal 2>&1 | tee -a /home/autolog/build.log

export PKDIR="/home/packages/admin/${RELDA}"
rm -rf /home/packages/admin/*
build_livecd_admin  2>&1 | tee -a /home/autolog/build.log

export PKDIR="/home/packages/desktop/${RELDA}"
rm -rf /home/packages/desktop/*
build_livecd_desktop 2>&1 | tee -a /home/autolog/build.log

export PKDIR="/home/packages/desktop/${RELDA}"
build_livecd_packages

sign_release
