# Copyright 2023 LFPraca
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Subr renames subtitle files to match video titles"
HOMEPAGE="https://github.com/lfpraca/subr"
SRC_URI="https://github.com/lfpraca/subr/releases/download/v${PV}/${PN}"

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
