#!/bin/sh -e
# Copyright aggi 2017,2018

export LATEST=$1
export NEWDA="$(date +%Y%m%d-%s)"
export RELDA="${RELDA:-$NEWDA}"
export CKERN=yes
[ -z "${LATEST}" ] && echo "missing latest" && exit 1

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

for vm in fw01 irc01 proxy01 tor01 www01 ; do
	/bin/sh autobuild-vm_${vm}.sh
done

#rm -rf /media/backup/virtual/*
for vm in fw01 irc01 proxy01 tor01 www01 ; do
	commit_seed ${vm}
	#mkdir -p /media/backup/virtual/${vm}
	#cp -vpR ${SDDIR}/${vm}/${RELDA}/* /media/backup/virtual/${vm}
done

sign_release
