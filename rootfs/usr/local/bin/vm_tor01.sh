export QEMU_AUDIO_DRV=alsa QEMU_AUDIO_TIMER_PERIOD=250

VMNAME=tor01
CPUNUM=1
MEM=208M
#DISKDRIVER="virtio"
CDISO="-cdrom /home/virtual/tor01/tor01-latest.iso"
OSDISK="-hda /home/virtual/tor01/tor01.cfg.img"
SWAPDISK="-hdb /home/virtual/tor01/tor01.swap.img"
#NETDRIVER=virtio-net-pci
SOUNDHW=" "
MONITOR="-monitor none"
RUNAS="-runas tor01"
VGA="-display curses -vga std"
#SERIAL="-serial /dev/tty11"
#DAEMON=" -nographic -daemonize"

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
-net none \
-device nec-usb-xhci,bus=pci.0,id=ehci1 \
-device nec-usb-xhci,bus=pci.0,id=ehci2 \
-device usb-host,hostbus=1,hostaddr=32,id=usbeth1,bus=ehci1.0,port=1 \
${FLOPPY} \
${CDISO} \
${OSDISK} \
${SWAPDISK} \
-boot order=cd,menu=on ${DAEMON} ${RUNAS}

#-device usb-host,vendorid=0x9710,productid=0x7830,id=usbeth1,bus=ehci1.0,port=1 \
