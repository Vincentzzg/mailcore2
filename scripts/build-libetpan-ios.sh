#!/bin/sh

pushd "`dirname "$0"`" 
scriptpath="`pwd`"
echo "scriptpath = "$scriptpath
popd > /dev/null

. "$scriptpath/include.sh/build-dep.sh"

#url="https://github.com/dinhviethoa/libetpan.git"
#rev=5164ba2ebd3c7cbc7a9230aad32bdf8e24e207de
url="https://github.com/Vincentzzg/libetpan.git"
#rev=8de80ee1960ae633bad0856a76614870890c01aa

name="libetpan-ios"
xcode_target="libetpan ios"
xcode_project="libetpan.xcodeproj"
library="libetpan-ios.a"
embedded_deps="libsasl-ios"

build_git_ios
