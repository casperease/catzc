---
catzc:
  derived:
    path: docs/references/automation/internal/tests/Import-TypesAssembly.Tests.ps1.md
    kind: test-asset
    body_sha: ed50dd29f07a
---

# automation/.internal/tests/Import-TypesAssembly.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
L1: the fixture DLL is compiled once with Add-Type (Roslyn's cold start). The source DLL lives in TestDrive —
it is never loaded, which is the property under test. The shadow folder lives OUTSIDE TestDrive: the loaded
copy stays locked for the process lifetime on Windows, so TestDrive's teardown could not delete it.
```
