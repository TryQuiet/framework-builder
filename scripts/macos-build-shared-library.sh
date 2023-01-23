ARCH=$1

# Build for arm64 by default
if [ -z $ARCH ]
then
  ARCH="universal"
fi

# Choose proper target basing on architecture we build against
if [ $ARCH != "universal" ]
then
  echo "ERR: Provided architecture $ARCH is not supported."
  exit 1
fi

GYP_DEFINES="OS=mac" \
npm_config_platform="mac" \
npm --verbose rebuild --build-from-source

# Copy build artifacts into the root folder
PACKAGE_NAME="$( pwd | sed 's#.*/##')"
LIBRARY_NAME="$( tr '-' '_' <<< $PACKAGE_NAME)"
DEPS_DEST=../../deps/macos/$ARCH/$PACKAGE_NAME
mkdir -p $DEPS_DEST
cp $( pwd )/build/Release/$LIBRARY_NAME.node $DEPS_DEST/$LIBRARY_NAME.node
