# Platform versions

By default `xgo` tries to cross compile to the lowest possible versions of every
supported platform, in order to produce binaries that are portable among various
versions of the same operating system. This however can lead to issues if a used
dependency is only supported by more recent systems. As such, `xgo` supports the
selection of specific platform versions by appending them to the OS target string.

 * `--targets=ios-8.1/*`: cross compile to iOS 8.1
 * `--targets=android-16/*`: cross compile to Android Jelly Bean
 * `--targets=darwin-10.9/*`: cross compile to Mac OS X Mavericks
 * `--targets=windows-6.0/*`: cross compile to Windows Vista

The supported platforms are:

 * All Android APIs up to Android Lollipop 5.0 ([API level ids](https://source.android.com/source/build-numbers.html))
 * All Windows APIs up to Windows 8.1 limited by `mingw-w64` ([API level ids](https://en.wikipedia.org/wiki/Windows_NT#Releases))
 * OSX APIs in the range of 10.6 - 10.11
 * All iOS APIs up to iOS 9.3
