#!/bin/sh

find /usr/lib/ -name '*.pyc' -delete
find /usr/lib/ -name '*.pyo' -delete
mkdir -p /var/log/audit
mkdir -p /var/log/archive
chmod 700 /var/log/audit
chmod 700 /var/log/archive
cat /tmp/.reldate > /etc/BUILDDATE
uname -a >> /etc/BUILDHOST
rm -rf /etc/portage/rootfs
rm -rf "/usr/share/applications/links_-g_%u-links-2.desktop"
rm -rf /etc/portage/patches
