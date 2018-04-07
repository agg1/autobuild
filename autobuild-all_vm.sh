#!/bin/sh -e
# Copyright aggi 2017,2018

export LATEST=$1
export NEWDA="$(date +%Y%m%d-%s)"
export RELDA="${RELDA:-$NEWDA}"
export CKERN=yes
[ -z "${LATEST}" ] && echo "missing latest" && exit 1

if [ -f /tmp/.relda ]; then
	export RELDA=$(cat /tmp/.relda)
	#export NOCLEAN="true"
else
	:> /home/autolog/autobuild.log
fi

source /home/autobuild/autobuild.sh
prepare_system

for vm in fw01 irc01 proxy01 tor01 www01 ; do
	/bin/sh autobuild-vm_${vm}.sh
done

sign_release
