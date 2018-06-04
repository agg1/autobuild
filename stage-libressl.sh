# HOWTO libressl

mkdir -p /tmp/stage3
cd /tmp/stage3
#tar -xf ../stage3-amd64-hardened+nomultilib-20160908.tar.bz2
tar -xf ../stage3-amd64-hardened-20180531T214503Z.tar.xz

mkdir -p /tmp/stage3/usr/portage/

mount --bind /dev /tmp/stage3/dev
mount --bind /proc /tmp/stage3/proc
mount --bind /usr/portage /tmp/stage3/usr/portage
mkdir -p /tmp/stage3/usr/portage/distfiles
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

#
echo "dev-lang/perl ~amd64" >> /etc/portage/package.accept_keywords
echo "virtual/perl-Test-Harness ~amd64" >> /etc/portage/package.accept_keywords
echo "virtual/perl-ExtUtils-ParseXS ~amd64" >> /etc/portage/package.accept_keywords
echo "virtual/perl-Getopt-Long ~amd64" >> /etc/portage/package.accept_keywords
echo "virtual/perl-version ~amd64" >> /etc/portage/package.accept_keywords
echo "virtual/perl-Test-Harness ~amd64" >> /etc/portage/package.accept_keywords
echo "virtual/perl-ExtUtils-MakeMaker ~amd64" >> /etc/portage/package.accept_keywords
echo "virtual/perl-Perl-OSType ~amd64" >> /etc/portage/package.accept_keywords
echo "virtual/perl-Data-Dumper ~amd64" >> /etc/portage/package.accept_keywords
echo "virtual/perl-Module-Metadata ~amd64" >> /etc/portage/package.accept_keywords
echo "virtual/perl-File-Spec ~amd64" >> /etc/portage/package.accept_keywords
echo "virtual/perl-CPAN-Meta ~amd64" >> /etc/portage/package.accept_keywords
echo "virtual/perl-Parse-CPAN-Meta ~amd64" >> /etc/portage/package.accept_keywords
echo "virtual/perl-JSON-PP ~amd64" >> /etc/portage/package.accept_keywords
#
echo "sys-libs/gdbm ~amd64" >> /etc/portage/package.accept_keywords

emerge -1q gentoolkit && \
emerge -C openssl && \
emerge -1q libressl && \
emerge -1q openssh && \
emerge -1q wget && \
emerge -1q =sys-libs/gdbm-1.14.1 && \
emerge -1q =dev-lang/python-2.7.14-r2 =dev-lang/python-3.5.5-r1 && \
emerge -1q net-misc/iputils && \
emerge --update --deep dev-lang/perl && \
emerge -q @preserved-rebuild && \
revdep-rebuild && \
emerge -C gentoolkit

# gdbm and perl,libintl-perl emerge required otherwise boot seed stage build fails with conflict

exit

umount /tmp/stage3/usr/portage/distfiles
umount /tmp/stage3/usr/portage
umount /tmp/stage3/proc
umount /tmp/stage3/dev
rmdir /usr/portage/distfiles

cd /tmp/stage3/
tar -jcpf ../stage3-amd64-hardened+multilib-libressl.tar.bz2 .
cd /tmp
shash -a md5 stage3-amd64-hardened+multilib-libressl.tar.bz2 > stage3-amd64-hardened+multilib-libressl.tar.bz2.DIGESTS
shash -a sha256 stage3-amd64-hardened+multilib-libressl.tar.bz2 >> stage3-amd64-hardened+multilib-libressl.tar.bz2.DIGESTS
shash -a whirlpool stage3-amd64-hardened+multilib-libressl.tar.bz2 >> stage3-amd64-hardened+multilib-libressl.tar.bz2.DIGESTS
