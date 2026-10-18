# pwsh/.internal/tests/Initialize-Types.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
L1: each case loads a fixture DLL, so the file is locked for the process lifetime. Fixtures live OUTSIDE TestDrive, in a
self-managed temp dir cleaned best-effort. The pending record and the lookup hook are session state: saved, replaced by
a fresh record per case, and restored after.
```
