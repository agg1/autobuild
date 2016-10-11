subarch: amd64
version_stamp: latest
target: livecd-stage1
rel_type: hardened
profile: hardened/linux/amd64/no-multilib
snapshot: latest
source_subpath: hardened/stage3-amd64-latest.tar.bz2
portage_confdir: /home/catalyst/etc/portage/
cflags: -O3 -pipe -march=nehalem -mtune=nehalem
cxxflags: -O3 -pipe -march=nehalem -mtune=nehalem

#-udev
livecd/use:
	-avahi
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
	-gnome-keyring
	-gtk3
	-jit
	-orc
	-X
	alsa
	alsa_pcm_plugins_adpcm
	alsa_pcm_plugins_alaw
	alsa_pcm_plugins_asym
	alsa_pcm_plugins_copy
	alsa_pcm_plugins_dmix
	alsa_pcm_plugins_dshare
	alsa_pcm_plugins_dsnoop
	alsa_pcm_plugins_empty
	alsa_pcm_plugins_extplug
	alsa_pcm_plugins_file
	alsa_pcm_plugins_hooks
	alsa_pcm_plugins_iec958
	alsa_pcm_plugins_ioplug
	alsa_pcm_plugins_ladspa
	alsa_pcm_plugins_lfloat
	alsa_pcm_plugins_linear
	alsa_pcm_plugins_meter
	alsa_pcm_plugins_mmap_emul
	alsa_pcm_plugins_mulaw
	alsa_pcm_plugins_multi
	alsa_pcm_plugins_null
	alsa_pcm_plugins_plug
	alsa_pcm_plugins_rate
	alsa_pcm_plugins_route
	alsa_pcm_plugins_share
	alsa_pcm_plugins_shm
	alsa_pcm_plugins_softvol
	bzip2
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
	nptlonly
	png
	readline
	socks5
	ssl
	truetype
	unicode
	urandom
	usb
    doc
    latex
    static-libs
#   static
#	deprecated
#	fbcondecor
#	portaudio
#	minimal

livecd/packages:
#    app-doc/doxygen
	app-accessibility/brltty
#	app-accessibility/espeakup
	app-admin/eselect
	app-admin/hddtemp
	app-admin/passook
	app-admin/perl-cleaner
	app-admin/pwgen
	app-admin/python-updater
	app-admin/syslog-ng
	app-admin/sysstat
	app-admin/testdisk
	app-arch/bzip2
	app-arch/cpio
	app-arch/dpkg
	app-arch/gzip
#	PATH_MAX rumble
	app-arch/mt-st
	app-arch/p7zip
	app-arch/pbzip2
	app-arch/rar
	app-arch/tar
	app-arch/unrar
	app-arch/unzip
	app-backup/duplicity
	app-benchmarks/bonnie
	app-benchmarks/bonnie++
	app-benchmarks/dbench
	app-benchmarks/iozone
	app-benchmarks/stress
#	app-benchmarks/tiobench
	app-crypt/bcwipe
	app-crypt/gnupg
	app-crypt/hashalot
	app-crypt/pinentry
#	app-editors/emacs
	app-editors/hexcurse
	app-editors/hexedit
	app-editors/mg
	app-editors/vim
#	app-emacs/ebuild-mode
#	app-emulation/cloud-init
#	app-emulation/xen-tools
#	app-eselect/eselect-ctags
	app-eselect/eselect-vi
	app-misc/ca-certificates
	app-misc/colordiff
#	app-misc/mc
	app-misc/pax-utils
	app-misc/screen
	app-misc/tmux
	app-misc/vlock
	app-portage/eix
	app-portage/gentoolkit
	app-portage/mirrorselect
	app-portage/portage-utils
	app-shells/bash-completion
	app-shells/gentoo-bashcomp
#	app-shells/zsh
	app-text/tree
	app-text/dos2unix
	app-text/wgetpaste
	app-vim/gentoo-syntax
	dev-lang/perl
	dev-lang/python
	dev-libs/gmp
	dev-libs/libxml2
	dev-libs/mpfr
	dev-libs/openssl
#	dev-libs/libressl
	dev-python/pycrypto
	dev-util/catalyst
	dev-util/pkgconfig
	dev-vcs/git
	media-gfx/fbgrab
	media-libs/alsa-oss
	media-sound/alsa-utils
	net-analyzer/gnu-netcat
	net-analyzer/iptraf-ng
	net-analyzer/netcat6
	net-analyzer/tcptraceroute
#	uint16_t not found???
	net-analyzer/traceroute
	net-analyzer/traceroute-nanog
	net-analyzer/tcpdump
