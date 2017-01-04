#!/bin/sh
mkdir -p /var/log/tor 2>/dev/null
chown -R tor:tor /var/log/tor 2>/dev/null
sg wanout -c "systrace -d /usr/local/etc/systrace -a /usr/bin/tor -- --defaults-torrc /usr/local/etc/tor/torrc-relay "&
