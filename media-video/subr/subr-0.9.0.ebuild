# Copyright 2023 LFPraca
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Subr renames subtitle files to match video titles"
HOMEPAGE="https://github.com/lfpraca/subr"
SRC_URI="https://github.com/lfpraca/subr/releases/download/v${PV}/${PN}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

LICENSE="Apache-2.0"
SLOT="0"

DEPEND="dev-lang/perl"

src_unpack() {
	mkdir "${P}" || die
	cp --dereference "${DISTDIR}/${PN}" "${P}" || die
}

src_install() {
	dobin subr
}
