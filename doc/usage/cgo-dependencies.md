### CGO dependencies

The main differentiator of xgo versus other cross compilers is support for basic
embedded C/C++ code and target-platform specific OS SDK availability. The current
xgo release introduces an experimental CGO *dependency* cross compilation, enabling
building Go programs that require external C/C++ libraries.

It is assumed that the dependent C/C++ library is `configure/make` based, was
properly prepared for cross compilation and is available as a tarball download
(`.tar`, `.tar.gz` or `.tar.bz2`). Further plans include extending this to cmake
based projects, if need arises (please open an issue if it's important to you).

Such dependencies can be added via the `--deps` argument. They will be retrieved
prior to starting the cross compilation and the packages cached to save bandwidth
on subsequent calls.

A complex sample for such a scenario is building the Ethereum CLI node, which has
the GNU Multiple Precision Arithmetic Library as it's dependency.

    $ xgo --deps=https://gmplib.org/download/gmp/gmp-6.1.0.tar.bz2  \
        --targets=windows/* github.com/ethereum/go-ethereum/cmd/geth
    ...

    $ ls -al
    -rwxr-xr-x 1 root root 16315679 Nov 24 16:39 geth-windows-4.0-386.exe
    -rwxr-xr-x 1 root root 19452036 Nov 24 16:38 geth-windows-4.0-amd64.exe

Some trivial arguments may be passed to the dependencies' configure script via
`--depsargs`.

    $ xgo --deps=https://gmplib.org/download/gmp/gmp-6.1.0.tar.bz2  \
        --targets=ios/* --depsargs=--disable-assembly               \
        github.com/ethereum/go-ethereum/cmd/geth
    ...

    $ ls -al
    -rwxr-xr-x 1 root root 14804160 Nov 24 16:32 geth-ios-5.0-arm

Note, that since xgo needs to cross compile the dependencies for each platform
and architecture separately, build time can increase significantly.
