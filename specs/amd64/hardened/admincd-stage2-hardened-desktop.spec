subarch: amd64
version_stamp: latest
target: livecd-stage2
rel_type: hardened
profile: hardened/linux/amd64/no-multilib
snapshot: latest
source_subpath: hardened/livecd-stage1-amd64-latest.tar.bz2
portage_confdir: /home/autobuild/etc/portage/
portage_overlay: /usr/local/portage

livecd/volid: Hardened Desktop Live System
livecd/type: generic-livecd
livecd/iso: amd64-latest.iso
livecd/fstype: squashfs
livecd/gk_mainargs: --config=/etc/portage/genkernel.conf
livecd/cdtar: /home/autobuild/cdtar/isolinux-3.86-cdtar.tar.bz2
livecd/bootargs: net.ifnames=0 dokeymap nodhcp memory_corruption_check=0 usbhid.mousepoll=2 pbsleep syslvmdev=/dev/md126 syslvmdev=/dev/md127
livecd/rcdel: keymaps|boot netmount|default
livecd/rcadd: cronie|default rsyslog|default
# sshd|default sshguard|default
livecd/root_overlay: /home/autobuild/rootfs/default /home/autobuild/tmp/cscriptoverlay/default /home/autobuild/rootfs/desktop
livecd/overlay: /home/autobuild/tmp/buildoverlay
#livecd/xdm:

boot/kernel: linux
boot/kernel/linux/sources: ck-sources
boot/kernel/linux/config: /home/autobuild/etc/portage/kconfig

boot/kernel/linux/use:
	#minimal
	#-doc
	-bindist -branding -debug -test -pam -systemd -consolekit -policykit -dbus -kdbus -oss -pulseaudio hardened urandom ipv6 sasl ssl libressl curl_ssl_libressl -gnutls -nettle threads nptl nls unicode bzip2 lzo lzma xz zlib readline fortran clang gmp openmp ghc smp static-libs
	-udev -udisks -upower -upnp -upnp-av -avahi usb
	-system-mitkrb5 -system-heimdal -kerberos
	-java -ruby -python
	#-lua -php
	#-X -gtk -gtk2 -gtk3 -qt4 -qt5
	-gvfs -gconf -gtk3 -gnome-keyring -gnome -kde -accessibility -wayland -introspection
	-libinput -libnotify
	-jit -orc
	acl caps seccomp skey smartcard xattr
	#ldap nis radius
	### DESKTOP
	X gtk gtk2 xcb xkb
	sqlite
	truetype fontconfig cups gnuplot pdf latex jadetex xetex xml iconv spell icu
	vim-syntax bash-completion
	scanner joystick
	socks5
	#snmp
	sdl sdl2 cdparanoia cdr encode
	gd djvu bmp gif jpeg jpeg2k mng png apng svg tiff cairo imlib wmf xpm
	sound jack sox speex fluidsynth midi gstreamer a52 aac flac gsm lame ladspa lash ogg openal vorbis wav mad mp3 sndfile cdda cddb dts timidity
	video -vlc mplayer mp4 mpeg mjpeg theora ffmpeg xvid x264 h323 v4l matroska vcd css dvb dvd dvdr dv quicktime
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
	#directfb fbcon
	#egl
	#gles
	#gles2
	#gles3
	opengl gallium glamor uxa sna dri dri2 dri3 vaapi vdpau xa xv xvmc
	video_cards_amdgpu
	video_cards_apm
	video_cards_ast
	video_cards_chips
	video_cards_cirrus
	video_cards_dummy
	video_cards_epson
	video_cards_fbdev
	video_cards_glint
	video_cards_i128
	video_cards_i740
	video_cards_intel
	video_cards_i915
	video_cards_i965
	video_cards_mach64
	video_cards_mga
	video_cards_neomagic
	video_cards_nouveau
	video_cards_nv
	video_cards_r128
	video_cards_radeon
	video_cards_radeonsi
	video_cards_rendition
	video_cards_s3
	video_cards_s3virge
	video_cards_savage
	video_cards_siliconmotion
	video_cards_sisusb
	video_cards_tdfx
	video_cards_tga
	video_cards_trident
	video_cards_tseng
	video_cards_vesa
	video_cards_via
	video_cards_voodoo
	video_cards_nvidia
	-video_cards_fglrx
	-video_cards_geode
	-video_cards_freedreno
	-video_cards_omap
	-video_cards_omapfb
	-video_cards_qxl
	-video_cards_sunbw2
	-video_cards_suncg14
	-video_cards_suncg3
	-video_cards_suncg6
	-video_cards_sunffb
	-video_cards_sunleo
	-video_cards_suntcx
	-video_cards_tegra
	-video_cards_virtualbox
	-video_cards_vmware
	input_devices_acecad
	input_devices_aiptek
	input_devices_elographics
	input_devices_fpit
	input_devices_hyperpen
	input_devices_joystick
	input_devices_keyboard
	-input_devices_libinput
	input_devices_mouse
	input_devices_mutouch
	input_devices_penmount
	input_devices_tslib
	input_devices_vmmouse
	input_devices_void
	input_devices_synaptics
	input_devices_wacom
	-input_devices_evdev

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
	/usr/src/linux

#livecd/empty:

livecd/fsscript: /home/autobuild/finalize_target.sh

