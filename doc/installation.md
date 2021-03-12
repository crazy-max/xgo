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
