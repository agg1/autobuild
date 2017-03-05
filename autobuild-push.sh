#!/bin/sh -e
# Copyright aggi 2017
/usr/local/bin/unlinkdirkey.sh /media/backup/git
/usr/local/bin/unlockdir.sh /media/backup/git
cd /home/autolog ; git push --tags origin master
cd /home/autobuild ; git push --tags origin master
cd /home/extra_overlay ; git push --tags origin master
cd /home/seeds ; git push --tags origin master
/usr/local/bin/unlinkdirkey.sh /media/backup/git
