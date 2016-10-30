# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit cmake-utils 

DESCRIPTION="encryption add-on for irssi"
HOMEPAGE="https://github.com/falsovsky/FiSH-irssi"
SRC_URI="https://github.com/falsovsky/FiSH-irssi/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~sparc x86"
IUSE=""

RESTRICT="test"

MYSQL=NO
CONFDIR=/etc

RDEPEND="net-irc/irssi"
DEPEND="${RDEPEND}"

#src_configure() {
#	cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr .
#}

#src_compile() {
#	emake
#}

#src_install() {
#make install
#	dobin bin/wendzelnntpadm
#	dobin bin/wendzelnntpd
#	newdoc docs/docs.pdf wendzelnntpd.pdf
#	dodoc README
#	dodoc CHANGELOG
#	insinto /etc
#	doins wendzelnntpd.conf
#}
