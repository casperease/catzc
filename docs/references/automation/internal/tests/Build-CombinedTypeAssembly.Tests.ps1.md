---
catzc:
  immutable:
    with_body_sha: f3308993ccf7
    repo_status: locked
    path: docs/references/automation/internal/tests/Build-CombinedTypeAssembly.Tests.ps1.md
    folder: docs/references/automation/internal/tests
    name: build-combined-type-assembly-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/.internal/tests/Build-CombinedTypeAssembly.Tests.ps1

<!-- cspell:ignore npublic -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {` (occurrence 2), written with `#`.

```text
L1: the first Add-Type pays Roslyn's cold start. The assembly is written with -OutputAssembly and never
loaded, so the DLL is not locked and lives in TestDrive. A per-run namespace keeps the "not loaded" assertion
true on a second run in the same session.
```

## comment:2

Above `$raceRoot = Join-Path $TestDrive 'race'`, written with `#`.

```text
Another session saving a .cs mid-compile: the live file turns into code that does not compile the moment the
compiler starts. A compile of the frozen copy neither sees it nor names its DLL for bytes it did not compile.
```
