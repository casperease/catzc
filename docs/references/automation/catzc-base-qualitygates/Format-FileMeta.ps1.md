---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Format-FileMeta.ps1.md
    kind: comment-page
    body_sha: b885b6b8b4d0
    adrs:
      - ADR-AUTO-DRYRUN#2
---

# automation/Catzc.Base.QualityGates/Format-FileMeta.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `function Format-FileMeta {`.

```text
The repository's preview switch is -DryRun, so ShouldProcess and -WhatIf are deliberately absent.
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2)
```
