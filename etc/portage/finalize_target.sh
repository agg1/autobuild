#!/bin/sh

uname -a > /etc/BUILDHOST

find /usr/lib/ -name '*.pyc' -delete
find /usr/lib/ -name '*.pyo' -delete
mkdir -p /var/log/audit
mkdir -p /var/log/archive
chmod 700 /var/log/audit
chmod 700 /var/log/archive
rm -rf /etc/portage/rootfs
rm -rf /etc/portage/patches
rm -f '/usr/share/applications/links_-g_%u-links-2.desktop'
rm -f /usr/share/applications/org.octave.Octave.desktop
rm -f /usr/share/applications/spyder-spyder.desktop
rm -f /usr/share/applications/spyder.desktop
# left-over from ipsvd
#rm -rf /html
rm -f /etc/portage/catalyst*
rm -f /etc/portage/kconfig*
rm -f /etc/portage/lzx.conf

echo /usr/lib/samba >> /etc/ld.so.conf
echo /usr/lib/libreoffice/program >> /etc/ld.so.conf
/sbin/ldconfig

chgrp input /usr/bin/Xorg 2>/dev/null
chmod u-s /usr/bin/Xorg 2>/dev/null
chmod g+s /usr/bin/Xorg 2>/dev/null

chmod 600 /etc/crylog

true
