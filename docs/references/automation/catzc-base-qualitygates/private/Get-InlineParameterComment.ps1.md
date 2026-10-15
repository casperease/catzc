---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-InlineParameterComment.ps1.md
    kind: comment-page
    body_sha: "8790b4ecbcbf"
    adrs:
      - ADR-REPO-HELP#3
    links: []
---

# automation/Catzc.Base.QualityGates/private/Get-InlineParameterComment.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A trailing comment after code is not one: only a comment alone on its line, in an unbroken run that ends on the line above the parameter.
[ADR-REPO-HELP#3](/docs/adr/repository/function-help.md#rule-adr-repo-help3)
```
