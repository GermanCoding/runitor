#!/bin/bash
set -e
program="runitor"
version="1.0.0"
patch=1
github="https://github.com/bdd/runitor/releases/download/"
prefix="/usr/bin"
pversion="v$version"
platform="linux"
control="DEBIAN/control"
supported_archs=("amd64"  "arm"  "arm64")

for arch in ${supported_archs[*]}; do
     package="${program}_${version}-${patch}_${arch}"
     wget -P ${package}${prefix}/${program} ${github}${pversion}/${program}-${pversion}-${platform}-${arch}
     cp -ar DEBIAN ${package}
     sed -i -e "s/Version: TEMPLATE$/Version: $version/g" ${package}/${control}
     sed -i -e "s/Architecture: TEMPLATE$/Architecture: $arch/g" ${package}/${control}
     dpkg-deb --build --root-owner-group ${package}
     rm -r ${package}
done
mkdir -p debs
mv *.deb debs
