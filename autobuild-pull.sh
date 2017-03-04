#!/bin/sh -e
# Copyright aggi 2017
/usr/local/bin/unlockdir.sh /media/backup/git
cd /home/autolog ; git pull --ff-only origin master
cd /home/autobuild ; git pull --ff-only origin master
cd /home/extra_overlay ; git pull --ff-only origin master
cd /home/seeds ; git pull --ff-only origin master
