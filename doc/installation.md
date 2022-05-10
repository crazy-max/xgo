# Installation

Although you could build the container manually, it is available as an automatic
trusted build from Docker's container registry (not insignificant in size):

```shell
docker pull crazymax/xgo:latest
```

To prevent having to remember a potentially complex Docker command every time,
a lightweight Go wrapper was written on top of it.

```shell
go get github.com/crazy-max/xgo
```

For go 1.17 or up, `go get` is deprecated, so you'll have to use this command:

```shell
go install github.com/crazy-max/xgo@latest
```
