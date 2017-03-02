#!/bin/sh -e
umount /media/backup 2>/dev/null
mount /dev/mapper/backup /media/backup
unlockdir.sh /media/backup/git/
cd /home/extra_overlay ; git crypt unlock /media/backup/git/catalyst.gcr
cd /home/autobuild ; git crypt unlock /media/backup/git/catalyst.gcr
