# HOWTO libressl

mkdir -p /tmp/stage3
cd /tmp/stage3
tar -xf /home/seeds/gentoo/stage3-amd64-hardened+nomultilib-20160908.tar.bz2

mkdir -p /tmp/stage3/usr/portage/distfiles

mount --bind /dev /tmp/stage3/dev
mount --bind /proc /tmp/stage3/proc
mount --bind /usr/portage /tmp/stage3/usr/portage
mount --bind /home/distfiles /tmp/stage3/usr/portage/distfiles

chroot /tmp/stage3

echo 'USE="${USE} ssl openssl libressl curl_ssl_libressl -gcrypt -gnutls -nettle"' >> /etc/portage/make.conf
echo '*/* ssl openssl libressl curl_ssl_libressl -gcrypt -gnutls -nettle' > /etc/portage/package.use/libressl
echo 'net-misc/wget ssl openssl libressl curl_ssl_libressl -gcrypt -gnutls -nettle' >> /etc/portage/package.use/libressl
echo 'net-misc/iputils ssl openssl libressl curl_ssl_libressl -gcrypt -gnutls -nettle -caps -filecaps' > /etc/portage/package.use/iputils 

echo "dev-libs/libressl ~amd64" >> /etc/portage/package.accept_keywords
echo "net-misc/openssh ~amd64" >> /etc/portage/package.accept_keywords 
echo "net-misc/iputils ~amd64" >> /etc/portage/package.accept_keywords 
echo "net-misc/wget ~amd64" >> /etc/portage/package.accept_keywords 
echo "dev-lang/python ~amd64" >> /etc/portage/package.accept_keywords
echo "dev-lang/python-exec ~amd64" >> /etc/portage/package.accept_keywords
echo "dev-lang/eselect-python ~amd64" >> /etc/portage/package.accept_keywords
#echo "=dev-lang/python-2.7.11-r2" >> /etc/portage/package.accept_keywords
#echo "=dev-lang/python-3.4.3-r7" >> /etc/portage/package.accept_keywords
#echo "=dev-lang/python-exec-2.4.3" >> /etc/portage/package.accept_keywords

emerge -C openssl && \
emerge -1q libressl && \
emerge -1q openssh && \
emerge -1q wget && \
emerge -1q =dev-lang/python-2.7.11-r2 =dev-lang/python-3.4.3-r7 && \
emerge -1q net-misc/iputils && \
emerge -q @preserved-rebuild

exit

umount /tmp/stage3/usr/portage/distfiles
umount /tmp/stage3/usr/portage
umount /tmp/stage3/proc
umount /tmp/stage3/dev

cd /tmp/stage3/
tar -jcpf ../stage3-amd64-hardened+nomultilib-libressl.tar.bz2 .
cd /tmp
echo "# SHA512 HASH" > stage3-amd64-hardened+nomultilib-libressl.tar.bz2.DIGESTS
sha512sum stage3-amd64-hardened+nomultilib-libressl.tar.bz2 >> stage3-amd64-hardened+nomultilib-libressl.tar.bz2.DIGESTS
echo "# WHIRLPOOL HASH" >> stage3-amd64-hardened+nomultilib-libressl.tar.bz2.DIGESTS
whirlpooldeep -l stage3-amd64-hardened+nomultilib-libressl.tar.bz2 >> stage3-amd64-hardened+nomultilib-libressl.tar.bz2.DIGESTS

mv /tmp/stage3-amd64-hardened+nomultilib-libressl.tar.bz2* /home/seeds/gentoo/
