NODEJS_HEADERS_DIR="$( cd ../../ && cd nodedir/android/libnode/ && pwd )"

ARCH=$1

# Build for arm64 by default
if [ -z $ARCH ]
then
  ARCH="arm64"
fi

# Choose proper target basing on architecture we build against
if [ $ARCH == "arm64" ]
then
  TARGET="aarch64-linux-android"
fi

# Minimum sdk set in app/build.gradle
SDK="26"

TOOLCHAIN_PATH="$NDK_PATH/toolchains/llvm/prebuilt/linux-x86_64"

TARGET_SDK="$TOOLCHAIN_PATH/bin/$TARGET$SDK"

AR="$TOOLCHAIN_PATH/bin/$TARGET-ar"
LINK="$TARGET_SDK-clang++"

# npm rebuild
TOOLCHAIN="$TOOLCHAIN_PATH" \
AR="$AR" \
LINK="$LINK" \
CC="$TARGET_SDK-clang" \
CXX="$TARGET_SDK-clang++" \
GYP_DEFINES="target_arch=$ARCH android_target_arch=$ARCH v8_target_arch=$ARCH host_os=linux OS=android" \
CARGO_BUILD_TARGET="$TARGET" \
CARGO_TARGET_ARM_LINUX_ANDROIDEABI_AR="$AR" \
CARGO_TARGET_ARM_LINUX_ANDROIDEABI_LINKER="$LINK" \
npm_config_nodedir="$NODEJS_HEADERS_DIR" \
npm_config_platform="android" \
npm_config_format="make-android" \
npm_config_node_engine="v8" \
npm_config_arch="$ARCH" \
npm --verbose rebuild --build-from-source

# Copy build artifacts into the root folder
PACKAGE_NAME="$( pwd | sed 's#.*/##')"
LIBRARY_NAME="$( tr '-' '_' <<< $PACKAGE_NAME)"
DEPS_DEST=../../deps/android/$ARCH/$PACKAGE_NAME
mkdir -p $DEPS_DEST
cp $( pwd )/build/Release/$LIBRARY_NAME.node $DEPS_DEST/$LIBRARY_NAME.node
