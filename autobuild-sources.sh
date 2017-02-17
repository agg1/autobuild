#!/bin/sh

umask 022

for i in data infra proj repo report sites ; do
	cd /home/source/portage/${i}
	for r in $(ls) ; do
		echo /home/source/portage/${i}/${r}
		cd /home/source/portage/${i}/${r}
		git fsck
		sg wanout -c "git pull --rebase"
		cd -
	done
done

