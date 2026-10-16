---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-LinkScope.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: aa98ed33c436
---

# automation/Catzc.Base.QualityGates/private/Get-LinkScope.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$isDiskRoot = {`, written with `#`.

```text
Never enumerate a whole drive: neither the repository root nor a -Path may be a disk root (C:\, /, a UNC
share root). A relative -Path resolves against the current location, so '.' run from C:\ would be all of C:.
```
