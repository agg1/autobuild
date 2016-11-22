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
	-awt -bindist -branding -debug -consolekit -dbus -kdbus -policykit -pam -systemd -pulseaudio -udisks -upower -upnp -upnp-av -avahi -gvfs -gtk3 -gnome-keyring -libnotify -jit -orc -gnome -kde hardened urandom ipv6 libressl ssl libressl curl_ssl_libressl socks5 system-mitkrb5 usb threads nptl nls unicode bzip2 lzo lzma xz zlib readline xml static-libs
	-udev
	-X
	-doc
	-gtk
	minimal

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
	dev-libs/libressl
	sys-fs/e2fsprogs
	sys-fs/lvm2
