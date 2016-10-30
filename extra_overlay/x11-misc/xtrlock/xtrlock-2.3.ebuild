# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit toolchain-funcs

DESCRIPTION="A simplistic screen locking program for X"
HOMEPAGE="http://ftp.debian.org/debian/pool/main/x/xtrlock/"
SRC_URI="mirror://debian/pool/main/x/${PN}/${P/-/_}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~ppc"

RDEPEND="
	x11-libs/libX11
"
DEPEND="
	${RDEPEND}
	x11-proto/xproto
	x11-misc/imake
"

src_compile() {
	xmkmf || die
	emake CDEBUGFLAGS="${CFLAGS} -DSHADOW_PWD" CC="$(tc-getCC)" \
		EXTRA_LDOPTIONS="${LDFLAGS}" xtrlock
}

src_install() {
	dobin xtrlock
	chmod u+s "${D}"/usr/bin/xtrlock
	newman xtrlock.man xtrlock.1
}
