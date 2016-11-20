#!/bin/sh -e

export GENTOO_MIRRORS="http://ftp.wh2.tu-dresden.de/pub/mirrors/gentoo/ http://ftp.uni-erlangen.de/pub/mirrors/gentoo http://gd.tuwien.ac.at/opsys/linux/gentoo/"

#equery l -p '*'
#equery l -o '*'
#CLIST=$(equery l -p --format='$category' '*' | uniq)
# for c in ${CLIST} ; do
#	PKLIST=$(equery l -p --format='$category/$name' "${c}/*")
#	emerge --nodeps --noreplace --deep -f $PKLIST
#done

PKLIST=$(equery l -p --format='$category/$name' '*')
for p in $PKLIST ; do 
	emerge --nodeps --noreplace -f $p || echo $p >> fetch-error.log
done

chown root:portage /usr/portage/distfiles/*
chmod 644 /usr/portage/distfiles/*
