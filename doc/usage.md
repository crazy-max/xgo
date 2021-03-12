# Usage

Simply specify the import path you want to build, and xgo will do the rest:

```shell
xgo github.com/project-iris/iris
...
ls -al
```
```text
-rwxr-xr-x  1 root  root    6776500 Nov 24 16:44 iris-darwin-10.6-386
-rwxr-xr-x  1 root  root    8755532 Nov 24 16:44 iris-darwin-10.6-amd64
-rwxr-xr-x  1 root  root   10135248 Nov 24 16:44 iris-linux-386
-rwxr-xr-x  1 root  root   12598472 Nov 24 16:44 iris-linux-amd64
-rwxr-xr-x  1 root  root   10040464 Nov 24 16:44 iris-linux-arm
-rwxr-xr-x  1 root  root    7516368 Nov 24 16:44 iris-windows-4.0-386.exe
-rwxr-xr-x  1 root  root    9549416 Nov 24 16:44 iris-windows-4.0-amd64.exe
```

If the path is not a canonical import path, but rather a local path (starts with
a dot `.` or a dash `/`), xgo will use the local GOPATH contents for the cross
compilation.
