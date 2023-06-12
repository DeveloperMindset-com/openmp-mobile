#!/bin/bash
# this is part of https://github.com/eugenehp/openmp-mobile
# MIT License
# Author: Eugene Hauptmann eugene@reactivelions.com

set -e

NAME="openmp"
VERSION="16.0.5"
DIST="dist"
BUILD="build"
BUILD_SHARED_LIBS=OFF
CMAKE_BUILD_TYPE=Release
CPU_CORES=$(sysctl -n hw.ncpu)
CMAKE_TOOLCHAIN_FILE="$PWD/ios.toolchain.cmake"
ENABLE_ARC=0
ENABLE_BITCODE=0
ENABLE_VISIBILITY=1
# TARGETS=("13.1")
# ARCHS=("Catalyst;arm64")
# PLATFORMS=("MAC_CATALYST_ARM64")

TARGETS=("13.0" "13.0" "13.0" "6.0" "6.0" "13.0" "13.0" "13.0")
ARCHS=("arm64;arm64e" "arm64;arm64e;x86_64" "arm64;arm64e;x86_64" "armv7k;arm64_32" "i386" "arm64" "x86_64")
PLATFORMS=("OS64" "SIMULATOR64" "MAC_UNIVERSAL" "WATCHOS" "SIMULATOR_WATCHOS" "TVOS" "SIMULATOR_TVOS")

ROOT=$PWD

function print()
{
    echo "=============================="
    echo $1
    echo "=============================="
}

function replace()
{
  NUMBER=$1
  LINE=$2
  PATH=$3
  
  /usr/bin/perl -n -i -e "print unless $. == $NUMBER" $PATH
  /usr/bin/perl -pi -e "print \"\n\" if $. == $NUMBER" $PATH
  /usr/bin/perl -pi -e "print '$LINE' if $. == $NUMBER" $PATH
}

function clear()
{
    rm -rf "$ROOT/$NAME"
    rm -rf "$ROOT/$BUILD"
    rm -rf "$ROOT/$DIST"
}

function download()
{
    print "Downloading OpenMP source code"
    FILENAME="$NAME-$VERSION.src.tar.xz"
    wget "https://github.com/llvm/llvm-project/releases/download/llvmorg-$VERSION/$FILENAME"
    mkdir $NAME
    tar xf $FILENAME --strip-components=1 -C $NAME
    rm $FILENAME

    # inspired by
    # https://stackoverflow.com/questions/150355/programmatically-find-the-number-of-cores-on-a-machine
    # https://stackoverflow.com/questions/7241936/how-do-i-detect-a-dual-core-cpu-on-ios
    print "Patching z_Linux_util with support for watchOS"
    patch "$ROOT/$NAME/runtime/src/z_Linux_util.cpp" -i ./z_Linux_util.patch

    print "Downloading ExtendPath.cmake from LLVM"
    # download missing ExtendPath from LLVM, that OpenMP CMake configuration refers to 
    cd $NAME
    cd cmake
    wget https://raw.githubusercontent.com/llvm/llvm-project/main/cmake/Modules/ExtendPath.cmake
    cd $ROOT

    print "Downloading ios.toolchain.cmake"
    rm -rf ios.toolchain.cmake
    wget https://raw.githubusercontent.com/leetal/ios-cmake/master/ios.toolchain.cmake

    # from https://www.apple.com/certificateauthority/
    # print "Updating AppleWWDRCA certificate G7"
    # cd "/Users/$(whoami)/Library/MobileDevice/Provisioning Profiles/"
    # wget -q http://developer.apple.com/certificationauthority/AppleWWDRCA.cer -O AppleWWDRCA.cer
    # wget https://www.apple.com/certificateauthority/AppleWWDRCAG7.cer
}

