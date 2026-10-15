---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Format-FileMeta.ps1.md
    kind: comment-page
    body_sha: "5cff9835113f"
    adrs:
      - ADR-AUTO-DRYRUN#2
    links: []
---

# automation/Catzc.Base.QualityGates/Format-FileMeta.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The output is byte-identical on every run, so a second run changes no file. The authored `config` part is kept as written, and a
file whose block holds a key no meta kind owns is reported and left unchanged.
```

## comment:2

Above `function Format-FileMeta {`.

```text
The repository's preview switch is -DryRun, so ShouldProcess and -WhatIf are deliberately absent.
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2)
```
