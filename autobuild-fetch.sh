#!/bin/sh -e

export GENTOO_MIRRORS="http://ftp.wh2.tu-dresden.de/pub/mirrors/gentoo/ http://ftp.uni-erlangen.de/pub/mirrors/gentoo http://gd.tuwien.ac.at/opsys/linux/gentoo/"
unset EMERGE_DEFAULT_OPTS

# check that bind mounts are set and portage trees are in place
[ ! -e /usr/writeable ] && /usr/local/bin/prepareusrupdate.sh /media/stick/container/seeds/portage/20161118-1479508385/portage-latest.tar.bz2
if [ ! -e /usr/writeable ] ; then
	mkdir -p /usr/portage/distfiles
	mkdir -p /usr/portage/packages
	mount --bind /media/stick/container/packages-desktop /usr/portage/packages
	mount --bind /home/distfiles /usr/portage/distfiles
fi

# fetch with ftp, should suffice usually but might miss some distfiles if not done regularly
fetch_ftp() {
	echo "### fetch_ftp()"
	
	cd /home/distfiles
	FTPLIST=$(sg portage -c 'ncftpls -u ftp -p ftp ftp://ftp.wh2.tu-dresden.de/pub/mirrors/gentoo/distfiles/')
	for f in $FTPLIST ; do
		sg portage -c "ncftpget -u ftp -p ftp -F ftp://ftp.wh2.tu-dresden.de/pub/mirrors/gentoo/distfiles/$f"
		#sg portage -c "wget -N ftp://ftp.wh2.tu-dresden.de/pub/mirrors/gentoo/distfiles/$f"
	done
}

# fetch with catalyst, only those distfiles are fetched which will be included with dvd release
fetch_catalyst() {
	echo "### fetch_catalyst()"
	
	mkdir -p /var/tmp/catalyst/builds/hardened
	cp /media/stick/container/seeds/init/20161117-1479426114/stage3-amd64-latest.tar.bz2* /var/tmp/catalyst/builds/hardened

	iptables -P OUTPUT ACCEPT
	catalyst -v -F -f /home/catalyst/specs/amd64/hardened/admincd-stage1-hardened-desktop.spec -c /media/stick/container/catalyst/catalystrc -C version_stamp=latest source_subpath=hardened/hardened/stage3-amd64-latest.tar.bz2
	iptables -P OUTPUT DROP

	rm -f /var/tmp/catalyst/builds/hardened/*
}

# fetch with emerge, might miss some distfiles if use flag or other restrictions apply
fetch_emerge() {
	echo "### fetch_emerge()"
	
	find /etc/portage | grep '._cfg' | xargs -0 /bin/rm -f
	PKLIST=$(equery l -p --format='$category/$name' '*')
	for p in $PKLIST ; do 
		emerge --nodeps --noreplace -f $p || echo $p >> fetch-error.log
	done
	find /etc/portage | grep '._cfg' | xargs -0 /bin/rm -f

	chown root:portage /usr/portage/distfiles/*
	chmod 644 /usr/portage/distfiles/*
}

#equery l -p '*'
#equery l -o '*'
#CLIST=$(equery l -p --format='$category' '*' | uniq)
# for c in ${CLIST} ; do
#	PKLIST=$(equery l -p --format='$category/$name' "${c}/*")
#	emerge --nodeps --noreplace --deep -f $PKLIST
#done
