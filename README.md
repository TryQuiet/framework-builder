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


Each build uses dedicated nodejs headers. Mobile platforms (iOS, Android) gets them from `nodedir` directory that is present in this repository, and should be manually updated along with the nodejs used on the platform.  
Desktop platforms (MacOS, Linux, Windows) downloads electron's nodejs headers on-the-go. Command that rebuilds the packages takes electron version as an argument - it's the same version as the one installed in this repo's `node_modules`.


Make sure to install <b>the same electron</b> you'll be using in the <b>project you build the libraries for!</b>


## Parameters
`build.sh` script gets three arguments: 
* desired platform  
* cpu architecture to build against  
* comma-separated package names to iterate over and to run proper scripts for each


## Build for MacOS
> NOTE: You must use machine running MacOS to build for MacOS.

Do `npm run start-macos` in the root directory of the project.  
By default, the packages (`leveldown` and `classic-level`) will build against `x86_64` and `arm64` architectures.

Resulting binary is universal, which means it covers both `x86_64` and `arm64`. Please do not change the default `universal` arch value in the script command.


## Build for iOS
> NOTE: You must use machine running MacOS to build for iOS.
> NOTE: Currently, the only supported architecture for iOS is arm64

Do `npm run start-ios` in the root directory of the project.  
By default, the packages (`leveldown` and `classic-level`) will build against `arm64` architecture.

As an artifacts the iOS's frameworks are generated. They can be embedded into the app bundle through xcode.  
Additionaly, path mapping file for overriding dlopen can be found (`deps/override-dlopen-paths-data.json`).


## Build for Android
> NOTE: You must use machine running Linux to build for Android.
> NOTE: Currently, the only supported architecture for Android is arm64

The only <b>prerequisite</b> is to have Android NDK installed locally (https://developer.android.com/ndk/downloads) (version 21.4 is confirmed to be working).


Don't forget to export `NDK_PATH` pointing to the installation directory (e.g. `/home/user/Android/ndk/21.4.707552`) inside the terminal you use (bash is default).  


Do `npm run start-android` in the root directory of the project.  
By default, the packages (`leveldown` and `classic-level`) will build against `arm64` architecture.


## Build for Linux
> NOTE: You must use machine running Linux to build for Linux.
> NOTE: Currently, the only supported architecture for Linux is x86-64

Do `npm run start-linux` in the root directory of the project.  
By default, the packages (`leveldown` and `classic-level`) will build against `x86-64` architecture.


## Build for Windows
Unfortunatelly building for Windows is not automated in this tool.  
However, it is confirmed that prebuilds shipped with `leveldown` and `classic-level` works with electron.


If one wants to rebuild the package anyway, the following command works when executed from within the Windows powered machine (with the development environment set up – see https://visualstudio.microsoft.com/)
```
set HOME=~/.electron-gyp GYP_DEFINES=\"include_os=win32 OS=linux\" && cd $PACKAGE && node-gyp rebuild --target=$ELECTRON --dist-url=https://electronjs.org/headers
```


## Testing
Built binaries can easily be tested against working with electron. Build libraries for one of desired desktop platforms, and run `test` command from within `test` subproject.


As a result you should see error-free command line output and a `dummy` database files present under the subproject's directory.  
(In the test, a `leveldown` binary is being put under pressure).


<br/>
<br/>
