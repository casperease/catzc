# pwsh/.internal/tests/Invoke-CatzcCommand.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `function script:Start-LockHolder {`, written with `#`.

```text
Holds the lock on another thread for the given milliseconds, the way another run would, or until its Release is set:
a test that must see the lock still held when its wait ends releases it itself, so a slow start under load never
lets the hold run out first.
```
