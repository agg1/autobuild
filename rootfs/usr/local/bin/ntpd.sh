#!/bin/sh
pkill -9 ntpd
systrace -d /usr/local/etc/systrace -ia /usr/sbin/ntpd -- -g&
