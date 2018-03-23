subarch: amd64
version_stamp: latest
target: livecd-stage2
rel_type: hardened
profile: hardened/linux/amd64/no-multilib
snapshot: latest
source_subpath: hardened/livecd-stage1-amd64-latest.tar.bz2
portage_confdir: /home/autobuild/etc/portage/
portage_overlay: /usr/local/portage

livecd/volid: Hardened Admin Live System
livecd/type: generic-livecd
livecd/iso: amd64-latest.iso
livecd/fstype: squashfs
livecd/gk_mainargs: --config=/etc/portage/genkernel.conf
livecd/cdtar: /home/autobuild/etc/portage/catalyst/livecd/cdtar/isolinux-3.86-cdtar.tar.bz2
livecd/bootargs: dokeymap nodhcp nosound memory_corruption_check=1 pbshutdown console=ttyUSB0,115200 console=ttyS0,115200 console=tty0
livecd/rcdel: keymaps|boot netmount|default
livecd/rcadd: cronie|default rsyslog|default
#sshd|default sshguard|default
livecd/root_overlay: /home/autobuild/rootfs/default /home/autobuild/tmp/cscriptoverlay/default
#livecd/overlay:
#livecd/xdm:

boot/kernel: linux
boot/kernel/linux/sources: ck-sources
boot/kernel/linux/config: /home/autobuild/etc/portage/kconfig

boot/kernel/linux/use:
	#minimal
	-doc
	-bindist -branding -debug -test -pam -systemd -consolekit -policykit -dbus -kdbus -oss -pulseaudio hardened urandom ipv6 crypt sasl ssl libressl curl_ssl_libressl -gnutls -nettle threads nptl nls unicode bzip2 lzo lzma xz zlib readline fortran clang gmp openmp ghc smp static-libs
	-udev -udisks -upower -upnp -upnp-av -avahi usb
	-system-mitkrb5 -system-heimdal -kerberos
	-java -ruby -python
	#-lua -php
	-X -gtk -gtk2 -gtk3 -qt4 -qt5
	-gvfs -gconf -gtk3 -gnome-keyring -gnome -kde -accessibility -wayland -introspection
	-libinput -libnotify
	-jit -orc
	acl caps seccomp skey smartcard xattr
	#ldap nis radius

#boot/kernel/linux/packages:
#	sys-kernel/linux-firmware
#	sys-block/iscsitarget

#livecd/unmerge:
#	sys-libs/pam
#	sys-auth/pambase

livecd/rm:
	/lib/firmware/*
	/boot/System*
	/boot/initr*
	/boot/kernel*
	/etc/make.conf*
	/etc/make.globals
	/etc/make.profile
	/var/tmp/gentoo.config
	/var/tmp/genkernel/initramfs*
	/var/tmp/genkernel
	/usr/src/linux

#livecd/empty:

livecd/fsscript: /home/autobuild/finalize_target.sh

