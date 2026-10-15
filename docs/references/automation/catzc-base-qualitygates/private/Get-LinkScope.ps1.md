---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-LinkScope.ps1.md
    kind: comment-page
    body_sha: "9ebb1542c935"
---

# automation/Catzc.Base.QualityGates/private/Get-LinkScope.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$isDiskRoot = {`.

```text
Never enumerate a whole drive: neither the repository root nor a -Path may be a disk root (C:\, /, a UNC
share root). A relative -Path resolves against the current location, so '.' run from C:\ would be all of C:.
```
