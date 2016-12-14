export QEMU_AUDIO_DRV=alsa QEMU_AUDIO_TIMER_PERIOD=250

VMNAME=fw01
CPUNUM=1
MEM=128M
DISKDRIVER="virtio"
#CDISO="-cdrom /home/images/install59.iso"
#OSDISK="-hda /home/virtual/fw01.img"
OSDISK="-hda /dev/mapper/vghome-lvfw01"
#NETDRIVER=virtio-net-pci
SOUNDHW=" "
MONITOR="-monitor none"
RUNAS="-runas fw01"
VGA="-display curses -vga std"
SERIAL="-serial /dev/tty10"
DAEMON=" -nographic -daemonize"

# echo 'set tty com0' > /etc/boot.conf
# /etc/ttys console on

#rmmod mcs7830
#rmmod ax88179_178a

#ip link add br0 type bridge
#ip link set enp0s26u1u1u3 master br0

#ifconfig br0 down
#brctl delbr br0
#brctl addbr br0
#brctl stp br0 no
#brctl addif br0 enp0s26u1u1u3
#ifconfig br0 up

#ifconfig br1 down
#brctl delbr br1
#brctl addbr br1
#brctl stp br1 no
#brctl addif br1 enp0s26u1u1u3
#ifconfig br0 up

#ip tuntap add hn0 mode tap
#ip link  set hn0 up
#ip link set hn0 master br0

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
-device usb-host,vendorid=0x0b95,productid=0x7720,id=usbeth1,bus=ehci1.0,port=1 \
-device usb-host,vendorid=0x0b95,productid=0x772b,id=usbeth2,bus=ehci2.0,port=1 \
${FLOPPY} \
${CDISO} \
${OSDISK} \
-boot order=cd,menu=on ${DAEMON} ${RUNAS}


#-device virtio-net-pci,netdev=hn0,id=nic0,mac=02:12:34:56:78:88 -netdev bridge,id=hn0,br=br0 \

#-netdev bridge,id=hn0 \
#-usb -usbdevice host:0b95:1790 \
#-usb -usbdevice host:9710:7830
#-device usb-host,vendorid=0x0b95,productid=0x1790,id=usbsnd,bus=usb3.0 \
#-device usb-host,vendorid=0x9710,productid=0x7830,id=usbeth,bus=usb2.0 \
#-device virtio-net-pci,netdev=hn0,id=nic0,mac=02:12:34:56:78:88 \
#-device virtio-net-pci,netdev=hn0,id=nic0,mac=02:12:34:56:78:88 -netdev bridge,id=hn0,br=br0 \

