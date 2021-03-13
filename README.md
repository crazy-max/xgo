[![GitHub release](https://img.shields.io/github/release/crazy-max/xgo.svg?style=flat-square)](https://github.com/crazy-max/xgo/releases/latest)
[![Total downloads](https://img.shields.io/github/downloads/crazy-max/xgo/total.svg?style=flat-square)](https://github.com/crazy-max/xgo/releases/latest)
[![Build Status](https://img.shields.io/github/workflow/status/crazy-max/xgo/build?label=build&logo=github&style=flat-square)](https://github.com/crazy-max/xgo/actions?query=workflow%3Abuild)
[![Docker Stars](https://img.shields.io/docker/stars/crazymax/xgo.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/crazymax/xgo/)
[![Docker Pulls](https://img.shields.io/docker/pulls/crazymax/xgo.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/crazymax/xgo/)
[![Go Report Card](https://goreportcard.com/badge/github.com/crazy-max/xgo)](https://goreportcard.com/report/github.com/crazy-max/xgo)

[![Become a sponsor](https://img.shields.io/badge/sponsor-crazy--max-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/crazy-max)
[![Donate Paypal](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/crazyws)

___

* [About](#about)
* [Fork](#fork)
* [Build](#Build)
* [Documentation](#documentation)
* [How can I help?](#how-can-i-help)
* [Lisence](#license)

## About

Although Go strives to be a cross platform language, cross compilation from one
platform to another is not as simple as it could be, as you need the Go sources
bootstrapped to each platform and architecture.

The first step towards cross compiling was Dave Cheney's [golang-crosscompile](https://github.com/davecheney/golang-crosscompile)
package, which automatically bootstrapped the necessary sources based on your
existing Go installation. Although this was enough for a lot of cases, certain
drawbacks became apparent where the official libraries used CGO internally: any
dependency to third party platform code is unavailable, hence those parts don't
cross compile nicely (native DNS resolution, system certificate access, etc).

A step forward in enabling cross compilation was Alan Shreve's [gonative](https://github.com/inconshreveable/gonative)
package, which instead of bootstrapping the different platforms based on the
existing Go installation, downloaded the official pre-compiled binaries from the
golang website and injected those into the local toolchain. Since the pre-built
binaries already contained the necessary platform specific code, the few missing
dependencies were resolved, and true cross compilation could commence... of pure
Go code.

However, there was still one feature missing: cross compiling Go code that used
CGO itself, which isn't trivial since you need access to OS specific headers and
libraries. This becomes very annoying when you need access only to some trivial
OS specific functionality (e.g. query the CPU load), but need to configure and
maintain separate build environments to do it.

## Fork

This repository is a fork of [karalabe/xgo](https://github.com/karalabe/xgo) to push images and tags to a single
docker repository on several registries to make things more consistent for users:

| Registry                                                                                         | Image                           |
|--------------------------------------------------------------------------------------------------|---------------------------------|
| [Docker Hub](https://hub.docker.com/r/crazymax/xgo/)                                            | `crazymax/xgo`                 |
| [GitHub Container Registry](https://github.com/users/crazy-max/packages/container/package/xgo)  | `ghcr.io/crazy-max/xgo`        |

I use [GitHub Actions](https://github.com/crazy-max/xgo/actions) to  build the images instead of using automated
builds of Docker Hub (see [workflows](.github/workflows)).

This also creates a [standalone xgo executable](https://github.com/crazy-max/xgo/releases/latest) that can be used on
many platforms.

## Build

Build xgo yourself using Docker [`buildx bake`](https://github.com/docker/buildx):

```shell
git clone https://github.com/crazy-max/xgo.git xgo
cd xgo

# Build base image and output to docker with xgo:base tag
docker buildx bake base-local

# Build go-1.16 image and output to docker with xgo:1.16 tag
BASE_IMAGE=xgo:base docker buildx bake \
  --set "*.tags=xgo:1.16" \
  --set "*.output=type=docker" \
  go-1.16

# Tests (c, cpp and gorm)
BASE_IMAGE=xgo:1.16 docker buildx bake tests

# Create xgo artifacts in ./dist
docker buildx bake artifact-all
```

## Documentation

* [Enter xgo](doc/enter-xgo.md)
* [Installation](doc/installation.md)
* [Usage](doc/usage.md)
  * [Build flags](doc/usage/build-flags.md)
  * [Go releases](doc/usage/go-releases.md)
  * [Output prefixing](doc/usage/output-prefixing.md)
  * [Branch selection](doc/usage/branch-selection.md)
  * [Remote selection](doc/usage/remote-selection.md)
  * [Package selection](doc/usage/package-selection.md)
  * [Limit build targets](doc/usage/limit-build-targets.md)
  * [Platform versions](doc/usage/platform-versions.md)
  * [CGO dependencies](doc/usage/cgo-dependencies.md)

## How can I help?

All kinds of contributions are welcome :raised_hands:! The most basic way to show your support is to star :star2:
the project, or to raise issues :speech_balloon: You can also support this project by
[**becoming a sponsor on GitHub**](https://github.com/sponsors/crazy-max) :clap: or by making
a [Paypal donation](https://www.paypal.me/crazyws) to ensure this journey continues indefinitely! :rocket:

Thanks again for your support, it is much appreciated! :pray:

## License

MIT. See `LICENSE` for more details.
