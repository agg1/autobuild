#!/bin/sh -e
# Copyright aggi 2017
cd /home/autolog ; git pull --ff-only origin master
cd /home/autobuild ; git pull --ff-only origin master
cd /home/extra_overlay ; git pull --ff-only origin master
cd /home/seeds ; git pull --ff-only origin master
