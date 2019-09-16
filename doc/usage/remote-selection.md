# Remote selection

Yet again similarly to `go get`, xgo uses the repository remote corresponding to
the import path being built. To switch to a different remote while preserving the
original import path, use the `--remote` argument.

    $ xgo --remote github.com/golang/tools golang.org/x/tools/cmd/goimports
    ...
