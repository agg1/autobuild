#!/bin/sh -e
# Copyright aggi 2017

#cat /proc/sys/kernel/random/entropy_avail

rm -f /home/autobuild/gpg/*.gpg
rm -f /home/autobuild/gpg/*.gpg~
rm -f /home/autobuild/gpg/*.pub

gpgcfg="/tmp/gpgcfg-$RANDOM"


export GPGDIR="${GPGDIR:-/home/autobuild/gpg}"
export GNUPGHOME=${GPGDIR}

cat ${GNUPGHOME}/config > ${gpgcfg}

#echo "enter cred"
#read -s gpw
#echo "Passphrase: $gpw" >> ${gpgcfg}
#gpg --gen-key --enable-large-rsa --batch < ${gpgcfg}
#echo "passwd" | gpg --command-fd 0 --edit-key Autobuild

gpg --passphrase-file /dev/null --gen-key --enable-large-rsa --batch < ${gpgcfg}

gpg -a --export > ${GNUPGHOME}/autobuild.pub
gpg --list-key

shred ${gpgcfg}
rm -f ${gpgcfg}
