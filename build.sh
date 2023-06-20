PROJECT_DIR="$( pwd )"

OS=$1
VARIANT=$2

# Handle building universal binary for iOS
if [ $OS == "ios" ] && [ $VARIANT == "universal" ]
then
  ARCHS=("x64" "arm64")
else
  ARCHS=($VARIANT)
fi

# Delete previous artifacts
rm -rf deps/$OS
mkdir deps/$OS

# Prepare proper addon.gypi for node-gyp-build
if [ $OS == "android" ]
then
  rm -rf node_modules/node-gyp
  cp -rf node_modules/nodejs-mobile-gyp node_modules/node-gyp
elif [ $OS == "ios" ]
then
  rm -rf node_modules/node-gyp
  npm i
  npm run apply-mobile-addon-gypi
else
  rm -rf node_modules/node-gyp
  npm i
fi

for ARCH in ${ARCHS[@]}; do

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
done

# (Optionally) merge universal binary for iOS
if [ $OS == "ios" ] && [ $VARIANT == "universal" ]
then
  for package in ${3//,/ }; do
    DEST=$PROJECT_DIR/deps/$OS/universal/$package/$package.framework/

    for arch in ${ARCHS[@]}; do
      mkdir -p $DEST
      cp -rn $PROJECT_DIR/deps/$OS/$arch/$package/$package.framework/$package $DEST/$package-$arch
    done

    cd $DEST && lipo -create -output $package $package-${ARCHS[0]} $package-${ARCHS[1]}
    
    # Cleanup
    for arch in ${ARCHS[@]}; do
      rm -rf $PROJECT_DIR/deps/$OS/$arch
      rm -rf $DEST/$package-$arch
    done

  done
fi
