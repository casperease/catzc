---
catzc:
  immutable:
    with_body_sha: "8e1c270981fa"
    path: docs/references/automation/catzc-base-qualitygates/tests/ConvertTo-TestAutomationRowSet.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: convert-to-test-automation-row-set-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/tests/ConvertTo-TestAutomationRowSet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function New-FakeTest {`, written with `#`.

```text
Build a Pester-shaped test-result object without running Pester — just the members the reducer
reads (Result, Duration, ExpandedPath/Name, ErrorRecord, the Block tag chain, ScriptBlock file/line).
```