function configure()
{
    ARCH=$1
    PLATFORM=$2
    TARGET=$3
    BUILD_DIR="$ROOT/$BUILD/$NAME/$PLATFORM"
    OUTPUT="$ROOT/$BUILD/$NAME/install/$PLATFORM"

    EXTRA_FLAGS=""

    echo "Configuring $NAME for $ARCH in $OUTPUT"

    rm -rf $BUILD_DIR
    mkdir -p $BUILD_DIR

    cmake $NAME\
        -G Xcode\
        -B $BUILD_DIR\
        -DBUILD_SHARED_LIBS=$BUILD_SHARED_LIBS\
        -DCMAKE_TOOLCHAIN_FILE=$CMAKE_TOOLCHAIN_FILE\
        -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE\
        -DCMAKE_INSTALL_PREFIX=$OUTPUT\
        -DPLATFORM=$PLATFORM\
        -DENABLE_BITCODE=$ENABLE_BITCODE\
        -DENABLE_ARC=$ENABLE_ARC\
        -DENABLE_VISIBILITY=$ENABLE_VISIBILITY\
        -DDEPLOYMENT_TARGET=$TARGET\
        -DARCHS=$ARCH\
        -DLIBOMP_ENABLE_SHARED=OFF\
        -DLIBOMP_OMPT_SUPPORT=OFF\
        -DLIBOMP_USE_HWLOC=OFF\
        -DLIBOMP_FORTRAN_MODULES=OFF\
        -DLIBOMP_OMPT_OPTIONAL=ON\
        -DOPENMP_STANDALONE_BUILD=1\
        $EXTRA_FLAGS
}

function build()
{
    ARCH=$1
    PLATFORM=$2
    BUILD_DIR="$ROOT/$BUILD/$NAME/$PLATFORM"
    OUTPUT="$ROOT/$BUILD/$NAME/install/$PLATFORM"

    cmake --build $BUILD_DIR -j $CPU_CORES
    # cmake --build $BUILD_DIR -j $CPU_CORES -- CODE_SIGNING_ALLOWED=NO -UseModernBuildSystem=NO
    # cmake --build $BUILD_DIR -- CODE_SIGNING_ALLOWED=NO -UseModernBuildSystem=NO
}

function install()
{
    ARCH=$1
    PLATFORM=$2
    BUILD_DIR="$ROOT/$BUILD/$NAME/$PLATFORM"
    OUTPUT="$ROOT/$BUILD/$NAME/install/$PLATFORM"

    rm -rf "$OUTPUT"
    mkdir -p $OUTPUT

    cmake --build $BUILD_DIR --target install
}

function framework()
{
    echo "Preparing framework for $NAME"

    FRAMEWORK_OUTPUT="$ROOT/$DIST/$NAME.xcframework"
    rm -rf $FRAMEWORK_OUTPUT
    mkdir -p $FRAMEWORK_OUTPUT

    command="xcodebuild -create-xcframework"
    for PLATFORM in ${PLATFORMS[@]}; do
        OUTPUT="$ROOT/$BUILD/$NAME/install/$PLATFORM"
        command+=" -library $OUTPUT/lib/libomp.a -headers $OUTPUT/include"
    done

    command+=" -output $FRAMEWORK_OUTPUT"

    $command

    ditto -c -k --sequesterRsrc --keepParent "$FRAMEWORK_OUTPUT" "$FRAMEWORK_OUTPUT.zip"
    # openssl dgst -sha256 "$XCFRAMEWORK_FOLDER.zip"
    
    CHECKSUM=$(swift package compute-checksum "$FRAMEWORK_OUTPUT.zip")
    echo $CHECKSUM > "$FRAMEWORK_OUTPUT.sha256"
    echo "$CHECKSUM"
    update $CHECKSUM
}

function update()
{
    print "Updating the versions in SPM, Cocoapods"
    CHECKSUM=$1

    # SPM via Package.swift 
    replace 4 "let version = \"$VERSION\"" "./Package.swift"
    replace 5 "let checksum = \"$CHECKSUM\"" "./Package.swift"
    
    # Cocoapods via OpenMP.podspec
    replace 2 "  version              = \"$VERSION\"" "./OpenMP.podspec"

    # TODO
    # add Carthage support
}

function start()
{
    # clear
    # download
    
    # for index in ${!ARCHS[@]}; do
    #     ARCH=${ARCHS[$index]}
    #     PLATFORM=${PLATFORMS[$index]}
    #     TARGET=${TARGETS[$index]}
        
    #     print "Configuring $NAME for $ARCH on $PLATFORM:$TARGET"
    #     configure $ARCH $PLATFORM $TARGET
        
    #     print "Building $NAME for $ARCH on $PLATFORM:$TARGET"
    #     build $ARCH $PLATFORM

    #     print "Installing $NAME for $ARCH on $PLATFORM:$TARGET"
    #     install $ARCH $PLATFORM
    # done

    framework
}

start