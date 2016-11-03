subarch: amd64
version_stamp: latest
target: livecd-stage2
rel_type: hardened
profile: hardened/linux/amd64/no-multilib
snapshot: latest
source_subpath: hardened/livecd-stage1-amd64-latest.tar.bz2
portage_confdir: /home/catalyst/etc/portage/
portage_overlay: /home/catalyst/extra_overlay/

livecd/volid: Hardened Admin Live System
livecd/type: generic-livecd
livecd/iso: amd64-latest.iso
livecd/fstype: squashfs
livecd/gk_mainargs: --lvm --dmraid --mdadm --makeopts=-j16 --config=/etc/portage/genkernel.conf --no-oldconfig
livecd/cdtar: /usr/share/catalyst/livecd/cdtar/isolinux-elilo-memtest86+-cdtar.tar.bz2
livecd/bootargs: dokeymap nodhcp memory_corruption_check=1
# ubsan_handle=OEAINVBSLF
# ubsan_handle=ELNVBSLF
livecd/rcdel: keymaps|boot netmount|default
#dhcpcd
#livecd/rcadd:
livecd/root_overlay: /home/catalyst/rootfs
#livecd/xdm:

boot/kernel: gentoo
boot/kernel/gentoo/sources: vanilla-sources
boot/kernel/gentoo/config: /home/catalyst/etc/portage/kconfig

boot/kernel/gentoo/use:
	-*
	-avahi
	-consolekit
	-doc
	-policykit
	-pam
	-systemd
	-kdbus
	-dbus
	-pulseaudio
	-bindist
	-branding
	-gvfs
	-gnome-keyring
	-gtk
	-gtk3
	-jit
	-orc
	-X
	crypt
	bzip2
	cryptsetup
	fbcon
	hardened
	ipv6
	livecd
	loop-aes
	extra-ciphers
	keyscrub
	lvm1
	midi
	mng
	modules
	ncurses
	nls
	nptl
	threads
	nptlonly
	readline
	socks5
	ssl
	unicode
	urandom
	usb
	static-libs
	python_targets_python2_7
	python_targets_python3_4
	mmx
	sse
	sse2

#boot/kernel/gentoo/packages:
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

#livecd/empty:

