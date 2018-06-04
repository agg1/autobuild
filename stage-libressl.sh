# HOWTO libressl

mkdir -p /tmp/stage3
cd /tmp/stage3
#tar -xf ../stage3-amd64-hardened+nomultilib-20160908.tar.bz2
tar -xf ../stage3-amd64-hardened-20180531T214503Z.tar.xz

mkdir -p /tmp/stage3/usr/portage/distfiles

mount --bind /dev /tmp/stage3/dev
mount --bind /proc /tmp/stage3/proc
mount --bind /usr/portage /tmp/stage3/usr/portage
mount --bind /usr/distfiles /tmp/stage3/usr/portage/distfiles

chroot /tmp/stage3

echo 'USE="${USE} ssl openssl libressl curl_ssl_libressl -gcrypt -gnutls -nettle"' >> /etc/portage/make.conf
echo '*/* ssl openssl libressl curl_ssl_libressl -gcrypt -gnutls -nettle' > /etc/portage/package.use/libressl
echo 'net-misc/wget ssl openssl libressl curl_ssl_libressl -gcrypt -gnutls -nettle' >> /etc/portage/package.use/libressl
echo 'net-misc/iputils ssl openssl libressl curl_ssl_libressl -gcrypt -gnutls -nettle -caps -filecaps' > /etc/portage/package.use/iputils 

#echo "dev-libs/libressl ~amd64" >> /etc/portage/package.accept_keywords
#echo "net-misc/openssh ~amd64" >> /etc/portage/package.accept_keywords 
#echo "net-misc/iputils ~amd64" >> /etc/portage/package.accept_keywords 
#echo "net-misc/wget ~amd64" >> /etc/portage/package.accept_keywords 
echo "dev-lang/python ~amd64" >> /etc/portage/package.accept_keywords
#echo "dev-lang/python-exec ~amd64" >> /etc/portage/package.accept_keywords
#echo "dev-lang/eselect-python ~amd64" >> /etc/portage/package.accept_keywords

emerge -C openssl && \
emerge -1q libressl && \
emerge -1q openssh && \
emerge -1q wget && \
emerge -1q =dev-lang/python-2.7.14-r2 =dev-lang/python-3.5.5-r1 && \
emerge -1q net-misc/iputils && \
emerge -q @preserved-rebuild

exit

umount /tmp/stage3/usr/portage/distfiles
umount /tmp/stage3/usr/portage
umount /tmp/stage3/proc
umount /tmp/stage3/dev

cd /tmp/stage3/
tar -jcpf ../stage3-amd64-hardened+multilib-libressl.tar.bz2 .
cd /tmp
shash -a md5 stage3-amd64-hardened+multilib-libressl.tar.bz2 > stage3-amd64-hardened+multilib-libressl.tar.bz2.DIGESTS
shash -a sha256 stage3-amd64-hardened+multilib-libressl.tar.bz2 >> stage3-amd64-hardened+multilib-libressl.tar.bz2.DIGESTS
shash -a whirlpool stage3-amd64-hardened+multilib-libressl.tar.bz2 >> stage3-amd64-hardened+multilib-libressl.tar.bz2.DIGESTS
