---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestLevelTag.ps1.md
    kind: comment-page
    body_sha: cb5133273c84
    adrs: []
    links: []
---

# automation/Catzc.Base.QualityGates/private/Get-TestLevelTag.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Returns the single tier tag for a test — nearest contributing block wins (innermost override). Returns
$null when no block in the chain carries a tier tag, or when the nearest contributing block carries more
than one (ambiguous); both are tagging violations surfaced by Get-TestTagViolations. The tier tag is
mandatory — there is no default (see the test-automation ADR). Shares the block walk with
Get-TestCategoryTag via Get-TestBlockTag, and feeds Test-Automation's timing report and
Write-TestAutomationReport.
```
