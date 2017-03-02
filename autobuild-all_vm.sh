#!/bin/sh -e
# Copyright aggi 2017

export LATEST=$1
export RELDA="${LATEST}"
export CKERN=yes
[ -z "${LATEST}" ] && echo "missing latest" && exit 1

cd /home/autobuild; git crypt unlock /media/backup/git/catalyst.gcr; cd -
git clean -df .
cd /home/extra_overlay; git crypt unlock /media/backup/git/catalyst.gcr; cd -
git clean -df .

for vm in fw01 irc01 proxy01 tor01 www01 ; do
	/bin/sh autobuild-vm_${vm}.sh
done

archive_digests
for vm in fw01 irc01 proxy01 tor01 www01 ; do
	commit_seed ${vm}
done
