#!/bin/sh -e
# Copyright aggi 2018

#cd /home/autobuild ; git clean -df .
#git crypt unlock /media/backup/git/catalyst.gcr; cd -
#cd /home/extra_overlay ; git clean -df .
#git crypt unlock /media/backup/git/catalyst.gcr; cd -

if [ -f /tmp/.relda ]; then
	export RELDA=$(cat /tmp/.relda)
fi

source /home/autobuild/autobuild.sh
prepare_system
prepare_portage

#sync_portage
##fetch_portage
#fetch_wget
fetch_catalyst
