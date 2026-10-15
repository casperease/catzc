---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestAutomationVerdict.ps1.md
    kind: comment-page
    body_sha: "5d68e77f4fec"
    adrs:
      - ADR-AUTO-XPLAT#6
---

# automation/Catzc.Base.QualityGates/private/Get-TestAutomationVerdict.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$seconds = [math]::Round($DurationSeconds,...`.

```text
Invariant so the duration reads the same on any devbox culture
([ADR-AUTO-XPLAT#6](/docs/adr/automation/cross-platform.md#rule-adr-auto-xplat6)) — a da-DK box would
otherwise render '42,3s' and diverge from CI's '42.3s'.
```
