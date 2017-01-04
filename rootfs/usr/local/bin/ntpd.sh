#!/bin/sh
systrace -d /usr/local/etc/systrace -ia /usr/sbin/ntpd -- -g&
