---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/ConvertTo-TestAutomationRowSet.Tests.ps1.md
    kind: test-asset
    body_sha: "76c275734d53"
---

# automation/Catzc.Base.QualityGates/tests/ConvertTo-TestAutomationRowSet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `function New-FakeTest {`.

```text
Build a Pester-shaped test-result object without running Pester — just the members the reducer
reads (Result, Duration, ExpandedPath/Name, ErrorRecord, the Block tag chain, ScriptBlock file/line).
```
