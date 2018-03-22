subarch: amd64
version_stamp: latest
target: livecd-stage1
rel_type: hardened
profile: hardened/linux/amd64/no-multilib
snapshot: latest
source_subpath: hardened/stage3-amd64-latest.tar.bz2
portage_confdir: /home/autobuild/etc/portage/
portage_overlay: /usr/local/portage

livecd/use:
	minimal
	-doc
	-bindist -branding -debug -test -pam -systemd -consolekit -policykit -dbus -kdbus -oss -pulseaudio hardened urandom ipv6 crypt sasl ssl libressl curl_ssl_libressl -gnutls -nettle threads nptl nls unicode bzip2 lzo lzma xz zlib readline fortran clang gmp openmp ghc smp static-libs
	-udev -udisks -upower -upnp -upnp-av -avahi usb
	-system-mitkrb5 -system-heimdal -kerberos
	-java -ruby -python
	#-lua -php
	#-X -gtk -qt4 -qt5
	-gvfs -gconf -gtk3 -gnome-keyring -gnome -kde -accessibility -wayland -introspection
	-libinput -libnotify
	-jit -orc
	#acl caps seccomp skey smartcard xattr
	#ldap nis radius

livecd/packages:
	net-dialup/picocom
	net-misc/dhcp
	net-misc/dhcpcd
	net-misc/iputils
#	sys-apps/busybox
#	sys-apps/coreutils
	sys-apps/dmidecode
	sys-apps/gptfdisk
	sys-apps/hwsetup
	sys-apps/iproute2
	sys-apps/lsb-release
#	sys-apps/net-tools
#	sys-apps/util-linux
	#sys-apps/clrngd
	sys-apps/rng-tools
	sys-devel/bc
	dev-libs/libressl
	sys-fs/e2fsprogs
	sys-fs/lvm2
