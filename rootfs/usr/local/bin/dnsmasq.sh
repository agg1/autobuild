#!/bin/sh
DNSMPID=$(cat /var/run/dnsmasq.pid)
if [ ! -z "${DNSMPID}" ] ;then
	kill -9 ${DNSMPID}
fi
sleep 1

systrace -d /usr/local/etc/systrace -ia /usr/sbin/dnsmasq -- --user=dnsmasq --group=dnsmasq --conf-file=/etc/dnsmasq.conf --pid-file /var/run/dnsmasq.pid &
