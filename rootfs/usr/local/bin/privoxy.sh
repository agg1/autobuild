#!/bin/sh
pkill -9 privoxy
sleep 1

systrace -d /usr/local/etc/systrace -a /usr/sbin/privoxy -- --pidfile /var/run/privoxy.pid --user privoxy.privoxy /usr/local/etc/privoxy/config&

