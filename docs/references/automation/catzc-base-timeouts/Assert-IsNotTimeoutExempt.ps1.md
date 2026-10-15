---
catzc:
  derived:
    path: docs/references/automation/catzc-base-timeouts/Assert-IsNotTimeoutExempt.ps1.md
    kind: comment-page
    body_sha: "5746782e858a"
---

# automation/Catzc.Base.Timeouts/Assert-IsNotTimeoutExempt.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
For work that must never run exempt — for example a quality gate in a pipeline, where an exemption would hide
a regression. Throws naming the exemption's reason when the budget is exempt; Get-TimeoutExemption defines the
lookup.
```
