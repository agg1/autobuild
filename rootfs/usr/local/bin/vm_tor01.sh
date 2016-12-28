export QEMU_AUDIO_DRV=alsa QEMU_AUDIO_TIMER_PERIOD=250

VMNAME=tor01
CPUNUM=1
MEM=208M
#DISKDRIVER="virtio"
DISKDRIVER="scsi"
#FLOPPY="-drive id=cd0,file=/media/backup1/images/virtio-win-0.1.96.iso,if=none,cache=none,aio=native,format=raw,media=cdrom,index=0 -device ide-drive,drive=cd0,bus=ahci.1"
#CDISO="-cdrom /home/virtual/${VMNAME}/${VMNAME}-latest.iso"
CDISO="-drive id=cd0,file=/home/virtual/${VMNAME}/${VMNAME}-latest.iso,if=none,cache=none,aio=native,format=raw,media=cdrom,index=0 -device ide-drive,drive=cd0,bus=ahci.0"
SWAPDISK="-drive file=/home/virtual/${VMNAME}/${VMNAME}.swap.img,if=${DISKDRIVER},cache=none,aio=native,discard=off,format=raw,media=disk,index=1"
CFGDISK="-drive file=/home/virtual/${VMNAME}/${VMNAME}.cfg.img,if=${DISKDRIVER},cache=none,aio=native,discard=off,format=raw,media=disk,index=2"
HOMEDISK="-drive file=/home/virtual/${VMNAME}/${VMNAME}.home.img,if=${DISKDRIVER},cache=none,aio=native,discard=off,format=raw,media=disk,index=3"
LOGDISK="-drive file=/home/virtual/${VMNAME}/${VMNAME}.log.img,if=${DISKDRIVER},cache=none,aio=native,discard=off,format=raw,media=disk,index=4"
#NETDRIVER=virtio-net-pci
SOUNDHW=" "
MONITOR="-monitor none"
RUNAS="-runas ${VMNAME}"
#VGA="-display curses -vga std"
#SERIAL="-serial /dev/tty11"
DAEMON=" -nographic -daemonize"

${TASKSET} \
qemu-system-x86_64 \
-nodefconfig -nodefaults \
-M pc \
-name ${VMNAME} \
-rtc base=utc,clock=vm \
-cpu qemu64 \
-smp cpus=${CPUNUM},sockets=1,cores=${CPUNUM},threads=1 \
-m ${MEM} ${HUGEMEM} \
${VGA} \
${DAEMON} \
${SERIAL} \
-parallel none \
$MONITOR \
${SOUNDHW} \
-device ahci,id=ahci \
-net none \
-device nec-usb-xhci,bus=pci.0,id=ehci1 \
-device nec-usb-xhci,bus=pci.0,id=ehci2 \
-device usb-host,hostbus=1,hostaddr=32,id=usbeth1,bus=ehci1.0,port=1 \
${FLOPPY} \
${CDISO} \
${CFGDISK} \
${HOMEDISK} \
${LOGDISK} \
${SWAPDISK} \
-boot order=cd,menu=on ${DAEMON} ${RUNAS}

#-device usb-host,vendorid=0x9710,productid=0x7830,id=usbeth1,bus=ehci1.0,port=1 \
