---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Format-MarkdownTitle.ps1.md
    kind: comment-page
    body_sha: d95eb608bec8
    adrs:
      - ADR-AUTO-DRYRUN#2
---

# automation/Catzc.Base.QualityGates/Format-MarkdownTitle.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `function Format-MarkdownTitle {`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
```
