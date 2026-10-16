---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestSkipReason.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: b9c07e667d0e
---

# automation/Catzc.Base.QualityGates/private/Get-TestSkipReason.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($message -match 'because\s+(.+?)\s*$') {`, written with `#`.

```text
Set-ItResult renders "is skipped, because <reason>" — pull out the reason. Capture $Matches
immediately (it is clobbered by the next -match; see automatic-variable-pitfalls).
```
