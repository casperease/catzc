---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownScope.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: a9cdfaf77fc2
---

# automation/Catzc.Base.QualityGates/private/Get-MarkdownScope.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$exemptPaths = Get-ContentExemptPath -RepositoryRoot $root -Path $markdown`, written with `#`.

```text
Every class comes from .gitattributes.
Get-ContentExemptPath returns its paths as one array: assign it, so the set holds the paths, not the array.
```
