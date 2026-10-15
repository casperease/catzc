---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Assert-ManagedGuid.ps1.md
    kind: comment-page
    body_sha: "5052bd9a2ea0"
    adrs: []
---

# automation/Catzc.Base.QualityGates/Assert-ManagedGuid.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The throwing counterpart of Test-ManagedGuid; both share one lookup (Resolve-ManagedGuid), so they can
never disagree. Comparison is case-insensitive by [guid] value. Succeeds silently — the absence of an
error is the output.
```
