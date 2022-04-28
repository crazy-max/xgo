# Changelog

## 0.14.1 (2022/04/28)

* fix: add git config safe dir (#62 #63)

## 0.14.0 (2022/04/20)

* Go 1.18.1, 1.17.9 (#59)

## 0.13.0 (2022/03/29)

* Go 1.18.0 (#57)

## 0.12.0 (2022/03/26)

* Go 1.17.8, 1.16.15 (#56)

## 0.11.0 (2022/01/07)

* Go 1.17.7, 1.16.14 (#54)

## 0.10.0 (2022/01/07)

* Go 1.17.6, 1.16.13 (#51)

## 0.9.0 (2022/01/02)

* Multi-platform image support with [`goxx`](https://github.com/crazy-max/goxx) (#46)

## 0.8.0 (2021/12/28)

* Switch to Ubuntu base image (#44)
* Debug build cmd (#43)
* Enhance dockerfiles (#42)

## 0.7.6 (2021/12/11)

* Go 1.17.5, 1.17.4, 1.16.12, 1.16.11

## 0.7.5 (2021/11/11)

* Go 1.17.3, 1.16.10

## 0.7.4 (2021/10/14)

* Go 1.17.2, 1.16.9

## 0.7.3 (2021/09/10)

* Go 1.17.1, 1.16.8

## 0.7.2 (2021/09/05)

* Fix go modules detection (#40)

## 0.7.1 (2021/08/29)

* Fix missing Docker tags

## 0.7.0 (2021/08/23)

* Go 1.17 (#38)
  * Drop 1.15 support
  * Add `linux/riscv64` support
  * xgo built against Go 1.17
  * Debian Bullseye
  * Update gorm example

## 0.6.9 (2021/08/22)

* Go 1.16.7, 1.15.15

## 0.6.8 (2021/07/14)

* Go 1.16.6, 1.15.14

## 0.6.7 (2021/06/05)

* Fix artifacts (#35)

## 0.6.6 (2021/06/04)

* Go 1.16.5, 1.16.4, 1.15.13, 1.15.12

## 0.6.5 (2021/04/11)

* Go 1.16.3, 1.15.11

## 0.6.4 (2021/03/16)

* Skip go modules while fetching repo
* More tests

## 0.6.3 (2021/03/15)

* Enhance logging

## 0.6.2 (2021/03/13)

* Go 1.16.2, 1.15.10
* Fix semver comparison

## 0.6.1 (2021/03/13)

* Fix `images.go` job

## 0.6.0 (2021/03/13)

* Add support for `darwin/arm64` (Apple M1 Chip)
* MacOSX SDK 11.1
* Debian Buster (#22)
* Switch to `goreleaser-xx` for artifacts
* Container dev workflow
* Switch to buildx bake
* Merged and enhanced Dockerfiles
* Merge base and go workflows
* Build xgo from working tree
* Disable go modules if `go.mod` does not exist
* Add gorm test
* Refactor testing
* Doc format

## go-1.16-r1, go-1.15-r12 (2021/03/10)

* Go 1.16.1, 1.15.9

## go-1.16-r0 (2021/02/16)

* Go 1.16
* Remove Go 1.14 support
* Use docker build push action

## go-1.14-r20, go-1.15-r11 (2021/02/06)

* Go 1.14.15, 1.15.8

## go-1.14-r19, go-1.15-r10 (2021/01/21)

* Go 1.14.14, 1.15.7

## go-1.14-r18, go-1.15-r9 (2020/12/04)

* Go 1.14.13, 1.15.6

## go-1.14-r17, go-1.15-r8 (2020/11/13)

* Go 1.14.12, 1.15.5

## go-1.14-r16, go-1.15-r7 (2020/11/08)

* `1.14.x` and `1.15.x` not published

## base-2.2.0, go-1.14-r15, go-1.15-r6 (2020/11/08)

* Add support for `linux/ppc64le` and `linux/s390x` archs (#18)

## go-1.14-r14, go-1.15-r5 (2020/11/06)

* Go 1.14.11, 1.15.4

## 0.5.0 (2020/11/01)

* Allow to use custom xgo base repo with `docker-repo` flag
* Rename `image` flag to `docker-image` to avoid confusion

## go-1.14-r13, go-1.15-r4 (2020/10/24)

* Go 1.14.10, 1.15.3

## go-1.14-r12, go-1.15-r3 (2020/09/10)

* Go 1.14.9, 1.15.2

## go-1.14-r11, go-1.15-r2 (2020/09/03)

* Go 1.14.8, 1.15.1

## base-2.1.0, go-1.15-r1 (2020/08/12)

* Go 1.15.0
* Remove `darwin/386` support for Go 1.15
* Remove Go 1.13 support

## go-1.13-r19, go-1.14-r10 (2020/08/07)

* Go 1.13.15, 1.14.7

## go-1.13-r18, go-1.14-r9 (2020/07/17)

* Go 1.13.14, 1.14.6

## go-1.13-r17, go-1.14-r8 (2020/07/15)

* Go 1.13.13, 1.14.5

## base-2.0.1, go-1.14-r7, go-1.13-r16, go-1.12-r12 (2020/06/28)

* Fix libc

## 0.4.0, base-2.0.0, go-1.14-r6, go-1.13-r15, go-1.12-r11 (2020/06/27)

* Update dependencies
* Now based on Debian
* Remove Go 1.6, 1.7, 1.8, 1.9, 1.10, 1.11 support

## go-1.13-r14, go-1.14-r5 (2020/05/15)

* Go 1.13.12, 1.14.4

## go-1.13-r13, go-1.14-r4 (2020/05/15)

* Go 1.13.11, 1.14.3

## go-1.13-r12, go-1.14-r3 (2020/04/13)

* Go 1.13.10, 1.14.2

## go-1.13-r11, go-1.14-r2 (2020/03/21)

* Go 1.13.9, 1.14.1

## go-1.14-r1 (2020/02/26)

* Go 1.14

## go-1.12-r10, go-1.13-r10 (2020/02/13)

* Go 1.12.17, 1.13.8

## go-1.12-r9, go-1.13-r9 (2020/01/28)

* Go 1.12.16, 1.13.7

## go-1.12-r8, go-1.13-r8 (2020/01/24)

* Go 1.12.15, 1.13.6
* Stop publishing image on Quay

## go-1.12-r7, go-1.13-r7 (2019/12/05)

* Go 1.12.14, 1.13.5

## go-1.12-r6, go-1.13-r6 (2019/11/03)

* Go 1.12.13, 1.13.4

## go-1.12-r5, go-1.13-r5 (2019/10/18)

* Go 1.12.12, 1.13.3

## go-1.12-r4, go-1.13-r4 (2019/10/17)

* Go 1.12.11, 1.13.2

## go-1.12-r3, go-1.13-r3 (2019/09/26)

* Go 1.12.10, 1.13.1

## 0.3.2 (2019/09/19)

* Useless volume

## 0.3.1 (2019/09/19)

* Move deps cache

## base-1.1.0, go-1.6-r3, go-1.7-r2, go-1.8-r2, go-1.9-r2, go-1.10-r2, go-1.11-r2, go-1.12-r2, go-1.13-r2 (2019/09/19)

* Do not push base version for every release
* Set GOCACHE

## 0.3.0 (2019/09/17)

* Display run command
* Check GOPATH
* Add goproxy option
* Clean base before pushing

## 0.2.0 (2019/09/17)

* Pretty logging

## go-1.12-r1, go-1.11-r1, go-1.10-r1, go-1.9-r1, go-1.8-r1, go-1.7-r1, go-1.6-r2 (2019/09/17)

* Add workflows for all Go versions

## go-1.6-r1 (2019/09/16)

* Add Go 1.6 workflow
* Drop Go 1.5

## base-1.0.0 (2019/09/16)

* Drop Go 1.3 and 1.4
* Add workflow to build base

## 0.1.0 (2019/09/16)

* Add GitHub Action to create xgo binary release
* Remove iOS and Android support
* Add `libz-mingw-w64-dev`
* Fix cache folder location for deps
* Fix `EXT_GOPATH`

## 2019/09/15

* Add Go 1.13
* Update Go 1.12
* Update Go 1.11

## 2019/06/20

* Add Go 1.12

## 2019/02/15

* Update links
* Add kolaente/xgo#1 for go modules support

## 2019/02/04

* Switch to TravisCI (com)

## 2018/10/21

* Add Go 1.11.1

## 2018/09/17

* Update testsuite
* Add cmake
* Alternative iOS SDK url
* [Single repo](https://hub.docker.com/r/crazymax/xgo/) on DockerHub
* Add Go 1.11
* Use travis to build images
* Fork of [karalabe/xgo](https://github.com/karalabe/xgo)
