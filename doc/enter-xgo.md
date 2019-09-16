# Enter xgo

My solution to the challenge of cross compiling Go code with embedded C/C++ snippets
(i.e. CGO_ENABLED=1) is based on the concept of [lightweight Linux containers](http://en.wikipedia.org/wiki/LXC).
All the necessary Go tool-chains, C cross compilers and platform headers/libraries
have been assembled into a single Docker container, which can then be called as if
a single command to compile a Go package to various platforms and architectures.
