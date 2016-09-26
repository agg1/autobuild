export MAKEOPTS="-j16"
#STAMP=$(date -u +%s)
export STAMP=latest
export TARGT=
export CCONF="/home/catalyst/catalyst-cache.conf"
export CADIR="/home/catalyst"
export RELDA="$(date +%Y%m%d)"
export BDDIR="/var/tmp/catalyst/builds/hardened"

# thunder,firefox flags
# custom hexchat, ircd-hybrid
# packages libreoffice etc.
# jitsi, mumble, WendzelNNTPd, yatb
# consider user mode linux
# add LINGUAS etc to make.defaults
# set emerge flags in make.defaults
# consider minimal flag
# fix isolinux startup
# check profile package.mask
# check why package.keywords are necessary

#sync portage tree to latest
#musl overlay
#java overlay
#systrace overlay
#fix kerncache catalyst.conf option
#add portage tree to livecd
#umount /dev/pts /dev/shm
#bash util-linux etc...
#see portage profiles for further use flags
#sync NIST CVE database
#sync portage tree
#check signatures
#tighten systrace profiles
#test hardening features
#test build with -udev

#http://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-hardened+nomultilib/
#wget http://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64/hardened/stage3-amd64-hardened+nomultilib-20160908.tar.bz2
#wget http://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64/hardened/stage3-amd64-hardened+nomultilib-20160908.tar.bz2.CONTENTS
#wget http://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64/hardened/stage3-amd64-hardened+nomultilib-20160908.tar.bz2.DIGESTS
#wget http://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64/hardened/stage3-amd64-hardened+nomultilib-20160908.tar.bz2.DIGESTS.asc
#http://distfiles.gentoo.org/experimental/amd64/musl/
#wget http://distfiles.gentoo.org/experimental/amd64/musl/stage3-amd64-musl-hardened-20160904.tar.bz2
#wget http://distfiles.gentoo.org/experimental/amd64/musl/stage3-amd64-musl-hardened-20160904.tar.bz2.CONTENTS
#wget http://distfiles.gentoo.org/experimental/amd64/musl/stage3-amd64-musl-hardened-20160904.tar.bz2.DIGESTS
#wget http://distfiles.gentoo.org/experimental/amd64/musl/stage3-amd64-musl-hardened-20160904.tar.bz2.DIGESTS.asc

mkdir -p /var/tmp/catalyst/builds/hardened
#/home/source/portage/repo/gentoo/profiles/hardened/linux/amd64/no-multilib/
ln -sf /home/catalyst/portage/profiles/hardened/linux/musl/amd64/ /home/catalyst/etc/portage/make.profile

cp /home/catalyst/etc/portage/make.defaults /usr/portage/profiles/hardened/linux/amd64/no-multilib/

#umount -f /var/tmp/catalyst/tmp/hardened/livecd-stage1-amd64-latest/tmp/kerncache
#umount -f /var/tmp/catalyst/tmp/hardened/livecd-stage1-amd64-latest/usr/portage/packages
#umount -f /var/tmp/catalyst/tmp/hardened/livecd-stage1-amd64-latest/usr/portage/distfiles
#umount -f /var/tmp/catalyst/tmp/hardened/livecd-stage1-amd64-latest/usr/portage
#umount -f /var/tmp/catalyst/tmp/hardened/livecd-stage1-amd64-latest/proc
#umount -f /var/tmp/catalyst/tmp/hardened/livecd-stage1-amd64-latest/dev/shm
#umount -f /var/tmp/catalyst/tmp/hardened/livecd-stage1-amd64-latest/dev/pts
#umount -f /var/tmp/catalyst/tmp/hardened/livecd-stage1-amd64-latest/dev
#rm -rf /var/tmp/catalyst/kerncache/ /var/tmp/catalyst/packages/ /var/tmp/catalyst/snapshot_cache/ /var/tmp/catalyst/tmp/*

mkdir -p ${CADIR}/seeds/desktop/${RELDA}
mkdir -p ${CADIR}/seeds/init/${RELDA}
mkdir -p ${CADIR}/seeds/minimal/${RELDA}

catalyst -v -c ${CCONF} -s $STAMP

