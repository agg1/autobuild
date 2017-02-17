#!/bin/sh -e
# Copyright aggi 2017

#cat /proc/sys/kernel/random/entropy_avail

gpgcfg="/tmp/gpgcfg-$RANDOM"

echo "enter cred"
read -s gpw

export GPGDIR="${GPGDIR:-/home/autobuild/gpg}"
export GNUPGHOME=${GPGDIR}


cat ${GNUPGHOME}/config > ${gpgcfg}
echo "Passphrase: $gpw" >> ${gpgcfg}

gpg --gen-key --enable-large-rsa --batch < ${gpgcfg}
#echo "passwd" | gpg --command-fd 0 --edit-key Autobuild

gpg -a --export > ${GNUPGHOME}/autobuild.pub
gpg --list-key

shred ${gpgcfg}
rm -f ${gpgcfg}
