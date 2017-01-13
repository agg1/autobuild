#!/bin/sh
PRIPID="$(cat /var/run/privoxy.pid)"
if [ ! -z "${PRIPID}" ] ;then
    kill -9 ${PRIPID}
fi
sleep 1

systrace -d /usr/local/etc/systrace -a /usr/sbin/privoxy -- --pidfile /var/run/privoxy.pid --user privoxy.privoxy --no-daemon /usr/local/etc/privoxy/config&

