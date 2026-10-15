---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-ImprintStepFile.ps1.md
    kind: comment-page
    body_sha: "871bf5819d4d"
    adrs:
      - ADR-REPO-FORMAT#8
    links: []
---

# automation/Catzc.Base.QualityGates/private/Get-ImprintStepFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A step is never named by a language: which languages it covers is configuration, so this only answers which files the step reads.
[ADR-REPO-FORMAT#8](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8)
```
