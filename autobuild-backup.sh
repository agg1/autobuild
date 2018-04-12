#!/bin/sh -e
/usr/local/bin/unlinkdirkey.sh /media/backup/git
/usr/local/bin/unlockdir.sh /media/backup/git

# rsync distfiles
[ -e /home/distfiles/ -a -e /media/backup/distfiles/ ] && \
rsync -av /home/distfiles/ /media/backup/distfiles/
rsync -av /media/backup/distfiles/ /home/distfiles/

[ -e /home/packages/ -a -e /media/backup/packages/ ] && \
rsync -av --delete /media/backup/packages/ /home/packages/

cd /home/autolog
git fsck ; git gc
git reflog expire --expire=now --all ; git gc --prune=now
git fsck
git pull --ff-only origin master && git pull

cd /home/seeds
git pull --ff-only origin master && git pull

for d in autobuild extra_overlay portage ; do
	cd /media/backup/git/${d}.git
	git fsck ; git gc
	git reflog expire --expire=now --all ; git gc --prune=now
	git fsck
	cd /home/${d}
	git fsck ; git gc
	git pull --ff-only origin master && git pull
	git push --tags origin master
done

for d in autobuild autolog extra_overlay ; do
	cd /home/${d}
	git fsck ; git gc
	git reflog expire --expire=now --all ; git gc --prune=now
	git fsck
	sg lanout -c "git push --tags www02 master || true" || true
done
for d in autobuild autolog extra_overlay portage ; do
	cd /home/${d}
	sg wanout -c "git push --tags github master || true" || true
done
/usr/local/bin/unlinkdirkey.sh /media/backup/git
