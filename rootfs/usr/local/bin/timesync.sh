#!/bin/sh

#ptbtime1.ptb.de
sg wanout -c "ntpdate 192.53.103.108"
hwclock --systohc
