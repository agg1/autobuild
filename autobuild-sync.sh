#!/bin/sh -e

export GENTOO_MIRRORS="http://ftp.wh2.tu-dresden.de/pub/mirrors/gentoo/ http://ftp.uni-erlangen.de/pub/mirrors/gentoo http://gd.tuwien.ac.at/opsys/linux/gentoo/"
unset EMERGE_DEFAULT_OPTS

DISTFILES=/media/distfiles
PACKAGES=/home/packages/desktop

# check that bind mounts are set and portage trees are in place
[ ! -e /usr/.writeable ] && /usr/local/bin/prepareusrupdate.sh /home/portage
if [ ! -e /usr/.writeable ] ; then
	mkdir -p /usr/portage/distfiles
	mkdir -p /usr/portage/packages
	#mount -o relatime,sync,dirsync,nodev,nosuid,noexec /dev/disk/by-label/DISTFILES /home/distfiles/ || true
	mount --bind ${PACKAGES} /usr/portage/packages
	mount --bind ${DISTFILES} /usr/portage/distfiles
fi

 
sync_portage() {
        echo "### sync_portage()"
	cd /usr/portage
	#git commit --amend --author="aggi <aggi@padwalker.com>"
	git config --global user.name aggi || ( echo "git config error" && false )
	git config --global user.email "aggi@padwalker.com" || ( echo "git config error" && false )
	sg portage -c "git pull --rebase"
	#sg portage -c "emerge --sync"
	sg portage -c "emaint -A sync"
	#sg portage -c "emerge --oneshot portage"
	cd -
}

### DAILY
# sync gentoo git repositories
fetch_portage() {
	# 5d3f2c71155c8d813976a376507a8dbf31be6a8c
	echo "### fetch_portage()"

	umask 002
	GLIST=$(find /home/source/portage -maxdepth 2 -type d )
	for g in $GLIST ; do
		[ ! -e ${g}/.git ] && continue
		echo "syncing ${g}"
		cd ${g} ; git reset --hard ; git clean -f ; git fsck
		sg wanout -c 'git pull --rebase'
	done
	chown -R root:portage /home/source/portage/*
	chmod -R g+rwX /home/source/portage/*
	chmod -R o+rX /home/source/portage/*
}

### DAILY
# same as fetch_ftp() but directory listing is only done once with it
fetch_wget() {
	echo "### fetch_wget()"

	umask 002
	cd $DISTFILES
	sg portage -c "wget -N ftp://ftp.wh2.tu-dresden.de/pub/mirrors/gentoo/distfiles/*"
	chmod 664 $DISTFILES/* ; chown root:portage $DISTFILES/*
}

## fetch with ftp, should suffice usually but might miss some distfiles if not done regularly
#fetch_ftp() {
#	echo "### fetch_ftp()"
#	
#	cd /home/distfiles
#	FTPLIST=$(sg portage -c 'ncftpls -u ftp -p ftp ftp://ftp.wh2.tu-dresden.de/pub/mirrors/gentoo/distfiles/')
#	for f in $FTPLIST ; do
#		echo $f
#		sg portage -c "ncftpget -u ftp -p ftp -F ftp://ftp.wh2.tu-dresden.de/pub/mirrors/gentoo/distfiles/$f"
#		sg portage -c "wget -N ftp://ftp.wh2.tu-dresden.de/pub/mirrors/gentoo/distfiles/$f"
#	done
#}

### WEEKLY
# fetch with catalyst, only those distfiles are fetched which will be included with dvd release
fetch_catalyst() {
	echo "### fetch_catalyst()"

	mkdir -p /var/tmp/catalyst/builds/hardened
	#cp /home/seeds/init/20161126-1480193160/stage3-amd64-latest.tar.bz2* /var/tmp/catalyst/builds/hardened
	cp /home/seeds/gentoo/stage3-amd64-hardened+nomultilib-libressl.tar.bz2* /var/tmp/catalyst/builds/hardened
	#cp /home/seeds/desktop/20161126-1480193160/livecd-stage1-amd64-latest.tar.bz2* \
	#/var/tmp/catalyst/builds/hardened

	iptables -P OUTPUT ACCEPT
	catalyst -v -c /home/autobuild/catalystrc -s latest
	catalyst -v -c /home/autobuild/catalystrc -F -f \
	/home/autobuild/specs/amd64/hardened/admincd-stage1-hardened-desktop.spec \
	-C version_stamp=latest source_subpath=hardened/stage3-amd64-hardened+nomultilib-libressl.tar.bz2
	iptables -P OUTPUT DROP

	rm -f /var/tmp/catalyst/builds/hardened/*
	chmod 644 $DISTFILES/* ; chown root:root $DISTFILES/*
}

### WEEKLY
# fetch with emerge, might miss some distfiles if use flag or other restrictions apply
fetch_emerge() {
	echo "### fetch_emerge()"
	
	find /etc/portage | grep '._cfg' | xargs /bin/rm -f
	PKLIST=$(equery l -p --format='$category/$name' '*')
	for p in $PKLIST ; do 
		emerge --ignore-default-opts --jobs=1 --nodeps --noreplace -f $p || echo $p >> fetch-error.log
	done
	find /etc/portage | grep '._cfg' | xargs /bin/rm -f

	chmod 644 $DISTFILES/* ; chown root:root $DISTFILES/*
}

#equery l -p '*'
#equery l -o '*'
#CLIST=$(equery l -p --format='$category' '*' | uniq)
# for c in ${CLIST} ; do
#	PKLIST=$(equery l -p --format='$category/$name' "${c}/*")
#	emerge --nodeps --noreplace --deep -f $PKLIST
#done
