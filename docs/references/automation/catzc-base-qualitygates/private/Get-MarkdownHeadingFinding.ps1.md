---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownHeadingFinding.ps1.md
    kind: comment-page
    body_sha: "8256dd0388d7"
---

# automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$head = $Matches['head']`.

```text
Capture before the next -match overwrites $Matches
([ADR-PWSH-AUTOVAR](/docs/adr/pwsh/automatic-variable-pitfalls.md)).
```
