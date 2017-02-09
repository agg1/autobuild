make oldconfig
make prepare
make modules_prepare
make SUBDIRS=scripts/mod
make SUBDIRS=drivers/staging/ft1000/ft1000-usb modules
cp drivers/staging/ft1000/ft1000-usb/ft1000.ko /lib/modules/3.2.0-4-686-pae/kernel/drivers/staging/
depmod
modprobe ft1000
