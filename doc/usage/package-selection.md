# Package selection

If you used the above *branch* or *remote* selection machanisms, it may happen
that the path you are trying to build is only present in the specific branch and
not the default repository, causing Go to fail at locating it. To circumvent this,
you may specify only the repository root for xgo, and use an additional `--pkg`
parameter to select the exact package within, honoring any prior *branch* and
*remote* selections.

```shell
xgo --pkg cmd/goimports golang.org/x/tools
...
ls -al
```
```text
-rwxr-xr-x  1 root  root   4164448 Nov 24 16:38 goimports-darwin-10.6-386
-rwxr-xr-x  1 root  root   5223584 Nov 24 16:38 goimports-darwin-10.6-amd64
-rwxr-xr-x  1 root  root   4217184 Nov 24 16:38 goimports-linux-386
-rwxr-xr-x  1 root  root   5295768 Nov 24 16:38 goimports-linux-amd64
-rwxr-xr-x  1 root  root   4233120 Nov 24 16:38 goimports-linux-arm
-rwxr-xr-x  1 root  root   4373504 Nov 24 16:38 goimports-windows-4.0-386.exe
-rwxr-xr-x  1 root  root   5450240 Nov 24 16:38 goimports-windows-4.0-amd64.exe
```

This argument may at some point be integrated into the import path itself, but for
now it exists as an independent build parameter. Also, there is not possibility
for now to build mulitple commands in one go.
