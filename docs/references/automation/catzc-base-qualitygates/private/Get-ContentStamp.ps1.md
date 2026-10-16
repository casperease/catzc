---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-ContentStamp.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e041f22782a3
---

# automation/Catzc.Base.QualityGates/private/Get-ContentStamp.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$previousWasLineEnd = $true`, written with `#`.

```text
Comments go; a run of line ends (what a removed comment line leaves) counts as one, since a line
end separates statements but a blank line does not.
```
