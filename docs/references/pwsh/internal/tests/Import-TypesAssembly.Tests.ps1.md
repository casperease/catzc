# pwsh/.internal/tests/Import-TypesAssembly.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
L1: the fixture DLL is compiled once with Add-Type (Roslyn's cold start). The source DLL lives in TestDrive —
it is never loaded, which is the property under test. The shadow folder lives OUTSIDE TestDrive: the loaded
copy stays locked for the process lifetime on Windows, so TestDrive's teardown could not delete it.
```
