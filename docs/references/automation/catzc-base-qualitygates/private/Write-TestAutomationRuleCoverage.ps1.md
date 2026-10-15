---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationRuleCoverage.ps1.md
    kind: comment-page
    body_sha: cba2a72de7ca
---

# automation/Catzc.Base.QualityGates/private/Write-TestAutomationRuleCoverage.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$testEnforcers = @{}`.

```text
Enforcers per rule id, split by kind. Sets so a rule cited by many tests, or an analyzer listed twice,
counts each enforcer once.
```
