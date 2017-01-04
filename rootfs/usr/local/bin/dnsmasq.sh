#!/bin/sh
systrace -d /usr/local/etc/systrace -ia /usr/sbin/dnsmasq -- --user=dnsmasq --group=dnsmasq --conf-file=/etc/dnsmasq.conf&
