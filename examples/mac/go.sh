#!/bin/sh

NAME="main"
BINARY="$NAME.app"
SOURCE="$NAME.cpp"

LDFLAGS="-L$PWD/../../dist/openmp.xcframework/macos-arm64_arm64e_x86_64"
CPPFLAGS="-I$PWD/../../dist/openmp.xcframework/macos-arm64_arm64e_x86_64/Headers"
g++ -Xpreprocessor -fopenmp -mmacosx-version-min=13.3 -lomp -o $BINARY "src/$SOURCE" $LDFLAGS $CPPFLAGS

command="./$BINARY"

$command