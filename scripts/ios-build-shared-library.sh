NODEJS_HEADERS_DIR="$( cd ../../ && cd nodedir/ios/libnode/ && pwd )"

ARCH=$1

# Build for arm64 by default
if [ -z $ARCH ]
then
  ARCH="arm64"
fi

# Choose proper target basing on architecture we build against
if [ $ARCH == "arm64" ]
then
  TARGET="aarch64-apple-ios"
fi

GYP_DEFINES="OS=ios" \
CARGO_BUILD_TARGET="$TARGET" \
npm_config_nodedir="$NODEJS_HEADERS_DIR" \
npm_config_platform="ios" \
npm_config_format="make-ios" \
npm_config_node_engine="chakracore" \
npm_config_arch="$ARCH" \
npm --verbose rebuild --build-from-source

# Copy build artifacts into the root folder
PACKAGE_NAME="$( pwd | sed 's#.*/##')"
LIBRARY_NAME="$( tr '-' '_' <<< $PACKAGE_NAME)"
DEPS_DEST=../../deps/ios/$ARCH/$PACKAGE_NAME
mkdir -p $DEPS_DEST
cp $( pwd )/build/Release/$LIBRARY_NAME.node $DEPS_DEST/$LIBRARY_NAME.node
