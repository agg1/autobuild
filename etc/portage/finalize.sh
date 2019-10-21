#!/bin/sh

uname -a > /etc/BUILDHOST

find /usr/lib/ -name '*.pyc' -delete
find /usr/lib/ -name '*.pyo' -delete
mkdir -p /var/log/audit
mkdir -p /var/log/archive
chmod 700 /var/log/audit
chmod 700 /var/log/archive
rm -f /var/log/emerge.log
rm -f /var/log/genkernel.log
rm -f /var/log/emerge-fetch.log
chmod 640 /etc/doas.conf
rm -f /etc/portage/finalize_target.sh
rm -rf /etc/portage/cscriptoverlay
rm -rf /etc/portage/cdtar
rm -rf /etc/portage/env
rm -rf /etc/portage/initramfs
rm -rf /etc/portage/rootfs
rm -rf /etc/portage/package*
rm -rf /etc/portage/patches
#rm -rf /etc/portage/profile
rm -f /etc/portage/genkernel.conf
rm -f /etc/portage/catalyst*
rm -f /etc/portage/kconfig*
rm -f /etc/portage/lzx.conf
rm -f '/usr/share/applications/links_-g_%u-links-2.desktop'
rm -f /usr/share/applications/org.octave.Octave.desktop
rm -f /usr/share/applications/spyder-spyder.desktop
rm -f /usr/share/applications/spyder.desktop
rm -rf /html
rm -f /var/db/pkg/dev-libs/lzx-*/environment.bz2
rm -f /var/db/pkg/dev-libs/lzxp-*/environment.bz2

chgrp input /usr/bin/Xorg 2>/dev/null
chmod u-s /usr/bin/Xorg 2>/dev/null
chmod g+s /usr/bin/Xorg 2>/dev/null

# remove weird agetty init scripts
rm -f /etc/init.d/agetty.tty*

true
