# Build flags

A handful of flags can be passed to `go build`. The currently supported ones are:

* `-v`: prints the names of packages as they are compiled
* `-x`: prints the build commands as compilation progresses
* `-race`: enables data race detection (supported only on amd64, rest built without)
* `-tags=<tag list>`: list of build tags to consider satisfied during the build
* `-ldflags=<flag list>`: arguments to pass on each go tool link invocation
* `-buildmode=<mode>`: binary type to produce by the compiler
* `-buildvcs=<value>`: whether to stamp binaries with version control information
