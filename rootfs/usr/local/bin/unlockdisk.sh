#!/bin/sh
CDISK=$1
CMAPP=$2
[ -z "${CDISK}" -o ! -e "${CDISK}" ] && echo "disk error" && exit
[ -z "${CMAPP}" ] && echo "mapper name error" && exit

cryptsetup open ${CDISK} ${CMAPP} --type plain --cipher aes-xts-plain64 --key-size 512 --hash sha512
