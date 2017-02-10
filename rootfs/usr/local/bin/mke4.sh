#!/bin/sh
DISK=$1
LABEL=$2
[ -z "${DISK}" -o ! -e "${DISK}" ] && echo "disk error" && exit
[ ! -z "${LABEL}" ] && LABEL="-L ${LABEL}"
mkfs.ext4 ${LABEL} -O metadata_csum,encrypt,64bit ${DISK}
