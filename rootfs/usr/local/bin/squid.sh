#!/bin/sh
SQUPID="$(cat /var/run/squid.pid)"
if [ ! -z "${SQUPID}" ] ;then
    kill ${SQUPID}
fi
sleep 2

mkdir -p /tmp/squid/
chown squid:squid /tmp/squid/
chmod 700 /tmp/squid/
htpasswd -b -c /tmp/squid/passwd squid squid0815
rm -rf /var/cache/squid/*
/usr/sbin/squid -f /usr/local/etc/squid/squid.conf -z
sync
sleep 3

systrace -d /usr/local/etc/systrace -a /usr/sbin/squid -- -f /usr/local/etc/squid/squid.conf -s &
