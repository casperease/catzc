---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-TestSkipReason.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: get-test-skip-reason-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "59aaebf1313b"
---

# automation/Catzc.Base.QualityGates/tests/Get-TestSkipReason.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function New-FakeSkip {`, written with `#`.

```text
A Pester test-result object carries .ErrorRecord (a collection of records each exposing
.Exception.Message). A discovery `It -Skip` records nothing; pass -NoRecord for that shape.
```
