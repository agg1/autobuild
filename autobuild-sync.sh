#!/bin/sh -e

# rsync distfiles
[ -e /home/distfiles/ -a -e /media/backup/distfiles/ ] && \
rsync -av /home/distfiles/ /media/backup/distfiles/
rsync -av /media/backup/distfiles/ /home/distfiles/

for d in autobuild seeds extra_overlay portage ; do
	cd $HOME/${d}
	git fsck
	git pull --rebase origin master
	git push --tags origin master
done
