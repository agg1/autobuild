#!/bin/sh
pkill -9 ntpd
sleep 1

systrace -d /usr/local/etc/systrace -ia /usr/sbin/ntpd -- -g&
