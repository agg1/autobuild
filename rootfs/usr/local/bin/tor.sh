#!/bin/sh
TORPID="$(cat /var/run/tor/tor.pid)"
if [ ! -z "${TORPID}" ] ;then
    kill -9 ${TORPID}
fi
sleep 1

mkdir -p /var/log/tor 2>/dev/null
chown -R tor:tor /var/log/tor 2>/dev/null
chmod 700 /var/log/tor
sg wanout -c "systrace -d /usr/local/etc/systrace -a /usr/bin/tor -- --defaults-torrc /usr/local/etc/tor/torrc "&

