---
catzc:
  immutable:
    with_body_sha: "8f70d553c67f"
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-TestExcludeTag.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: get-test-exclude-tag-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-TestExcludeTag' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-TestExcludeTag is private (the tier/category -> ExcludeTag logic shared by Test-Automation and
Test-InIsolation). Tested via InModuleScope.
```
