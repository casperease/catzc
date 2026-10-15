---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-FileMetaFact.ps1.md
    kind: comment-page
    body_sha: b938481cef10
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Get-FileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Each kind's processor is the function the registry names, found in this module's scope; a kind with no such function fails the
run and names the function it expected. A processor must return exactly the keys its kind declares, so a kind can never write a
key another kind owns. The facts come back in registry order, which is the order they are written.
```
