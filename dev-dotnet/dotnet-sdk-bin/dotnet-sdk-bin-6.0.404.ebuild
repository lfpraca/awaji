# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION=".NET is a free, cross-platform, open-source developer platform"
HOMEPAGE="https://dotnet.microsoft.com/"
LICENSE="MIT"

SRC_URI="
amd64? (
	elibc_glibc? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-x64.tar.gz )
	elibc_musl? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-musl-x64.tar.gz )
)
arm? (
	elibc_glibc? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-arm.tar.gz )
	elibc_musl? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-musl-arm.tar.gz )
)
arm64? (
	elibc_glibc? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-arm64.tar.gz )
	elibc_musl? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-musl-arm64.tar.gz )
)
"

SLOT="6.0"
KEYWORDS="-* ~amd64 ~arm ~arm64"
IUSE="+dotnet-common"
QA_PREBUILT="*"
RESTRICT+=" splitdebug"
RDEPEND="
	app-crypt/mit-krb5:0/0
	dev-libs/icu
	dev-util/lttng-ust:0/2.12
	sys-libs/zlib:0/1
	dotnet-common? ( !dev-dotnet/dotnet-sdk-bin:7.0[dotnet-common(+)] )
	!dotnet-common? ( dev-dotnet/dotnet-sdk-bin:7.0[dotnet-common(+)] )
"

S=${WORKDIR}

src_install() {
	local dest="usr/share/dotnet"
	dodir "${dest}"
	dodir "${dest}/packs"

	# Create a magic workloads file, bug #841896
	local featureband="$(ver_cut 3 | sed "s/[0-9]/0/2g")"
	local workloads="metadata/workloads/${SLOT}.${featureband}"
	{ mkdir -p "${S}/${workloads}" && touch "${S}/${workloads}/userlocal"; } || die

	{ find "${S}" -mindepth 1 -maxdepth 1 -type d ! -name 'packs' -exec mv -t "${ED}/${dest}" {} + && fperms 0755 "/${dest}"; } || die
	find "${S}/packs" -mindepth 1 -maxdepth 1 -type d ! -name 'NETStandard.Library.Ref' -exec mv -t "${ED}/${dest}/packs" {} + || die

	if use dotnet-common; then
		find "${S}" -mindepth 1 -maxdepth 1 -type f -exec mv -t "${ED}/${dest}" {} + || die
		mv "${S}/packs/NETStandard.Library.Ref" "${ED}/${dest}/packs" || die
		dosym "../${dest#*/}/dotnet" "/usr/bin/dotnet"

		# set an env-variable for 3rd party tools
		echo "DOTNET_ROOT=/${dest}" > "${T}/90${PN}-${SLOT}" || die
		doenvd "${T}/90${PN}-${SLOT}"
	fi
}
