<p align="center">
  <h1 align="center"><b>Framework Builder</b></h1>
  <p align="center">
    A tool for preparing binaries for iOS shipment
    <br />
    <br />
    <br />
   </p>
</p>

## Usage
Do `npm run start` in the root directory of the project.

## How it works
`node-gyp` is being used to build shared libraries against defined architecture for desired packages. Then it builds iOS's frameworks that can be embedded into app bundle through xcode.
The artifacts are being copied into `outputs/` directory, along with path mapping file for overriding dlopen (`override-dlopen-paths-data.json`).

## Define packages to build
generate-frameworks scripts gets comma-separated package names as an argument. It iterates over them and runs proper scripts for each package.

<br/>
<br/>
