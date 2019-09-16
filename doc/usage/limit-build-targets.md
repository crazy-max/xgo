# Limit build targets

By default `xgo` will try and build the specified package to all platforms and
architectures supported by the underlying Go runtime. If you wish to restrict
the build to only a few target systems, use the comma separated `--targets` CLI
argument:

  * `--targets=linux/arm`: builds only the ARMv5 Linux binaries (`arm-6`/`arm-7` allowed)
  * `--targets=windows/*,darwin/*`: builds all Windows and OSX binaries
  * `--targets=*/arm`: builds ARM binaries for all platforms
  * `--targets=*/*`: builds all suppoted targets (default)

The supported targets are:

 * Platforms: `android`, `darwin`, `ios`, `linux`, `windows`
 * Achitectures: `386`, `amd64`, `arm-5`, `arm-6`, `arm-7`, `arm64`, `mips`, `mipsle`, `mips64`, `mips64le`
