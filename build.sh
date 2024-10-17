PROJECT_DIR="$( pwd )"

OS=$1
ARCHS=$2
PACKAGES=$3

#print packages
echo "Building packages: $PACKAGES"
echo "OS: $OS"
echo "Arch: $ARCHS"

# Delete previous artifacts
rm -rf deps/$OS
mkdir deps/$OS

# Prepare proper addon.gypi for node-gyp-build
rm -rf node_modules/node-gyp

if [ $OS == "android" ]
then
  cp -rf node_modules/nodejs-mobile-gyp node_modules/node-gyp
elif [ $OS == "ios" ]
then
  rm -rf $PROJECT_DIR/node_modules/
  npm i
  npm run apply-mobile-addon-gypi
else
  rm -rf $PROJECT_DIR/node_modules/
  npm i
fi

if [ $OS == "ios" ]
then
  ARCHS=("arm64")
  PACKAGES=("$PACKAGES")
  BUILD_IOS=true
  touch deps/$OS/override-dlopen-paths-data.json
else
  ARCHS=("$ARCHS")
  PACKAGES=("$PACKAGES")
  BUILD_IOS=false
fi

for package in ${PACKAGES//,/ }; do
  for arch in ${ARCHS[@]}; do

    # Build package
    echo "Removing existing package build dir"
    rm -rf $PROJECT_DIR/node_modules/$package/build
    echo "Building $OS $arch shared library for $package"
    cd $PROJECT_DIR/node_modules/$package && $PROJECT_DIR/build-binaries/$OS.sh $arch

    # Generate .framework for iOS
    if [ $BUILD_IOS == true ]
    then      
      node $PROJECT_DIR/ios-frameworks/ios-create-plists-and-dlopen-override.js $PROJECT_DIR/node_modules/$package $arch
    fi
  done
done

# # (iOS) Merge universal binary for simulator
# if [ $BUILD_IOS == true ]
# then
#   for package in ${PACKAGES//,/ }; do
#     DEST=$PROJECT_DIR/deps/$OS/ios-arm64_x86_64-simulator/$package/$package.framework/

#     for arch in ${ARCHS[@]}; do
#       mkdir -p $DEST
#       cp -rn $PROJECT_DIR/deps/$OS/$arch/$package/$package.framework/$package $DEST/$package-$arch
#     done

#     cd $DEST && lipo -create -output $package $package-${ARCHS[0]} $package-${ARCHS[1]}
    
#     # Cleanup
#     for arch in ${ARCHS[@]}; do
#       rm -rf $PROJECT_DIR/deps/$OS/$arch
#       rm -rf $DEST/$package-$arch
#     done

#   done
# fi

# # (iOS) Build .framework for device
# if [ $BUILD_IOS == true ]
# then
#   for package in ${PACKAGES//,/ }; do
#     echo "Building iOS device shared library for $package"
#     rm -rf $PROJECT_DIR/node_modules/$package/build
#     cd $PROJECT_DIR/node_modules/$package && $PROJECT_DIR/build-binaries/ios.sh arm64 iphoneos
#   done

#   node $PROJECT_DIR/ios-frameworks/ios-create-plists-and-dlopen-override.js $PROJECT_DIR/node_modules/$package ios-arm64
# fi
