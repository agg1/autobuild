#!/bin/sh
pkill -9 dnsmasq
sleep 1

systrace -d /usr/local/etc/systrace -ia /usr/sbin/dnsmasq -- --user=dnsmasq --group=dnsmasq --conf-file=/etc/dnsmasq.conf&
