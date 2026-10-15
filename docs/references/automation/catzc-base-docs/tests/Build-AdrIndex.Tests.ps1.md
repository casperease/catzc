---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Build-AdrIndex.Tests.ps1.md
    kind: test-asset
    body_sha: f4a6feb6b284
---

# automation/Catzc.Base.Docs/tests/Build-AdrIndex.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$result = Test-GeneratedFiles -Generator Build-AdrIndex -PassThru...`.

```text
The importer's janitor tail materialised [index](/docs/adr/index.md) before this run; the gate checks it
without writing.
```
