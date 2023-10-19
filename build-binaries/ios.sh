NODEJS_HEADERS_DIR="$( cd ../../ && cd nodedir/ios/libnode/ && pwd )"

ARCH=$1
PLATFORM=$2

# Build for arm64 by default
if [ -z $ARCH ]
then
  ARCH="arm64"
fi

# Choose proper target basing on architecture we build against
if [ $PLATFORM == "iphoneos" ]
then
  DEFINES="OS=ios target_arch=arm64 iossim=false"
  TARGET="aarch64-apple-ios"
elif [ $ARCH == "arm64" ]
then
  DEFINES="OS=ios target_arch=arm64 iossim=true"
  TARGET="aarch64-apple-ios-sim"
elif [ $ARCH == "x64" ]
then
  DEFINES="OS=ios target_arch=x64 iossim=true"
  TARGET="x86_64-apple-ios"
else
  echo "ERR: Provided architecture $ARCH is not supported."
  exit 1
fi

GYP_DEFINES="$DEFINES" \ 
CARGO_BUILD_TARGET="$TARGET" \
npm_config_nodedir="$NODEJS_HEADERS_DIR" \
npm_config_platform="ios" \
npm_config_format="make-ios" \
npm_config_node_engine="chakracore" \
npm_config_arch="$ARCH" \
npm --verbose rebuild --build-from-source
