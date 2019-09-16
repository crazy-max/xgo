# Mobile libraries

Apart from the usual runnable binaries, `xgo` also supports building library
archives for Android (`android/aar`) and iOS (`ios/framework`). Opposed to
`gomobile` however `xgo` does not derive library APIs from the Go code, so
proper CGO C external methods must be defined within the package.

In the case of Android archives, all architectures will be bundled that are
supported by the requested Android platform version. For iOS frameworks `xgo`
will bundle armv7 and arm64 by default, and also the x86_64 simulator builds
if the iPhoneSimulator.sdk was injected by the user:

* Create a new docker image based on xgo: `FROM crazymax/xgo:latest`
* Inject the simulator SDK: `ADD iPhoneSimulator9.3.sdk.tar.xz /iPhoneSimulator9.3.sdk.tar.xz`
* Bootstrap the simulator SDK: `$UPDATE_IOS /iPhoneSimulator9.3.sdk.tar.xz`
