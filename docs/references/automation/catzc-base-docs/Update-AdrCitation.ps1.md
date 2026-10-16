---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Update-AdrCitation.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "34bd7cce88d8"
---

# automation/Catzc.Base.Docs/Update-AdrCitation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$bytes = [System.IO.File]::ReadAllBytes($file)`, written with `#`.

```text
Decode strictly, so a file that is not UTF-8 fails here instead of being re-encoded; the byte order mark is
kept aside and written back as it was.
```
