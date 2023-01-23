ARCH=$1

# Build for arm64 by default
if [ -z $ARCH ]
then
  ARCH="x86-64"
fi

# Verify proper architecture was provided
if [ $ARCH != "x86-64" ]
then
  echo "ERR: Provided architecture $ARCH is not supported."
  exit 1
fi

# rebuild
HOME=~/.electron-gyp GYP_DEFINES="OS=linux" node-gyp rebuild --target=19.0.5 --arch=$ARCH --dist-url=https://electronjs.org/headers

# Copy build artifacts into the root folder
PACKAGE_NAME="$( pwd | sed 's#.*/##')"
LIBRARY_NAME="$( tr '-' '_' <<< $PACKAGE_NAME)"
DEPS_DEST=../../deps/linux/$ARCH/$PACKAGE_NAME
mkdir -p $DEPS_DEST
cp $( pwd )/build/Release/$LIBRARY_NAME.node $DEPS_DEST/$LIBRARY_NAME.node
