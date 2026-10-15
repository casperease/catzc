---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Format-MarkdownTitle.Tests.ps1.md
    kind: test-asset
    body_sha: b27a8e48c42b
---

# automation/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Mock Get-MarkdownScope { , [string[]] @('docs/widget.md') } -ModuleName...`.

```text
Filter on the bound parameters, not on $Path: an unbound -Path resolves $Path from a caller's scope (the test
runner's own $Path), which would send the engine's whole-scope call to this narrowed mock too.
```
