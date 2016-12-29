subarch: amd64
version_stamp: latest
target: livecd-stage2
rel_type: hardened
profile: hardened/linux/amd64/no-multilib
snapshot: latest
source_subpath: hardened/livecd-stage1-amd64-latest.tar.bz2
portage_confdir: /home/catalyst/etc/portage/
portage_overlay: /usr/local/portage

livecd/volid: Hardened Desktop Live System
livecd/type: generic-livecd
livecd/iso: amd64-latest.iso
livecd/fstype: squashfs
livecd/gk_mainargs: --mdadm --makeopts=-j24 --config=/etc/portage/genkernel.conf --no-oldconfig
livecd/cdtar: /usr/share/catalyst/livecd/cdtar/isolinux-3.72-cdtar.tar.bz2
livecd/bootargs: dokeymap nodhcp memory_corruption_check=1 docache
# ubsan_handle=OEAINVBSLF
# ubsan_handle=ELNVBSLF
livecd/rcdel: keymaps|boot netmount|default
livecd/rcadd: cronie|default sshd|default rsyslog|default sshguard|default
livecd/root_overlay: /home/catalyst/rootfs
#livecd/xdm:

boot/kernel: linux
boot/kernel/linux/sources: vanilla-sources
boot/kernel/linux/config: /home/catalyst/etc/portage/kconfig

boot/kernel/linux/use:
	-awt -bindist -branding -debug -consolekit -dbus -kdbus -policykit -pam -systemd -pulseaudio -udisks -upower -upnp -upnp-av -avahi -gvfs -gtk3 -qt4 -qt5 -gnome-keyring -libnotify -gnome -kde -java -ruby -python -test hardened urandom ipv6 crypt sasl ssl openssl libressl curl_ssl_libressl -gnutls -nettle socks5 system-mitkrb5 usb threads nptl nls unicode bzip2 lzo lzma xz zlib readline xml static-libs
	-udev
	-wayland
	-gconf
	smp
	clang
	X
	doc
	gtk
	xcb
	xkb
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
	icu
	djvu
	bmp
	gif
	jpeg
	jpeg2k
	mng
	png
	apng
	svg
	tiff
	fluidsynth
	midi
	gstreamer
	a52
	aac
	flac
	gsm
	lame
	ladspa
	ogg
	openal
	vorbis
	wav
	mad
	mp3
	mp4
	mpeg
	speex
	theora
	ffmpeg
	xvid
	x264
	h323
	v4l
	cdda
	cddb
	css
	dvb
	dvd
	oss
	sdl
	scanner
	joystick
	sound
	video
	egl
	gles
	gles2
	gles3
	opengl
	gallium
	glamor
	uxa
	sna
	dri
	dri2
	dri3
	vaapi
	vdpau
	xa
	xv
	xvmc
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
	input_devices_libinput
	input_devices_mouse
	input_devices_mutouch
	input_devices_penmount
	input_devices_tslib
	input_devices_vmmouse
	input_devices_void
	input_devices_synaptics
	input_devices_wacom
	-input_devices_evdev
	mmx
	sse
	sse2
	ntfsprogs
	-ntfsdecrypt
	libusb
	cairo
	imlib
	sqlite
	truetype
	xetex
	fortran

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

livecd/fsscript: /home/catalyst/finalize_target.sh

