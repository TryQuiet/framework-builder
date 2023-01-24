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

ELECTRON="$( awk -F'"' '/"version": ".+"/{ print $4; exit; }' ../electron/package.json )"
echo "Building for electron@$ELECTRON"

# Build for electron, downloading node headers on-the-go
# (https://www.electronjs.org/docs/latest/tutorial/using-native-node-modules#manually-building-for-electron)
#
# HOME=~/.electron-gyp changes where to find development headers
# --target=1.2.3 is the version of Electron
# --dist-url=... specifies where to download the headers
#
HOME=~/.electron-gyp GYP_DEFINES="OS=mac" node-gyp rebuild --target=$ELECTRON --dist-url=https://electronjs.org/headers

# Copy build artifacts into the root folder
PACKAGE_NAME="$( pwd | sed 's#.*/##')"
LIBRARY_NAME="$( tr '-' '_' <<< $PACKAGE_NAME)"
DEPS_DEST=../../deps/macos/$ARCH/$PACKAGE_NAME
mkdir -p $DEPS_DEST
cp $( pwd )/build/Release/$LIBRARY_NAME.node $DEPS_DEST/$LIBRARY_NAME.node
