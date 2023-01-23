<p align="center">
  <h1 align="center"><b>Framework Builder</b></h1>
  <p align="center">
    A tool for preparing binaries for iOS shipment
    <br />
    <br />
    <br />
   </p>
</p>

## How it works
`node-gyp` is being used to build shared libraries against defined architecture for desired packages.  
The artifacts are being copied into `deps/{platform}/{architecture}/{package}` directory.

## Define packages to build
generate-frameworks script gets three arguments: desired platform; cpu architecture to build against; comma-separated package names to iterate over and to run proper scripts for each.

## Build for iOS
> NOTE: Currently, the only supported architecture for iOS is arm64

Do `npm run start-ios` in the root directory of the project.  
By default, the packages (`leveldown` and `classic-level`) will build against `arm64` architecture.

As an artifacts the iOS's frameworks are generated. They can be embedded into the app bundle through xcode.  
Additionaly, path mapping file for overriding dlopen can be found (`deps/override-dlopen-paths-data.json`).

## Build for Android
> NOTE: Currently, the only supported architecture for Android is arm64

The only <b>prerequisite</b> is to have Android NDK installed locally (https://developer.android.com/ndk/downloads) (version 21.4 is confirmed to be working).


Don't forget to export `NDK_PATH` pointing to the installation directory (e.g. `/home/user/Android/ndk/21.4.707552`) inside the terminal you use (bash is default).  


Do `npm run start-android` in the root directory of the project.  
By default, the packages (`leveldown` and `classic-level`) will build against `arm64` architecture.

## Build for Linux
> NOTE: Currently, the only supported architecture for Linux is x86-64

Do `npm run start-linux` in the root directory of the project.  
By default, the packages (`leveldown` and `classic-level`) will build against `x86-64` architecture.

<br/>
<br/>
