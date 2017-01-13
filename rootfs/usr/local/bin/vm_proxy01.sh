export QEMU_AUDIO_DRV=alsa QEMU_AUDIO_TIMER_PERIOD=250

QEMU="qemu-system-x86_64"
QEMU="systrace -d /usr/local/etc/systrace -ia ${QEMU} -- "
VMNAME=proxy01
VMUID=44444444
RUNAS="-runas ${VMNAME}"
CPU="-cpu qemu64"
#CPU="-cpu host,kvm=on,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+x2apic,-aes"
#KVM="-enable-kvm"
CPUNUM=1
#CPULIST="6,7,8,9"
#TASKSET="taskset -c ${CPULIST}"
MEM="-m 192M"
#HUGEMEM="-mem-path /dev/hugepages -mem-prealloc -balloon none"
#MACHINE="-machine type=pc,accel=kvm,mem-merge=off,kernel_irqchip=on -enable-kvm"
MACHINE="-machine type=pc"
SLIC="-acpitable file=/home/virtual/bios/SLIC"
BIOS="-bios /usr/share/seabios/bios.bin ${SLIC}"
#DISKDRIVER="virtio"
DISKDRIVER="scsi"
#FLOPPY="-drive id=cd0,file=/media/backup1/images/virtio-win-0.1.96.iso,if=none,cache=none,aio=threads,format=raw,media=cdrom,index=0 -device ide-drive,drive=cd0,bus=ahci.1"
#CDISO="-cdrom /home/virtual/${VMNAME}/${VMNAME}-latest.iso"
CDISO="-drive id=cd0,file=/home/virtual/${VMNAME}/${VMNAME}-latest.iso,if=none,cache=none,aio=threads,format=raw,media=cdrom,index=0 -device ide-drive,drive=cd0,bus=ahci.0"
OSDISK="-drive file=/home/virtual/${VMNAME}/${VMNAME}.sys.img,if=${DISKDRIVER},cache=none,aio=threads,discard=off,format=raw,media=disk,index=1"
CFGDISK="-drive file=/home/virtual/${VMNAME}/${VMNAME}.cfg.img,if=${DISKDRIVER},cache=none,aio=threads,discard=off,format=raw,media=disk,index=2"
#USBHOST1="-device ich9-usb-uhci1,bus=pci.0,id=uhci1"
#USBHOST2="-device ich9-usb-ehci1,bus=pci.0,id=ehci1"
#USBHOST3="-device nec-usb-xhci,bus=pci.0,id=xhci1"
#NETDRIVER="virtio-net-pci"
NETDRIVER=rtl8139
NETID=04
NETMAC="02:12:34:56:78:${NETID}"
#NETDEV1="-device ${NETDRIVER},netdev=net0,id=nic1,mac=${NETMAC},romfile= -netdev user,id=net0,hostfwd=tcp::22222-:22"
NETDEV1="-device ${NETDRIVER},netdev=net0,id=nic1,mac=${NETMAC},romfile= -netdev tap,ifname=hn0,id=net0,script=no,downscript=no"
#USBBRIDGE1="-device usb-host,hostbus=1,hostaddr=10,id=usbeth1,bus=ehci1.0,port=1"
#USBBRIDGE2="-device usb-host,vendorid=0x0b95,productid=0x772b,id=usbeth2,bus=ehci1.0,port=2"
#SOUNDHW="-soundhw ac97"
#SOUNDHW="-soundhw hda"
#SOUNDHW="-soundhw pcspk"
PARALLEL="-parallel none"
# echo system_powerdown | ncat -U /root/qemu-monitor-${VMNAME}
MONITOR="-monitor unix:/root/qemu-monitor-${VMNAME},server,nowait"
SERIAL="-serial unix:/root/qemu-serial-${VMNAME},server,nowait"
#SERIAL="-serial /dev/tty11"
VGA="-display curses -vga std"
#VGA="-vga qxl -display none"
#SPICEPWD=pass{NETID}
#SPICEPORT=59${NETID}
#SPICE="-spice port=${SPICEPORT},password=${SPICEPWD}"
#RNG="-device virtio-rng-pci"
RTC="-rtc base=utc,clock=vm"
DAEMON="-nographic -daemonize"

groupadd -g ${VMUID} ${VMNAME} 2> /dev/null || true
useradd -N -M -u ${VMUID} -g ${VMNAME} ${VMNAME} 2>/dev/null || true
# if qemu is not spawned from root ip tuntap user <USER> can be used also, right now we do RUNAS

POWEROFF=""
TRYCOUNT=0
while [ "x${POWEROFF}" == "x" ] ; do
        TRYCOUNT=$(($TRYCOUNT+1))
        if [ $TRYCOUNT -gt 150 ]; then
                echo "failed system_powerdown for ${VMNAME} ... killing"
                kill -9 $(cat /var/run/qemu-${VMNAME}.pid) 2>/dev/null
                exit 1
        fi
        echo system_powerdown | ncat -U /root/qemu-monitor-${VMNAME} 2>/dev/null || POWEROFF="true"
        sleep 1
done

${TASKSET} \
${QEMU} -pidfile /var/run/qemu-${VMNAME}.pid \
-name ${VMNAME} \
-nodefconfig -nodefaults -device ahci,id=ahci \
${MACHINE} \
${CPU} -smp cpus=${CPUNUM},sockets=1,cores=${CPUNUM},threads=1 \
${KVM} \
${BIOS} \
${MEM} ${HUGEMEM} \
${RTC} \
${USBHOST1} \
${USBHOST2} \
${USBHOST3} \
${PARALLEL} \
${VGA} \
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
-boot order=cd,menu=off ${RUNAS} ${DAEMON} &
