---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-FileMetaScope.ps1.md
    kind: reference
    body_sha: b97b5bdfd067
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Get-FileMetaScope.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A file is in scope when its class has a front-matter or comment-head carrier, the class does not leave it out, an imprint kind's
globs match it, and `.gitattributes` does not exempt it or opt it out.
```
