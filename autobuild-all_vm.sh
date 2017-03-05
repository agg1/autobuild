#!/bin/sh -e
# Copyright aggi 2017

export LATEST=$1
export NEWDA="$(date +%Y%m%d-%s)"
export RELDA="${RELDA:-$NEWDA}"
export CKERN=yes
[ -z "${LATEST}" ] && echo "missing latest" && exit 1

cd /home/autobuild ; git clean -df .
git crypt unlock /media/backup/git/catalyst.gcr; cd -
cd /home/extra_overlay ; git clean -df .
git crypt unlock /media/backup/git/catalyst.gcr; cd -

source /home/autobuild/autobuild.sh
prepare_system

for vm in fw01 irc01 proxy01 tor01 www01 ; do
	/bin/sh autobuild-vm_${vm}.sh
done

archive_digests
rm -rf /media/backup/virtual/*
for vm in fw01 irc01 proxy01 tor01 www01 ; do
	mkdir -p /media/backup/virtual/${vm}
	cp -vpR ${SDDIR}/${vm}/${RELDA}/* /media/backup/virtual/${vm}
	commit_seed ${vm}
done
commit_seed kerncache
commit_seed portage
