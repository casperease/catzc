---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestSkipReason.ps1.md
    kind: comment-page
    body_sha: "175d9690ba1a"
---

# automation/Catzc.Base.QualityGates/private/Get-TestSkipReason.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `if ($message -match 'because\s+(.+?)\s*$') {`.

```text
Set-ItResult renders "is skipped, because <reason>" — pull out the reason. Capture $Matches
immediately (it is clobbered by the next -match; see automatic-variable-pitfalls).
```
