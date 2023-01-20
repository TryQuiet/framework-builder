PROJECT_DIR="$( pwd )"

OS=$1
ARCH=$2

# Delete previous artifacts
rm -rf deps/$OS
mkdir deps/$OS

# Build binaries
for package in ${3//,/ }; do
 echo "Building $OS $ARCH shared library for $package"
 rm -rf $PROJECT_DIR/node_modules/$package/build
 cd $PROJECT_DIR/node_modules/$package && ../../scripts/$OS-build-shared-library.sh $ARCH
done

# Generate ios .frameworks
if [ $OS == 'ios' ]
then
    node $PROJECT_DIR/scripts/ios-create-plists-and-dlopen-override.js $PROJECT_DIR/node_modules $ARCH
fi
