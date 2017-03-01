#!/bin/sh -e
# Copyright aggi 2017
cd /home/autolog ; git push --tags origin master
cd /home/autobuild ; git push --tags origin master
cd /home/extra_overlay ; git push --tags origin master
cd /home/seeds ; git push --tags origin master
