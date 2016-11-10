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
livecd/gk_mainargs: --lvm --dmraid --mdadm --makeopts=-j24 --config=/etc/portage/genkernel.conf --no-oldconfig
livecd/cdtar: /usr/share/catalyst/livecd/cdtar/isolinux-3.72-cdtar.tar.bz2
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
        -gtk3
        -jit
        -libnotify
        -orc
        -udev
        -udisks
        crypt
        xml
        sound
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
        cryptsetup
        hardened
        ipv6
        livecd
        loop-aes
        extra-ciphers
        jpeg
        keyscrub
        lvm1
        midi
        fluidsynth
        mng
        modules
        ncurses
        nls
        nptl
        nptlonly
        threads
        gmp
        xml
        png
        readline
        socks5
        ssl
        system-mitkrb5
        fontconfig
        truetype
        zlib
        iconv
        unicode
        urandom
        usb
        doc
        static-libs
        python_targets_python2_7
        python_targets_python3_4
        sqlite
        mmx
        sse
        sse2
        cairo
        gtk
#       opencl
#       llvm
        opengl
        video
        gallium
        glamor
        xvfb
        xcb
        X
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
        uxa
        sna
        dri
        dri2
        dri3
        xv
        xvmc
        xorg

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
	/root/.bash_history

#livecd/empty:
