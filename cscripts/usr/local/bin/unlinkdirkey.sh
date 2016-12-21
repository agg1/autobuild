#!/bin/sh
sync
echo 3 > /proc/sys/vm/drop_caches
CDIR=$1
[ -z "${CDIR}" -o ! -e "${CDIR}" ] && echo "directory error" && exit
/usr/sbin/e4crypt get_policy "${CDIR}" | grep "Error getting policy" > /dev/null 2>&1 && echo "policy error" && exit
POLICY=$(/usr/sbin/e4crypt get_policy "${CDIR}" | cut -d':' -f2)
KEYID=$(keyctl show | grep ${POLICY} | cut -d'-' -f1)
[ ! -z "${KEYID}" ] && keyctl unlink ${KEYID}
echo 3 > /proc/sys/vm/drop_caches
