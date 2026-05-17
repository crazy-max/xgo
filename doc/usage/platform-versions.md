# Platform versions

By default `xgo` tries to cross compile to the lowest possible versions of every
supported platform, in order to produce binaries that are portable among various
versions of the same operating system. This however can lead to issues if a used
dependency is only supported by more recent systems. As such, `xgo` supports the
selection of specific platform versions by appending them to the OS target string.

* `--targets=darwin-11.3/*`: cross compile to macOS Big Sur 11.3
* `--targets=windows-6.0/*`: cross compile to Windows Vista

The supported platforms are:

* All Windows APIs up to Windows 8.1 limited by `mingw-w64` ([API level ids](https://en.wikipedia.org/wiki/Windows_NT#Releases))
* macOS APIs up to the MacOSX 26.1 SDK, with deployment targets from 10.13
