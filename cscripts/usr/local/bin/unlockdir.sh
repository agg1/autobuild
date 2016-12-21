#!/bin/sh
CDIR=$1
[ -z "${CDIR}" -o ! -e "${CDIR}" ] && echo "directory error" && exit
/usr/sbin/e4crypt get_policy "${CDIR}" | grep "Error getting policy" > /dev/null 2>&1 && echo "policy error" && exit
/usr/sbin/e4crypt add_key -S 0xffff $1
