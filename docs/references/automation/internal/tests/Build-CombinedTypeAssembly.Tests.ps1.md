---
catzc:
  derived:
    path: docs/references/automation/internal/tests/Build-CombinedTypeAssembly.Tests.ps1.md
    kind: test-asset
    body_sha: "6133b0e2728a"
---

# automation/.internal/tests/Build-CombinedTypeAssembly.Tests.ps1

<!-- cspell:ignore npublic -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
L1: the first Add-Type pays Roslyn's cold start. The assembly is written with -OutputAssembly and never
loaded, so the DLL is not locked and lives in TestDrive. A per-run namespace keeps the "not loaded" assertion
true on a second run in the same session.
```

## comment:2

Above `$raceRoot = Join-Path $TestDrive 'race'`.

```text
Another session saving a .cs mid-compile: the live file turns into code that does not compile the moment the
compiler starts. A compile of the frozen copy neither sees it nor names its DLL for bytes it did not compile.
```
