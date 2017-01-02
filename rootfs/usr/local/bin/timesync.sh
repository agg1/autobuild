#!/bin/sh

[ -e /etc/.notimesync ] && exit 0

mount -o remount,rw /etc 2> /dev/null

#ptbtime1.ptb.de
TIMESYNC=$(sg wanout -c "ntpdate 192.53.103.108 2>&1" 2>&1)
logger "TIMESYNC ${TIMESYNC}"
hwclock --systohc

#mount -o remount,ro /etc 2> /dev/null
