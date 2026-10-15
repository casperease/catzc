---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-FilePathFileMetaFact.ps1.md
    kind: reference
    body_sha: "82f63ed2a0e8"
    adrs:
      - ADR-REPO-FORMAT#6
---

# automation/Catzc.Base.QualityGates/private/Get-FilePathFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The path is a derived fact, so a moved file drifts and the formatter rewrites it; the H1 is the file's title, never its path
([ADR-REPO-FORMAT#6](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format6)).
```
