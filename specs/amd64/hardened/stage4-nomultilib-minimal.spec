subarch: amd64
target: stage4
version_stamp: latest
rel_type: hardened
profile: hardened/linux/amd64/no-multilib
snapshot: latest
source_subpath: hardened/stage3-amd64-latest.tar.bz2
portage_confdir: /home/autobuild/etc/portage/
portage_overlay: /usr/local/portage

stage4/use:
	-awt -bindist -branding -debug -consolekit -dbus -kdbus -policykit -pam -systemd -pulseaudio -udisks -upower -upnp -upnp-av -avahi -gvfs -gtk3 -qt4 -qt5 -gnome-keyring -libnotify -gnome -kde -java -ruby -python -test hardened urandom ipv6 sasl ssl openssl libressl curl_ssl_libressl -gnutls -nettle socks5 system-mitkrb5 usb threads nptl nls unicode bzip2 lzo lzma xz zlib xml static-libs -cups
	-udev
	-X
	-doc
	-gtk
	minimal

stage4/packages:
	sys-devel/bc
	sys-fs/lvm2

#stage4/rcadd:
#	net.lo|default
#	netmount|default
#	sshd|default

boot/kernel: linux
boot/kernel/linux/sources: vanilla-sources
boot/kernel/linux/config: /etc/portage/kconfig
boot/kernel/linux/gk_kernargs: --all-ramdisk-modules --lvm --dmraid --mdadm --makeopts=-j24 --config=/etc/portage/genkernel.conf

stage4/unmerge:
	sys-libs/pam
	sys-auth/pambase
	sys-kernel/genkernel
	sys-kernel/vanilla-sources

stage4/empty:
	/root/.ccache
	/tmp
	/usr/portage/distfiles
	/usr/src
	/var/cache/edb/dep
	/var/cache/genkernel
	/var/cache/portage/distfiles
	/var/empty
	/var/run
	/var/state
	/var/tmp

stage4/rm:
	/etc/*-
	/etc/*.old
	/etc/ssh/ssh_host_*
	/root/.*history
	/root/.lesshst
	/root/.ssh/known_hosts
	/root/.viminfo
	/usr/share/genkernel
	/usr/lib64/python*/site-packages/gentoolkit/test/eclean/testdistfiles.tar.gz
