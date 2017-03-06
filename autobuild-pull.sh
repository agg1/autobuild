#!/bin/sh -e
# Copyright aggi 2017
/usr/local/bin/unlinkdirkey.sh /media/backup/git
/usr/local/bin/unlockdir.sh /media/backup/git
cd /home/autolog ; git pull --ff-only origin master && git pull
cd /home/autobuild ; git pull --ff-only origin master && git pull
cd /home/extra_overlay ; git pull --ff-only origin master && git pull
cd /home/portage ; git pull --ff-only origin master && git pull
cd /home/seeds ; git pull --ff-only origin master && git pull
/usr/local/bin/unlinkdirkey.sh /media/backup/git
