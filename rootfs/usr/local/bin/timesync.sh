#!/bin/sh

mount -o remount,rw /etc 2> /dev/null

#ptbtime1.ptb.de
sg wanout -c "ntpdate 192.53.103.108"
hwclock --systohc

#mount -o remount,ro /etc 2> /dev/null
