# pwsh/.internal/tests/Wait-CatzcRunLock.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function script:Start-LockHolder {`, written with `#`.

```text
Holds the lock on another thread for the given milliseconds, the way a plain run would; with -Burst, it is a burst that ends
when it lets go.
```
