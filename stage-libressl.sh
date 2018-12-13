# HOWTO libressl

cd /
rm -rf /tmp/stage3
mkdir -p /tmp/stage3
cd /tmp/stage3
#tar -xf ../stage3-amd64-hardened+nomultilib-20160908.tar.bz2
#tar -xf ../stage3-amd64-hardened-20180531T214503Z.tar.xz
tar -xf /media/DISTFILES/release/release-2018/gentoo/stage3-amd64-uclibc-hardened-20181105.tar.bz2

mkdir -p /tmp/stage3/usr/portage/

mount --bind /dev /tmp/stage3/dev
mount --bind /proc /tmp/stage3/proc
mount --bind /usr/portage /tmp/stage3/usr/portage
mkdir -p /tmp/stage3/usr/portage/distfiles
mount --bind /usr/distfiles /tmp/stage3/usr/portage/distfiles

chroot /tmp/stage3

echo 'USE="${USE} ssl uclibc libressl -openssl curl_ssl_libressl -curl_ssl_openssl -gcrypt -gnutls -nettle"' >> /etc/portage/make.conf
echo 'USE_ORDER="pkg:env:conf:defaults:pkginternal:repo:env.d"' >> /etc/portage/make.conf
echo 'net-misc/curl ssl libressl curl_ssl_libressl -curl_ssl_openssl -gcrypt -gnutls -nettle' > /etc/portage/package.use/libressl
echo 'net-misc/wget ssl libressl -gcrypt -gnutls -nettle' >> /etc/portage/package.use/libressl
echo 'net-misc/iputils ssl libressl gcrypt -gnutls -nettle -caps -filecaps' > /etc/portage/package.use/iputils 

#echo "dev-libs/libressl ~amd64" >> /etc/portage/package.accept_keywords
#echo "net-misc/openssh ~amd64" >> /etc/portage/package.accept_keywords 
#echo "net-misc/iputils ~amd64" >> /etc/portage/package.accept_keywords 
#echo "net-misc/wget ~amd64" >> /etc/portage/package.accept_keywords 
echo "dev-lang/python ~amd64" >> /etc/portage/package.accept_keywords
#echo "dev-lang/python-exec ~amd64" >> /etc/portage/package.accept_keywords
#echo "dev-lang/eselect-python ~amd64" >> /etc/portage/package.accept_keywords

#echo "dev-lang/perl ~amd64" >> /etc/portage/package.accept_keywords
#echo "virtual/perl-Test-Harness ~amd64" >> /etc/portage/package.accept_keywords
#echo "virtual/perl-ExtUtils-ParseXS ~amd64" >> /etc/portage/package.accept_keywords
#echo "virtual/perl-Getopt-Long ~amd64" >> /etc/portage/package.accept_keywords
#echo "virtual/perl-version ~amd64" >> /etc/portage/package.accept_keywords
#echo "virtual/perl-Test-Harness ~amd64" >> /etc/portage/package.accept_keywords
#echo "virtual/perl-ExtUtils-MakeMaker ~amd64" >> /etc/portage/package.accept_keywords
#echo "virtual/perl-Perl-OSType ~amd64" >> /etc/portage/package.accept_keywords
#echo "virtual/perl-Data-Dumper ~amd64" >> /etc/portage/package.accept_keywords
#echo "virtual/perl-Module-Metadata ~amd64" >> /etc/portage/package.accept_keywords
#echo "virtual/perl-File-Spec ~amd64" >> /etc/portage/package.accept_keywords
#echo "virtual/perl-CPAN-Meta ~amd64" >> /etc/portage/package.accept_keywords
#echo "virtual/perl-Parse-CPAN-Meta ~amd64" >> /etc/portage/package.accept_keywords
#echo "virtual/perl-JSON-PP ~amd64" >> /etc/portage/package.accept_keywords
echo "sys-libs/gdbm ~amd64" >> /etc/portage/package.accept_keywords

emerge -C openssl && \
emerge -C curl && \
emerge -1q libressl && \
emerge -1q openssh && \
emerge -1q wget && \
emerge -1q =sys-libs/gdbm-1.14.1 && \
emerge -1q =dev-lang/python-2.7.14-r2 =dev-lang/python-3.6.5-r1 && \
emerge -1q net-misc/iputils && \
emerge -1q net-misc/curl && \
emerge --update --deep dev-lang/perl && \
emerge -q @preserved-rebuild

exit

umount /tmp/stage3/usr/portage/distfiles
umount /tmp/stage3/usr/portage
umount /tmp/stage3/proc
umount /tmp/stage3/dev

cd /tmp/stage3/
mount -o remount,rw /media/DISTFILES

tar -jcpf /media/DISTFILES/release/release-2018/gentoo/stage3-amd64-uclibc-hardened-libressl-nolocale-20181213.tar.bz2 .
shash -a md5 /media/DISTFILES/release/release-2018/gentoo/stage3-amd64-uclibc-hardened-libressl-nolocale-20181213.tar.bz2 > /media/DISTFILES/release/release-2018/gentoo/stage3-amd64-uclibc-hardened-libressl-nolocale-20181213.tar.bz2.DIGESTS
shash -a sha256 /media/DISTFILES/release/release-2018/gentoo/stage3-amd64-uclibc-hardened-libressl-nolocale-20181213.tar.bz2 >> /media/DISTFILES/release/release-2018/gentoo/stage3-amd64-uclibc-hardened-libressl-nolocale-20181213.tar.bz2.DIGESTS
shash -a whirlpool /media/DISTFILES/release/release-2018/gentoo/stage3-amd64-uclibc-hardened-libressl-nolocale-20181213.tar.bz2 >> /media/DISTFILES/release/release-2018/gentoo/stage3-amd64-uclibc-hardened-libressl-nolocale-20181213.tar.bz2.DIGESTS

mount -o remount,ro /media/DISTFILES
cd /
rm -rf /tmp/stage3
