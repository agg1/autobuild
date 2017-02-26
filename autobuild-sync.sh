#!/bin/sh -e

# rsync distfiles
[ -e /home/distfiles/ -a -e /media/backup/distfiles/ ] && \
rsync -av /home/distfiles/ /media/backup/distfiles/
rsync -av /media/backup/distfiles/ /home/distfiles/

[ -e /home/packages/ -a -e /media/backup/packages/ ] && \
rsync -av /media/backup/packages/ /home/packages/

cd /home/seeds
git pull --rebase origin master
git push --tags origin master

for d in autobuild extra_overlay portage ; do
	cd /media/backup/git/${d}.git
	git fsck
	cd /home/${d}
	git fsck
	git pull --rebase origin master
	git push --tags origin master
done

for d in autobuild extra_overlay ; do
	cd /home/${d}
	sg lanout -c "git push --tags www02 master || true" || true
done
for d in autobuild extra_overlay portage ; do
	cd /home/${d}
	sg wanout -c "git push --tags github master || true" || true
done
