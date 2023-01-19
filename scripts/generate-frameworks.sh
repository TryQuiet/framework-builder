PROJECT_DIR="$( pwd )"
echo $PROJECT_DIR

# Delete previous artifacts
rm -rf outputs/*

# Build binaries
for package in ${1//,/ }; do
 echo "Building shared library for $package"
 rm -rf $PROJECT_DIR/node_modules/$package/build
 cd $PROJECT_DIR/node_modules/$package && ../../scripts/ios-build-shared-library.sh
done

# Generate .frameworks
node $PROJECT_DIR/scripts/ios-create-plists-and-dlopen-override.js $PROJECT_DIR
