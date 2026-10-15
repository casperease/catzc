---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Write-TestRunFailures.Tests.ps1.md
    kind: test-asset
    body_sha: b8be116ebfe7
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Write-TestRunFailures.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Write-TestRunFailures' -Tag 'L0', 'logic' {`.

```text
Write-TestRunFailures over fixture rows and file entries, with the console seam (Write-Message / Write-Header /
Write-Footer) mocked and its lines collected. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
