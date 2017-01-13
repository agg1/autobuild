#!/bin/sh
pvcreate -Z y --metadatasize 1048k --metadatacopies 2 /dev/sde
vgcreate -s 16384k vgvirtual /dev/sde

lvcreate -n lvfw01iso -L256M vgvirtual
lvcreate -n lvfw01sys -L512M vgvirtual

lvcreate -n lvtor01iso -L256M vgvirtual
lvcreate -n lvtor01sys -L512M vgvirtual

lvcreate -n lvirc01iso -L256M vgvirtual
lvcreate -n lvirc01sys -L3072M vgvirtual


dd if=fw01-latest.iso of=/dev/mapper/vgvirtual-lvfw01iso bs=2M
dd if=fw01.sys.img of=/dev/mapper/vgvirtual-lvfw01sys bs=2M

