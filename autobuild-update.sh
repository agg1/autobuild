#!/bin/sh -e
# Copyright aggi 2016,2017,2018

export LATEST=$1
#export CKERN=true
#export LATEST=20161126-1480193160
[ -z "${LATEST}" ] && echo "LATEST not set" && exit 1

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

export PKDIR="/home/packages/minimal/${LATEST}"
update_livecd_minimal 2>&1 | tee -a /home/autolog/build.log

export PKDIR="/home/packages/admin/${LATEST}"
update_livecd_admin 2>&1 | tee -a /home/autolog/build.log

export PKDIR="/home/packages/desktop/${LATEST}"
update_livecd_desktop 2>&1 | tee -a /home/autolog/build.log

sign_release
