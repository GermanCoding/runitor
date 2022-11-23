#!/bin/bash
set -e
program="runitor"
version="1.1.1~rc.1"
revision=1
debversion="${version}-${revision}"
github="https://github.com/bdd/runitor/releases/download/"
prefix="/usr/bin"
pversion="v${version//\~/-}"
platform="linux"
control="DEBIAN/control"
declare -A supported_archs
supported_archs=(["amd64"]="amd64" ["armhf"]="arm" ["armel"]="arm" ["arm64"]="arm64")

rm -rf debs
for arch in ${!supported_archs[@]}; do
     github_arch=${supported_archs[$arch]}
     package="${program}_${debversion}_${arch}"
     directory=${package}${prefix}
     binary=${directory}/${program}
     mkdir -p ${directory}
     wget -O "${binary}" "${github}${pversion}/${program}-${pversion}-${platform}-${github_arch}"
     chmod +x ${binary}
     cp -ar DEBIAN ${package}
     sed -i -e "s/Version: TEMPLATE$/Version: ${debversion}/g" ${package}/${control}
     sed -i -e "s/Architecture: TEMPLATE$/Architecture: ${arch}/g" ${package}/${control}
     dpkg-deb --build --root-owner-group ${package}
     rm -r ${package}
done
mkdir -p debs
mv *.deb debs
