# Branch selection

Similarly to `go get`, xgo also uses the `master` branch of a repository during
source code retrieval. To switch to a different branch before compilation pass
the desired branch name through the `--branch` argument.

    $ xgo --branch release-branch.go1.4 golang.org/x/tools/cmd/goimports
    ...

    $ ls -al
    -rwxr-xr-x  1 root  root   4139868 Nov 24 16:40 goimports-darwin-10.6-386
    -rwxr-xr-x  1 root  root   5186720 Nov 24 16:40 goimports-darwin-10.6-amd64
    -rwxr-xr-x  1 root  root   4189456 Nov 24 16:40 goimports-linux-386
    -rwxr-xr-x  1 root  root   5264136 Nov 24 16:40 goimports-linux-amd64
    -rwxr-xr-x  1 root  root   4209416 Nov 24 16:40 goimports-linux-arm
    -rwxr-xr-x  1 root  root   4348416 Nov 24 16:40 goimports-windows-4.0-386.exe
    -rwxr-xr-x  1 root  root   5415424 Nov 24 16:40 goimports-windows-4.0-amd64.exe
