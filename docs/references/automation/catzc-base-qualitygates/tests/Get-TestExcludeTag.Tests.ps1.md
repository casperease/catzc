---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-TestExcludeTag.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "8f70d553c67f"
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
