---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Save-TestDurationHistory.Tests.ps1.md
    kind: test-asset
    body_sha: "753d0e65b34b"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Save-TestDurationHistory.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Save-TestDurationHistory' -Tag 'L0', 'logic' {`.

```text
The per-machine test duration history: Save-TestDurationHistory merges a run's measurements, Get-TestDurationHistory
reads them back. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
