#!/bin/sh -e
# Copyright aggi 2016

export LATEST="20161222-1482429576"
export RELDA="tor01-testing"
export PTREE=/home/seeds/portage/${LATEST}/portage-latest.tar.bz2
export CKERN="yes"

source /home/catalyst/autobuild.sh
prepare_system

clean_portage
prepare_portage

export PKDIR="/tmp/packages-tor01" ; rm -rf ${PKDIR}/*
build_livecd_tor01
dd if=/dev/urandom of=/home/seeds/tor01/${RELDA}/tor01.cfg.img bs=1M count=2
groupadd -g 44444441 tor01 2> /dev/null || true
useradd -N -M -u 44444441 -g tor01 tor01 2>/dev/null || true
chown 44444441:44444441 /home/seeds/tor01/${RELDA}/tor01.cfg.img
mkfs.ext4 -O metadata_csum /home/seeds/tor01/${RELDA}/tor01.cfg.img
e2label /home/seeds/tor01/${RELDA}/tor01.cfg.img CFG
mkdir -p /tmp/tor01
mount /home/seeds/tor01/${RELDA}/tor01.cfg.img /tmp/tor01
#/usr/local/bin/obfsh -g 128-8+128-256 -i -f /home/catalyst/cfg/tor01/cfg.sh
CFLAGS="-nopie -fno-pie" /usr/bin/shc -f /home/catalyst/cfg/tor01/cfg.sh
rm -f /home/catalyst/cfg/tor01/cfg.sh.x.c
chmod 730 /home/catalyst/cfg/tor01/cfg.sh.x
mv /home/catalyst/cfg/tor01/cfg.sh.x /tmp/tor01/cfg.sh
umount /tmp/tor01
