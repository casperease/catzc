---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-TestSkipReason.Tests.ps1.md
    kind: test-asset
    body_sha: cc10a76b790f
---

# automation/Catzc.Base.QualityGates/tests/Get-TestSkipReason.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `function New-FakeSkip {`.

```text
A Pester test-result object carries .ErrorRecord (a collection of records each exposing
.Exception.Message). A discovery `It -Skip` records nothing; pass -NoRecord for that shape.
```
