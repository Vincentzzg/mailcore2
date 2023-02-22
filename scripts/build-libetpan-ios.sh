#!/bin/sh

pushd "`dirname "$0"`" > /dev/null
scriptpath="`pwd`"
popd > /dev/null

. "$scriptpath/include.sh/build-dep.sh"

#url="https://github.com/dinhviethoa/libetpan.git"
#rev=5164ba2ebd3c7cbc7a9230aad32bdf8e24e207de
url="https://github.com/Vincentzzg/libetpan.git"
rev=0e53ef824544ae232b3f63e135508e05a2b3b277

name="libetpan-ios"
xcode_target="libetpan ios"
xcode_project="libetpan.xcodeproj"
library="libetpan-ios.a"
embedded_deps="libsasl-ios"

build_git_ios
