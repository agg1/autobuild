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
	minimal
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

stage4/packages:
	sys-devel/bc
	sys-fs/lvm2

#stage4/rcadd:
#	net.lo|default
#	netmount|default
#	sshd|default

boot/kernel: linux
boot/kernel/linux/sources: ck-sources
boot/kernel/linux/config: /etc/portage/kconfig
boot/kernel/linux/gk_kernargs: --all-ramdisk-modules --lvm --dmraid --mdadm --makeopts=-j8 --config=/etc/portage/genkernel.conf

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
