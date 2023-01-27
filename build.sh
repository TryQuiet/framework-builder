PROJECT_DIR="$( pwd )"

OS=$1
ARCH=$2

# Delete previous artifacts
rm -rf deps/$OS
mkdir deps/$OS

# Prepare proper addon.gypi for node-gyp-build
if [ $OS == "ios" ] || [ $OS == "android" ]
then
  rm -rf node_modules/node-gyp
  cp -rf node_modules/nodejs-mobile-gyp node_modules/node-gyp
else
  rm -rf node_modules/node-gyp
  npm i
fi

# Build binaries
for package in ${3//,/ }; do
 echo "Building $OS $ARCH shared library for $package"
 rm -rf $PROJECT_DIR/node_modules/$package/build
 cd $PROJECT_DIR/node_modules/$package && $PROJECT_DIR/build-binaries/$OS.sh $ARCH
done

# Generate ios .frameworks
if [ $OS == 'ios' ]
then
    node $PROJECT_DIR/ios-frameworks/ios-create-plists-and-dlopen-override.js $PROJECT_DIR/node_modules $ARCH
fi
