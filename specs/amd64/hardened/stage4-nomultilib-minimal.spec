subarch: amd64
target: stage4
version_stamp: latest
rel_type: hardened
profile: hardened/linux/amd64/no-multilib
snapshot: latest
source_subpath: hardened/stage3-amd64-latest.tar.bz2
portage_confdir: /home/catalyst/etc/portage/
cflags: -O3 -pipe -march=nehalem -mtune=nehalem
cxxflags: -O3 -pipe -march=nehalem -mtune=nehalem

#-udev
stage4/use:
	-consolekit
	-policykit
	-pam
	-systemd
	-kdbus
	-dbus
	-pulseaudio
	-bindist
	-branding
	-gvfs
	-jit
	-orc
	bzip2
	hardened
	ipv6
	keyscrub
	loop-aes
	extra-ciphers
	lvm1
	urandom

stage4/packages:
	sys-devel/bc
	sys-fs/lvm2

#stage4/rcadd:
#	net.lo|default
#	netmount|default
#	sshd|default

boot/kernel: gentoo
boot/kernel/gentoo/sources: gentoo-sources
boot/kernel/gentoo/config: /etc/portage/kconfig
boot/kernel/gentoo/gk_kernargs: --all-ramdisk-modules --lvm --dmraid --mdadm --makeopts=-j16 --config=/etc/portage/genkernel.conf

stage4/unmerge:
	sys-libs/pam
	sys-auth/pambase
	sys-kernel/genkernel
	sys-kernel/gentoo-sources

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
#	/usr/share/genkernel
	/usr/lib64/python*/site-packages/gentoolkit/test/eclean/testdistfiles.tar.gz
