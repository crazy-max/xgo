# Output prefixing

xgo by default uses the name of the package being cross compiled as the output
file prefix. This can be overridden with the `-out` flag.

```shell
xgo -out iris-v0.3.2 github.com/project-iris/iris
...
ls -al
```
```text
-rwxr-xr-x  1 root  root   6776500 Nov 24 16:44 iris-v0.3.2-darwin-386
-rwxr-xr-x  1 root  root   8755532 Nov 24 16:44 iris-v0.3.2-darwin-amd64
-rwxr-xr-x  1 root  root  10135248 Nov 24 16:44 iris-v0.3.2-linux-386
-rwxr-xr-x  1 root  root  12598472 Nov 24 16:44 iris-v0.3.2-linux-amd64
-rwxr-xr-x  1 root  root  10040464 Nov 24 16:44 iris-v0.3.2-linux-arm
-rwxr-xr-x  1 root  root   7516368 Nov 24 16:44 iris-v0.3.2-windows-386.exe
-rwxr-xr-x  1 root  root   9549416 Nov 24 16:44 iris-v0.3.2-windows-amd64.exe
```
