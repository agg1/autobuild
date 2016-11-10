subarch: amd64
version_stamp: latest
target: livecd-stage1
rel_type: hardened
profile: hardened/linux/amd64/no-multilib
snapshot: latest
source_subpath: hardened/stage3-amd64-latest.tar.bz2
portage_confdir: /home/catalyst/etc/portage/
portage_overlay: /usr/local/portage

livecd/use:
	-*
        -awt
	-avahi
	-consolekit
	-doc
	-jit
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
	-udev
        -udisks
	-X
	crypt
	minimal
	bzip2
	cryptsetup
	hardened
	ipv6
	livecd
	loop-aes
	extra-ciphers
	keyscrub
	lvm1
	modules
	ncurses
	nls
	nptl
	nptlonly
	threads
	readline
	ssl
	system-mitkrb5
	unicode
	urandom
	usb
	static-libs
	python_targets_python2_7
	python_targets_python3_4
	mmx
	sse
	sse2

livecd/packages:
	net-misc/dhcp
	net-misc/dhcpcd
	net-misc/iputils
#	sys-apps/busybox
#	sys-apps/coreutils
	sys-apps/dmidecode
	sys-apps/gptfdisk
	sys-apps/iproute2
	sys-apps/lsb-release
#	sys-apps/net-tools
#	sys-apps/util-linux
	sys-devel/bc
	sys-fs/e2fsprogs
	sys-fs/lvm2
