#!/bin/sh -e
# Copyright aggi 2017

export LATEST=$1
#export CLEAN=false
export CKERN=true
[ -z "${LATEST}" ] && echo "LATEST not set" && exit 1

if [ -f /tmp/.relda ]; then
	export RELDA=$(cat /tmp/.relda)
	export NOCLEAN="true"
else
	:> /home/autolog/build.log
fi

source /home/autobuild/autobuild.sh
prepare_system

export PKDIR="/home/packages/desktop/${LATEST}"
update_livecd_packages
