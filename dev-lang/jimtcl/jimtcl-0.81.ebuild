# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="Small footprint implementation of Tcl programming language"
HOMEPAGE="https://jim.tcl.tk/"
SRC_URI="https://github.com/msteveb/jimtcl/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0/${PV}"
KEYWORDS="amd64 arm ~arm64 ~m68k ~mips ~s390 x86"
IUSE="doc static-libs"

DEPEND="
	dev-lang/tcl:0
"

src_configure() {
	CCACHE=none econf --disable-docs --shared
	if use static-libs ; then
		# The build does not support doing both simultaneously.
		mkdir static-libs || die
		cd static-libs || die
		CCACHE=none ECONF_SOURCE="${S}" econf --disable-docs
	fi
}

src_compile() {
	# Must build static-libs first.
	use static-libs && emake -C static-libs libjim.a
	emake all
}

src_install() {
	default
	ln -sf libjim.so.${PV} "${ED}"/usr/$(get_libdir)/libjim.so || die
	use static-libs && dolib.a static-libs/libjim.a
	use doc && dodoc Tcl_shipped.html
}
