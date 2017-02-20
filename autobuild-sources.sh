#!/bin/sh

umask 022

for i in data infra proj repo report sites ; do
	cd /home/source/portage/${i}
	for r in $(ls) ; do
		[ ! -e /home/source/portage/${i}/${r}/.git ] && continue
		echo "syncing /home/source/portage/${i}/${r}"
		cd /home/source/portage/${i}/${r}
		git reset --hard ; git clean -f ; git fsck
		sg wanout -c "git pull --rebase"
		cd -
	done
done

