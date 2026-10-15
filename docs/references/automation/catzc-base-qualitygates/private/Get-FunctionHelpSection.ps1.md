---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-FunctionHelpSection.ps1.md
    kind: comment-page
    body_sha: a3f2c3027cf1
    adrs:
      - ADR-REPO-HELP#1
    links: []
---

# automation/Catzc.Base.QualityGates/private/Get-FunctionHelpSection.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Lines are kept exactly as written, so rendering the sections back in their order reproduces the block.
[ADR-REPO-HELP#1](/docs/adr/repository/function-help.md#rule-adr-repo-help1)
```
