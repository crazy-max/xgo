[![GitHub release](https://img.shields.io/github/release/crazy-max/xgo.svg?style=flat-square)](https://github.com/crazy-max/xgo/releases/latest)
[![Total downloads](https://img.shields.io/github/downloads/crazy-max/xgo/total.svg?style=flat-square)](https://github.com/crazy-max/xgo/releases/latest)
[![Build Status](https://img.shields.io/github/workflow/status/crazy-max/xgo/build?label=build&logo=github&style=flat-square)](https://github.com/crazy-max/xgo/actions?query=workflow%3Abuild)
[![Test Status](https://img.shields.io/github/workflow/status/crazy-max/xgo/test?label=test&logo=github&style=flat-square)](https://github.com/crazy-max/xgo/actions?query=workflow%3Atest)
[![Docker Stars](https://img.shields.io/docker/stars/crazymax/xgo.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/crazymax/xgo/)
[![Docker Pulls](https://img.shields.io/docker/pulls/crazymax/xgo.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/crazymax/xgo/)
[![Go Report Card](https://goreportcard.com/badge/github.com/crazy-max/xgo)](https://goreportcard.com/report/github.com/crazy-max/xgo)

[![Become a sponsor](https://img.shields.io/badge/sponsor-crazy--max-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/crazy-max)
[![Donate Paypal](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/crazyws)

___

* [Fork](#fork)
* [Build](#Build)
* [Documentation](#documentation)
* [Contributing](#contributing)
* [Lisence](#license)

## Fork

This repository is a fork of [karalabe/xgo](https://github.com/karalabe/xgo) to
push images and tags to a single docker repository on several registries to make
things more consistent for users. It uses [`goxx` image](https://github.com/crazy-max/goxx)
as base that provides all the necessary Go tool-chains, C/C++ cross-compilers
and platform headers/libraries.

| Registry                                                                                         | Image                           |
|--------------------------------------------------------------------------------------------------|---------------------------------|
| [Docker Hub](https://hub.docker.com/r/crazymax/xgo/)                                            | `crazymax/xgo`                 |
| [GitHub Container Registry](https://github.com/users/crazy-max/packages/container/package/xgo)  | `ghcr.io/crazy-max/xgo`        |

```
$ docker run --rm mplatform/mquery crazymax/xgo:latest
Image: crazymax/xgo:latest
 * Manifest List: Yes
 * Supported platforms:
   - linux/amd64
   - linux/arm64
```

This also creates a [standalone xgo executable](https://github.com/crazy-max/xgo/releases/latest)
that can be used on many platforms.

## Build

Build xgo yourself using Docker [`buildx bake`](https://github.com/docker/buildx/blob/master/docs/reference/buildx_bake.md):

```shell
git clone https://github.com/crazy-max/xgo.git xgo
cd xgo

# Build xgo image and output to docker with xgo:local tag
docker buildx bake

# Tests
BASE_IMAGE=xgo:local docker buildx bake test-c
BASE_IMAGE=xgo:local docker buildx bake test-cpp
BASE_IMAGE=xgo:local docker buildx bake test-gorm

# Create xgo artifacts in ./dist
docker buildx bake artifact-all
```

## Documentation

* [About](doc/about.md)
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

## Contributing

Want to contribute? Awesome! The most basic way to show your support is to star
the project, or to raise issues. You can also support this project by
[**becoming a sponsor on GitHub**](https://github.com/sponsors/crazy-max) or by
making a [Paypal donation](https://www.paypal.me/crazyws) to ensure this journey
continues indefinitely!

Thanks again for your support, it is much appreciated! :pray:

## License

MIT. See `LICENSE` for more details.
