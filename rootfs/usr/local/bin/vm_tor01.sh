export QEMU_AUDIO_DRV=alsa QEMU_AUDIO_TIMER_PERIOD=250

QEMU="qemu-system-x86_64"
VMNAME=tor01
VMUID=44444441
RUNAS="-runas ${VMNAME}"
CPU="-cpu qemu64"
#CPU="-cpu host,kvm=on,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+x2apic,-aes"
#KVM="-enable-kvm"
CPUNUM=1
#CPULIST="6,7,8,9"
#TASKSET="taskset -c ${CPULIST}"
MEM=208M
#HUGEMEM="-mem-path /dev/hugepages -mem-prealloc -balloon none"
#MACHINE="-machine type=pc,accel=kvm,mem-merge=off,kernel_irqchip=on -enable-kvm"
MACHINE="-machine type=pc"
SLIC="-acpitable file=/home/virtual/bios/SLIC"
BIOS="-bios /usr/share/seabios/bios.bin ${SLIC}"
#DISKDRIVER="virtio"
DISKDRIVER="scsi"
#FLOPPY="-drive id=cd0,file=/media/backup1/images/virtio-win-0.1.96.iso,if=none,cache=directsync,aio=native,format=raw,media=cdrom,index=0 -device ide-drive,drive=cd0,bus=ahci.1"
#CDISO="-cdrom /home/virtual/${VMNAME}/${VMNAME}-latest.iso"
CDISO="-drive id=cd0,file=/home/virtual/${VMNAME}/${VMNAME}-latest.iso,if=none,cache=directsync,aio=native,format=raw,media=cdrom,index=0 -device ide-drive,drive=cd0,bus=ahci.0"
OSDISK="-drive file=/home/virtual/${VMNAME}/${VMNAME}.sys.img,if=${DISKDRIVER},cache=directsync,aio=native,discard=off,format=raw,media=disk,index=1"
CFGDISK="-drive file=/home/virtual/${VMNAME}/${VMNAME}.cfg.img,if=${DISKDRIVER},cache=directsync,aio=native,discard=off,format=raw,media=disk,index=2"
#NETDRIVER=virtio-net-pci
NETDRIVER=e1000
NETID=01
NETMAC="02:12:34:56:78:${NETID}"
#NETDEV1="-device ${NETDRIVER},netdev=net0,id=nic1,romfile= -netdev bridge,br=br0,ifname=hn0,id=net0,helper=/bin/true"
NETDEV1="-device ${NETDRIVER},netdev=net0,id=nic1,mac=${NETMAC},romfile= -netdev tap,ifname=hn0,id=net0,script=no,downscript=no"
#USBBRIDGE1="-device usb-host,hostbus=1,hostaddr=10,id=usbeth1,bus=ehci1.0,port=1"
#USBBRIDGE2="-device usb-host,vendorid=0x0b95,productid=0x772b,id=usbeth2,bus=ehci2.0,port=1"
#SOUNDHW="-soundhw ac97"
#SOUNDHW="-soundhw hda"
#SOUNDHW="-soundhw pcspk"
PARALLEL="-parallel none"
# echo system_powerdown | ncat -U /tmp/monitor-qemu-${VMNAME}
# echo system_reset | ncat -U /tmp/monitor-qemu-${VMNAME}
MONITOR="-monitor unix:/root/monitor-qemu-${VMNAME},server,nowait"
#SERIAL="-serial /dev/tty11"
DAEMON=" -nographic -daemonize"
VGA="-display curses -vga std"
#VGA="-vga qxl -display none"
#SPICEPWD=pass{NETID}
#SPICEPORT=59${NETID}
#SPICE="-spice port=${SPICEPORT},password=${SPICEPWD}"
#RNG="-device virtio-rng-pci"

groupadd -g ${VMUID} ${VMNAME} 2> /dev/null || true
useradd -N -M -u ${VMUID} -g ${VMNAME} ${VMNAME} 2>/dev/null || true
# if qemu is not spawned from root ip tuntap user <USER> can be used also, right now we do RUNAS

${TASKSET} \
${QEMU} \
-name ${VMNAME} \
-nodefconfig -nodefaults \
${MACHINE} \
${CPU} -smp cpus=${CPUNUM},sockets=1,cores=${CPUNUM},threads=1 \
${KVM} \
${BIOS} \
-m ${MEM} ${HUGEMEM} \
-rtc base=utc,clock=vm \
-device ahci,id=ahci \
-device nec-usb-xhci,bus=pci.0,id=ehci1 \
-device nec-usb-xhci,bus=pci.0,id=ehci2 \
${PARALLEL} \
${VGA} \
${DAEMON} \
${SERIAL} \
${MONITOR} \
${SOUNDHW} \
${NETDEV1} \
${NETDEV2} \
${USBBRIDGE1} \
${USBBRIDGE2} \
${FLOPPY} \
${CDISO} \
${OSDISK} \
${CFGDISK} \
${RNG} \
${SPICE} \
-ctrl-grab \
-boot order=cd,menu=off ${DAEMON} ${RUNAS}
