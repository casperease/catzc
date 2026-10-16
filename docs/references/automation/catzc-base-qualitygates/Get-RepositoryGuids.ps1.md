---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Get-RepositoryGuids.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates
    name: get-repository-guids-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "5bb69339ffa7"
---

# automation/Catzc.Base.QualityGates/Get-RepositoryGuids.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$text = [System.IO.File]::ReadAllText($fullPath)`, written with `#`.

```text
Read the whole file and match once, rather than regex-per-line: a single scan over the text is
~3x faster than N per-line Matches calls (the per-line managed/native transitions dominated).
Line numbers are recovered from each match's offset — matches arrive in ascending index order, so
one forward cursor counts the newlines between consecutive matches, touching each char at most once.
```
