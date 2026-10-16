---
catzc:
  immutable:
    with_body_sha: "17f14415274e"
    path: docs/references/automation/catzc-base-qualitygates/Format-FileMeta.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates
    name: format-file-meta-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-DRYRUN#2
---

# automation/Catzc.Base.QualityGates/Format-FileMeta.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Format-FileMeta {`, written with `#`.

```text
The repository's preview switch is -DryRun, so ShouldProcess and -WhatIf are deliberately absent.
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2)
```
