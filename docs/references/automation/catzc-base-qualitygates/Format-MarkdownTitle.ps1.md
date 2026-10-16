---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Format-MarkdownTitle.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "85ca84513188"
    adrs:
      - ADR-AUTO-DRYRUN#2
---

# automation/Catzc.Base.QualityGates/Format-MarkdownTitle.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Format-MarkdownTitle {`, written with `#`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
```
