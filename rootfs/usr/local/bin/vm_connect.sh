#!/bin/sh

VMNAME="$1"

[ -z "${VMNAME}" -o ! -e "/usr/local/etc/machines/${VMNAME}" ] && echo "machine missing" && exit 1
[ ! -e "/root/qemu-serial-${VMNAME}" ] && echo "socket missing" && exit 1

minicom -D unix#/root/qemu-serial-${VMNAME}

## connect to domain socket with ncat, echos sswords which is not desired
#ncat -U /root/qemu-monitor-prn01

## connect to domain socket with minicom
#minicom -D unix#/root/qemu-monitor-prn01

## forward domain socket to serial pseudo terminal
#socat gopen:/root/qemu-monitor-prn01 PTY,link=/root/qemu-monitor-prn01.line,wait-slave

## connect to pseudo tty serial line witch cu
#cu -l $(readlink /root/qemu-monitor-prn01.line)

## connect to psydo tty serial line with minicom
#minicom -D $(readlink /root/qemu-monitor-prn01.line)
