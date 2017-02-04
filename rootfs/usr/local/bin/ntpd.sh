#!/bin/sh
NTPPID="$(cat /var/run/ntpd.pid)"
if [ ! -z "${NTPPID}" ] ;then
    kill -9 ${NTPPID}
fi
sleep 1

systrace -d /usr/local/etc/systrace -ia /usr/sbin/ntpd -- -g -u ntp -p /var/run/ntpd.pid&
