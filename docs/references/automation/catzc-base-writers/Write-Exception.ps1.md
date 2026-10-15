---
catzc:
  derived:
    path: docs/references/automation/catzc-base-writers/Write-Exception.ps1.md
    kind: comment-page
    body_sha: "1d08bf3bf03c"
    adrs: []
    links: []
---

# automation/Catzc.Base.Writers/Write-Exception.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Prints exception type, message, script stack trace, and any inner exceptions.
Falls back to $global:Error if no ErrorRecord is provided.
```
