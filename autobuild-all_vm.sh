#!/bin/sh -e
# Copyright aggi 2017

export LATEST="20161226-1482779549"
export RELDA="${LATEST}"

for vm in fw01 irc01 proxy01 tor01 www01 ; do
	/bin/sh autobuild-vm_${vm}.sh
done

archive_digests
for vm in fw01 irc01 proxy01 tor01 www01 ; do
	commit_seed ${vm}
done