### build seed tarball from official stage3 seed
cp ${CADIR}/seeds/gentoo/stage3-amd64-hardened+nomultilib-20160908.tar.bz2* /var/tmp/catalyst/builds/hardened
rm -f ${CADIR}/seeds/init/latest
sg wanout -c "catalyst -v -F -f /home/catalyst/specs/amd64/hardened/stage1-nomultilib-init.spec -c ${CCONF} -C version_stamp=$STAMP" && \
catalyst -v -f /home/catalyst/specs/amd64/hardened/stage1-nomultilib-init.spec -c ${CCONF} -C version_stamp=$STAMP && \
catalyst -v -f /home/catalyst/specs/amd64/hardened/stage2-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP && \
catalyst -v -f /home/catalyst/specs/amd64/hardened/stage3-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP && \
catalyst -v -f /home/catalyst/specs/amd64/hardened/stage4-nomultilib-minimal.spec -c ${CCONF} -C version_stamp=$STAMP && \
cp -p ${BDDIR}/stage*-amd64-latest.tar.bz2* ${CADIR}/seeds/init/${RELDA} && \
ln -sf ${CADIR}/seeds/init/${RELDA} ${CADIR}/seeds/init/latest

### build seed tarball
cp ${CADIR}/seeds/init/latest/* ${BDDIR}
rm -f ${CADIR}/seeds/init/latest
sg wanout -c "catalyst -v -F -f /home/catalyst/specs/amd64/hardened/stage1-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP" && \
catalyst -v -f /home/catalyst/specs/amd64/hardened/stage1-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP && \
catalyst -v -f /home/catalyst/specs/amd64/hardened/stage2-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP && \
catalyst -v -f /home/catalyst/specs/amd64/hardened/stage3-nomultilib.spec -c ${CCONF} -C version_stamp=$STAMP && \
catalyst -v -f /home/catalyst/specs/amd64/hardened/stage4-nomultilib-minimal.spec -c ${CCONF} -C version_stamp=$STAMP && \
cp -p ${BDDIR}/stage*-amd64-latest.tar.bz2* ${CADIR}/seeds/init/${RELDA} && \
ln -sf ${CADIR}/seeds/init/${RELDA} ${CADIR}/seeds/init/latest

### build minimal livecd from new seed tarball
cp ${CADIR}/seeds/init/latest/* ${BDDIR}
rm -f ${CADIR}/seeds/minimal/latest
sg wanout -c "catalyst -v -F -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-init.spec -c ${CCONF} -C version_stamp=$STAMP" && \
catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-init.spec -c ${CCONF} -C version_stamp=$STAMP && \
catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened-init.spec -c ${CCONF} -C version_stamp=$STAMP && \
cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${CADIR}/seeds/minimal/${RELDA} && \
cp -p ${BDDIR}/admincd-amd64-latest.iso* ${CADIR}/seeds/minimal/${RELDA} && \
ln -sf ${CADIR}/seeds/minimal/${RELDA} ${CADIR}/seeds/minimal/latest

### build desktop livecd from minimal seed tarball
#cp ${CADIR}/seeds/desktop/latest/* ${BDDIR}
cp ${CADIR}/seeds/minimal/latest/* ${BDDIR}
rm -f ${CADIR}/seeds/desktop/latest
sg wanout -c "catalyst -v -F -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened.spec -c ${CCONF} -C version_stamp=$STAMP" && \
catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened.spec -c ${CCONF} -C version_stamp=$STAMP && \
catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage2-hardened.spec -c ${CCONF} -C version_stamp=$STAMP && \
cp -p ${BDDIR}/livecd-stage*-amd64-latest.tar.bz2* ${CADIR}/seeds/desktop/${RELDA} && \
cp -p ${BDDIR}/admincd-amd64-latest.iso* ${CADIR}/seeds/desktop/${RELDA} && \
ln -sf ${CADIR}/seeds/desktop/${RELDA} ${CADIR}/seeds/desktop/latest

### hardened musl livecd
#cp /home/catalyst/seeds/stage3-amd64-musl-hardened-20160904.tar.bz2 /var/tmp/catalyst/builds/hardened
##catalyst -v -c ${CCONF} -C target=snapshot version_stamp=$STAMP
#sg wanout -c "catalyst -v -F -f /home/catalyst/specs/amd64/hardened/admincd-stage1-musl.spec -c ${CCONF} -C version_stamp=$STAMP"
#catalyst -v -f /home/catalyst/specs/amd64/hardened/admincd-stage1-musl.spec -c ${CCONF} -C version_stamp=$STAMP