#	net-dialup/globespan-adsl
	net-analyzer/nmap
	net-dialup/mingetty
	net-dialup/minicom
	net-dialup/pptpclient
	net-dialup/rp-pppoe
	net-dns/bind-tools
	net-fs/cifs-utils
	net-fs/nfs-utils
	net-ftp/ftp
	net-ftp/ncftp
	net-irc/irssi
	net-misc/bridge-utils
#	net-misc/connman
	net-misc/curl
	net-misc/dhcpcd
	net-misc/iputils
	net-misc/ndisc6
	net-misc/ntp
	net-misc/openssh
	net-misc/openvpn
	net-misc/rdate
	net-misc/rsync
	net-misc/telnet-bsd
	net-misc/vconfig
	net-misc/wakeonlan
	net-misc/wol
	net-misc/wget
	net-misc/whois
	net-proxy/dante
	net-proxy/tsocks
	net-wireless/b43-fwcutter
### Masked (~amd64)
#	net-wireless/bcm43xx-fwcutter
	net-wireless/iw
	net-wireless/rfkill
	net-wireless/wireless-tools
	net-wireless/wpa_supplicant
#	perl-core/PodParser
#	perl-core/Test-Harness
#	sys-apps/apmd
	sys-apps/arrayprobe
	sys-apps/acl
	sys-apps/attr
	sys-apps/busybox
	sys-apps/cciss_vol_status
	sys-apps/chname
	sys-apps/coreutils
	sys-apps/dcfldd
	sys-apps/debianutils
	sys-apps/diffutils
	sys-apps/dmidecode
	sys-apps/dstat
	sys-apps/ethtool
	sys-apps/file
	sys-apps/findutils
	sys-apps/flashrom
	sys-apps/fxload
	sys-apps/gawk
	sys-apps/gptfdisk
	sys-apps/grep
	sys-apps/groff
	sys-apps/hdparm
	sys-apps/hwsetup
	sys-apps/ipmitool
	sys-apps/iproute2
	sys-apps/less
	sys-apps/lsb-release
	sys-apps/man
	sys-apps/man-pages
	sys-apps/man-pages-posix
	sys-apps/memtester
	sys-apps/miscfiles
	sys-apps/mlocate
	sys-apps/netplug
	sys-apps/pciutils
	sys-apps/pcmciautils
	sys-apps/portage
	sys-apps/sdparm
	sys-apps/sed
	sys-apps/setserial
	sys-apps/sg3_utils
	sys-apps/smartmontools
	sys-apps/texinfo
	sys-apps/usbutils
	sys-apps/util-linux
	sys-apps/which
	sys-apps/x86info
	sys-block/aoetools
#	sys-block/eject
	sys-block/fio
	sys-block/mtx
	sys-block/open-iscsi
	sys-block/parted
	sys-block/partimage
	sys-block/tw_cli
#	sys-boot/grub
	sys-devel/autoconf
	sys-devel/autoconf-wrapper
	sys-devel/automake
	sys-devel/automake-wrapper
	sys-devel/bc
	sys-devel/binutils-config
	sys-devel/bison
	sys-devel/flex
#	sys-devel/gcc
	sys-devel/gcc-config
	sys-devel/gettext
	sys-devel/gnuconfig
	sys-devel/libtool
	sys-devel/m4
	sys-devel/make
	sys-devel/patch
#	sys-fs/eudev
	sys-fs/btrfs-progs
	sys-fs/cryptsetup
	sys-fs/ddrescue
	sys-fs/dmraid
	sys-fs/dosfstools
	sys-fs/e2fsprogs
	sys-fs/ext3grep
	sys-fs/extundelete
	sys-fs/f2fs-tools
	sys-fs/jfsutils
#	sys-fs/loop-aes
	sys-fs/lsscsi
	sys-fs/lvm2
	sys-fs/mac-fdisk
	sys-fs/mdadm
	sys-fs/multipath-tools
	sys-fs/ntfs3g
	sys-fs/reiserfsprogs
	sys-fs/xfsprogs
	sys-kernel/genkernel
	sys-kernel/linux-headers
	sys-libs/db
	sys-libs/gdbm
	sys-libs/gpm
	sys-libs/libkudzu
	sys-libs/libsmbios
#	sys-power/acpid
#	sys-power/pm-quirks
#	sys-power/pm-utils
	sys-process/htop
	sys-process/lsof
	sys-process/iotop
	sys-process/procps
	sys-process/psmisc
	www-client/links
	sys-kernel/linux-firmware
